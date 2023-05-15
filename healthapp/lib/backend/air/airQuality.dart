import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../location/location.dart';

class AirQualityData {
  final int aqi;
  final String city;
  late String airQualityStatus;

  AirQualityData({required this.city, required this.aqi}) {
    if (aqi < 50) {
      airQualityStatus = "Good";
    } else if (aqi <= 100) {
      airQualityStatus = "Moderate";
    } else {
      airQualityStatus = "Poor";
    }
  }

  String get status {
    return airQualityStatus;
  }

  int get airQuality {
    return aqi;
  }
}


class AirQuality {
  static const String apiKey = 'fab479720ebc047005d9cf2d23fac7ae68a4798d';
  static const String apiUrl = 'https://api.waqi.info/feed/geo:';

  static Future<AirQualityData> fetchAirQualityData() async {

    Location location = await Location.getInstance();

    final String apiUrlWithKey = '$apiUrl${location.latitude};${location.longitude}/?token=$apiKey';

    final response = await http.get(Uri.parse(apiUrlWithKey));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final String cityName = jsonResponse['data']['city']['name'];

      final int aqi = jsonResponse['data']['aqi'];

      return AirQualityData(city: cityName, aqi: aqi);
    } else {
      throw Exception('Failed to load air quality data');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AirQualityData airQualityData = await AirQuality.fetchAirQualityData();
  log('City: ${airQualityData.city}');
  log('AQI: ${airQualityData.aqi}');
}
