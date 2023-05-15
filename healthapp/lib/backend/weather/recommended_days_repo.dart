import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/backend/weather/weather.dart';
import 'package:healthapp/services/auth/auth/firebase_auth_provider.dart';
import 'package:healthapp/util/weatherPreferences.dart';

import '../../util/weatherInformation.dart';
import '../../util/weatherType.dart';
import 'package:intl/intl.dart';

import '../../util/weatherVisuals.dart';
import '../location/location.dart';

class PointsData {
  final double windPoints;
  final double temperaturePoints;
  final double snowPoints;
  final double cloudCoverPoints;
  final double precipitationPoints;

  double getTotalPoints() {
    return windPoints +
        temperaturePoints +
        snowPoints +
        cloudCoverPoints +
        precipitationPoints;
  }

  PointsData(
      {required this.windPoints,
      required this.temperaturePoints,
      required this.snowPoints,
      required this.cloudCoverPoints,
      required this.precipitationPoints});
}

class RecommendedDaysRepo {
  final ApiParser apiClient;

  final FirebaseAuthProvider provider = FirebaseAuthProvider();

  final CollectionReference instance =
      FirebaseFirestore.instance.collection('UserWeatherPreferences');

  RecommendedDaysRepo({required this.apiClient}) : assert(apiClient != null);

  double proximityWeight(double diff, double k, double limit) {
    double funcVal = (diff * k).abs() - limit * k;
    return max(funcVal, 0);
  }

  PointsData calculatePoints(
      WeatherInformation weatherData, WeatherPreferences weatherPreferences) {
    // Wind
    double windPoints =
        -(weatherData.windspeed - weatherPreferences.windPref).abs();

    // Temperature
    //points -= pow((weatherData.temperature - idealTemperature).abs().round()/2, 2);
    double tempPoints =
        -(weatherData.temperature - weatherPreferences.targetTemp).abs() * 3;
    //points += proximityWeight((weatherData.temperature - idealTemperature).abs(), 1, 0.5);

    // Snow depth
    double snowPoints = 0;
    if (weatherData.snow_depth > 0 && weatherPreferences.avoidSnow) {
      snowPoints = -15;
    }

    // Precipitation
    double precipitationPoints =
        -(weatherData.precipitation * weatherPreferences.rainPref * 2);

    // Cloud cover
    double cloudPoints =
        -(weatherData.cloudcover - weatherPreferences.cloudPref).abs() * 0.1;

    return PointsData(
        windPoints: windPoints,
        temperaturePoints: tempPoints,
        snowPoints: snowPoints,
        cloudCoverPoints: cloudPoints,
        precipitationPoints: precipitationPoints);
  }

  Future<List<RecommendedIntervals>> getRecommended(int amount) async {
    Location loc = await Location.getInstance();
    List<WeatherInformation> weatherList =
        await apiClient.requestWeather(loc.latitude, loc.longitude);
    WeatherPreferences? preferences = await getUserPreferences();
    preferences ??= WeatherPreferences(18, true, 0, 25, 0, TimeOfDay(hour: 4, minute: 59), TimeOfDay(hour: 22, minute: 01));

    List<RecommendedTime> recommended = [];
    for (WeatherInformation weather in weatherList) {
      PointsData points = calculatePoints(weather, preferences);
      recommended.add(RecommendedTime(weather, points));
    }

    final List<List<RecommendedTime>> clusters = clusterTimes(recommended, preferences.startTime, preferences.endTime);

    // Sort clusters by the average points
    clusters.sort((a, b) =>
        (b.fold(0.0, (sum, e) => sum + e.points.getTotalPoints()) / b.length -
                a.fold(0.0, (sum, e) => sum + e.points.getTotalPoints()) /
                    a.length)
            .toInt());

    List<List<RecommendedTime>> topClusters = clusters.take(amount).toList();
    topClusters.sort((a, b) {
      final startTimeA = DateTime.parse(a.first.weather.time);
      final startTimeB = DateTime.parse(b.first.weather.time);
      return startTimeA.compareTo(startTimeB);
    });

    List<RecommendedIntervals> recommendedIntervals = [];
    final DateFormat format = DateFormat('EEEE');
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    for (List<RecommendedTime> cluster in topClusters) {
      final start = DateTime.parse(cluster.first.weather.time);
      final end = DateTime.parse(cluster.last.weather.time);

      String dayName;
      if (start.day == now.day &&
          start.month == now.month &&
          start.year == now.year) {
        dayName = "Today";
      } else if (start.day == tomorrow.day &&
          start.month == tomorrow.month &&
          start.year == tomorrow.year) {
        dayName = "Tomorrow";
      } else {
        final date = DateTime.parse(cluster.first.weather.time);
        dayName = "${format.format(date)} (${DateFormat('d/M').format(date)})";
      }

      recommendedIntervals.add(RecommendedIntervals(
          dayName,
          start.hour != end.hour
              ? "${start.hour}:00 - ${end.hour}:00"
              : "${start.hour}:00",
          "${(cluster.fold(0.0, (sum, e) => sum + e.weather.temperature) / cluster.length).toStringAsFixed(1)}°C",
          "${(cluster.fold(0.0, (sum, e) => sum + e.weather.windspeed) / cluster.length).toStringAsFixed(1)} m/s",
          "${(cluster.fold(0.0, (sum, e) => sum + e.weather.precipitation) / cluster.length).toStringAsFixed(1)}mm",
          cluster.map((x) => x.points).toList(),
          WeatherVisuals.getWeatherIcons(
              cluster.map((x) => x.weather.weather).toSet())));
    }

    return recommendedIntervals;
  }

