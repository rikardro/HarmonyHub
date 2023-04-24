import 'dart:math';

import 'package:healthapp/backend/weather/weather.dart';

import '../../util/weatherInformation.dart';
import '../../util/weatherType.dart';
import 'package:intl/intl.dart';

class PointsData{
  final double windPoints;
  final double temperaturePoints;
  final double snowPoints;
  final double weatherTypePoints;
  final double precipitationPoints;

  double getTotalPoints(){
    return windPoints + temperaturePoints + snowPoints + weatherTypePoints + precipitationPoints;
  }

  void printPoints(){
    print("POINTS!:::");
    print("Wind: $windPoints");
    print("Temperature: $temperaturePoints");
    print("Snow: $snowPoints");
    print("Weather: $weatherTypePoints");
    print("Precipitation: $precipitationPoints");
    print("--------------------");
  }

  PointsData({required this.windPoints, required this.temperaturePoints, required this.snowPoints, required this.weatherTypePoints, required this.precipitationPoints});
}

class RecommendedDaysRepo {
  final ApiParser apiClient;

  RecommendedDaysRepo({required this.apiClient}) : assert(apiClient != null);

  double proximityWeight(double diff, double k, double limit){
    double funcVal = (diff * k).abs() - limit * k;
    return max(funcVal, 0);
  }

  PointsData calculatePoints(WeatherInformation weatherData, {int idealTemperature = 18}) {

    // Wind
    double windPoints = -(weatherData.windspeed / 5);

    // Temperature
    //points -= pow((weatherData.temperature - idealTemperature).abs().round()/2, 2);
    double tempPoints = -(weatherData.temperature - idealTemperature).abs() * 3;
    //points += proximityWeight((weatherData.temperature - idealTemperature).abs(), 1, 0.5);

    // Snow depth
    double snowPoints = 0;
    if (weatherData.snow_depth > 0) {
      snowPoints = -10;
    }

    // Weather type
    Map<WeatherType, double> weatherTypePoints = {
      WeatherType.clear: 10,
      WeatherType.cloudy: 3,
      WeatherType.foggy: -3,
      WeatherType.halfCloudy: 6,
      WeatherType.raining: -6,
      WeatherType.snowing: -3
    };
    double weatherPoints = weatherTypePoints[weatherData.weather] ?? 0;

    // Precipitation
    double precipitationPoints = -(weatherData.precipitation * 30);

    // TODO add humidity and air quality

    return PointsData(windPoints: windPoints, temperaturePoints: tempPoints, snowPoints: snowPoints, weatherTypePoints: weatherPoints, precipitationPoints: precipitationPoints);
  }

  // Cluster times into intervals
  List<List<RecommendedTime>> clusterTimes(List<RecommendedTime> recommendedTimes){
    List<List<RecommendedTime>> clusters = [];
    List<RecommendedTime> currentCluster = [];
    for(int i = 0; i < recommendedTimes.length; i++){
      DateTime date = DateTime.parse(recommendedTimes[i].weather.time);

      DateTime startTime = DateTime(date.year, date.month, date.day, 4, 59);
      DateTime endTime = DateTime(date.year, date.month, date.day, 22, 01);

      if (date.isAfter(startTime) && date.isBefore(endTime)) {
        if(currentCluster.isEmpty){
          currentCluster.add(recommendedTimes[i]);
        }
        else if((currentCluster.last.points.getTotalPoints() - recommendedTimes[i].points.getTotalPoints()).abs() <= 2.5){
          currentCluster.add(recommendedTimes[i]);
        } else if(currentCluster.isNotEmpty){
          clusters.add(currentCluster.toList());
          currentCluster.clear();
        }
      }
    }
    
    return clusters;
  }

  Future<List<RecommendedIntervals>> getRecommended(int amount) async{
    List<WeatherInformation> weatherList = await apiClient.requestWeather(57.7085865,11.9684324);
    List<RecommendedTime> recommended = [];
    for (WeatherInformation weather in weatherList) {
      PointsData points = calculatePoints(weather);
      recommended.add(RecommendedTime(weather, points));
    }

    final List<List<RecommendedTime>> clusters = clusterTimes(recommended);

    // Sort clusters by the average points
    clusters.sort((a, b) => (b.fold(0.0, (sum, e) => sum + e.points.getTotalPoints()) / b.length
                  - a.fold(0.0, (sum, e) => sum + e.points.getTotalPoints()) / a.length).toInt());

    List<List<RecommendedTime>> topClusters = clusters.take(amount).toList();
    List<RecommendedIntervals> recommendedIntervals = [];
    final DateFormat format = DateFormat('EEEE');
    for (List<RecommendedTime> cluster in topClusters) {
      final start = DateTime.parse(cluster.first.weather.time);
      final end = DateTime.parse(cluster.last.weather.time);
      recommendedIntervals.add(RecommendedIntervals(
        format.format(DateTime.parse(cluster.first.weather.time)),
        start.hour != end.hour ? "${start.hour}:00 - ${end.hour}:00" : "${start.hour}:00",
        "${cluster.fold(0.0, (sum, e) => sum + e.weather.temperature) / cluster.length}°C",
        "${cluster.fold(0.0, (sum, e) => sum + e.weather.windspeed) / cluster.length} m/s",
          "${cluster.fold(0.0, (sum, e) => sum + e.weather.precipitation) / cluster.length}mm",
        cluster.map((x) => x.points).toList(),
        cluster.map((x) => x.weather.weather).toSet()
      ));
    }

    return recommendedIntervals;
  }

  void printIntervals(List<RecommendedIntervals> intervals){
    // print out the recommended intervals
    for (RecommendedIntervals interval in intervals) {
      print('Day name: ${interval.dayName}');
      print('Interval: ${interval.interval}');
      print('Temperature: ${interval.temperature}');
      print('Windspeed: ${interval.windspeed}');
      print('Precipitation: ${interval.precipitation}');
      print('Weather types: ${interval.weatherTypes}');

      print('Total points: ${interval.points.fold(0.0, (sum, e) => sum + e.getTotalPoints())}');
      
      // print all points in interval
      for (PointsData points in interval.points) {
        points.printPoints();
      }

      print("=====================================");
    }
  }

}

class RecommendedTime{
  final WeatherInformation weather;
  final PointsData points;

  RecommendedTime(this.weather, this.points);
}

// For the frontend
class RecommendedIntervals{
  final String dayName;
  final String interval;
  final String temperature;
  final String windspeed;
  final String precipitation;
  final List<PointsData> points;
  final Set<WeatherType> weatherTypes;

  RecommendedIntervals(this.dayName, this.interval, this.temperature, this.windspeed, this.precipitation, this.points, this.weatherTypes);
}