  // Cluster times into intervals
  List<List<RecommendedTime>> clusterTimes(
      List<RecommendedTime> recommendedTimes, TimeOfDay sT, TimeOfDay eT) {
    List<List<RecommendedTime>> clusters = [];
    List<RecommendedTime> currentCluster = [];
    for (int i = 0; i < recommendedTimes.length; i++) {
      DateTime date = DateTime.parse(recommendedTimes[i].weather.time);

      DateTime startTime = DateTime(date.year, date.month, date.day, sT.hour, sT.minute);
      DateTime endTime = DateTime(date.year, date.month, date.day, eT.hour, eT.minute);

      if (date.isAfter(startTime) && date.isBefore(endTime)) {
        if (currentCluster.isEmpty) {
          currentCluster.add(recommendedTimes[i]);
        } else if ((currentCluster.last.points.getTotalPoints() -
                    recommendedTimes[i].points.getTotalPoints())
                .abs() <=
            2.5) {
          currentCluster.add(recommendedTimes[i]);
        } else if (currentCluster.isNotEmpty) {
          clusters.add(currentCluster.toList());
          currentCluster.clear();
        }
      }
    }

    return clusters;
  }

  Future<void> savePreferences(WeatherPreferences weatherPreferences) async {
    final currentUserId = provider.currentUser?.id;
    await instance.doc(currentUserId).set({
      'targetTemp': weatherPreferences.targetTemp,
      'avoidSnow': weatherPreferences.avoidSnow,
      'rainPref': weatherPreferences.rainPref,
      'cloudPref': weatherPreferences.cloudPref,
      'windPref': weatherPreferences.windPref,
      'startTime': formattedTimeOfDay(weatherPreferences.startTime),
      'endTime': formattedTimeOfDay(weatherPreferences.endTime),
    });
  }

String formattedTimeOfDay(TimeOfDay timeOfDay) {
  final hour = timeOfDay.hour.toString().padLeft(2, '0');
  final minute = timeOfDay.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

  Future<WeatherPreferences> getUserPreferences() async {
    final currentUserId = provider.currentUser?.id;
    final snapshot = await instance.doc(currentUserId).get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        return WeatherPreferences.fromMap(data);
      } else {
        return WeatherPreferences(18, false, 0, 25, 0, const TimeOfDay(hour: 4, minute: 59), const TimeOfDay(hour: 22, minute: 01));
      }
    } else {
      return WeatherPreferences(18, false, 0, 25, 0, const TimeOfDay(hour: 4, minute: 59), const TimeOfDay(hour: 22, minute: 01));
    }
  }
}

class RecommendedTime {
  final WeatherInformation weather;
  final PointsData points;

  RecommendedTime(this.weather, this.points);
}

// For the frontend
class RecommendedIntervals {
  final String dayName;
  final String interval;
  final String temperature;
  final String windspeed;
  final String precipitation;
  final List<PointsData> points;
  final Set<AssetImage> weatherTypeIcons;

  RecommendedIntervals(this.dayName, this.interval, this.temperature,
      this.windspeed, this.precipitation, this.points, this.weatherTypeIcons);
}
