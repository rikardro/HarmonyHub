import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/backend/weather/sunUp.dart';
import 'package:healthapp/backend/weather/weather.dart';
import 'package:healthapp/util/weatherType.dart';
import 'package:healthapp/util/weatherVisualizationInfo.dart';

import '../constants/colors.dart';

class WeatherVisuals {
  static Future<WeatherVisualizationInfo> getWeatherVisuals(
      String weather) async {
    Location loc = await Location.getInstance();
    SunUp sunInfo = await ApiParser().getSunUp(loc.latitude, loc.longitude);
    bool isDay = sunInfo.currentSunIsUp();
    return _getData(weather, isDay);
  }

  static Set<AssetImage> getWeatherIcons(Set<WeatherType> weatherSet) {
    Set<AssetImage> images = {};
    for (var weather in weatherSet) {
      WeatherVisualizationInfo wvi = _getData(weather.toShortString(), true);
      images.add(wvi.image);
    }
    return images;
  }

  static WeatherVisualizationInfo _getData(String weather, bool isDay) {
    switch (weather) {
      case ("clear"):
        {
          if (isDay) {
            return WeatherVisualizationInfo("Sunny",
                AssetImage('assets/images/clear_day.png'), sunnyDayColor);
          } else {
            return WeatherVisualizationInfo("Sunny",
                AssetImage('assets/images/clear_night.png'), nightColor);
          }
        }
      case ("cloudy"):
        {
          if (isDay) {
            return WeatherVisualizationInfo(
              "Cloudy",
              AssetImage('assets/images/cloudy.png'),
              cloudyDayColor,
            );
          } else {
            return WeatherVisualizationInfo(
              "Cloudy",
              AssetImage('assets/images/cloudy.png'),
              nightColor,
            );
          }
        }
      case ("foggy"):
        {
          if (isDay) {
            return WeatherVisualizationInfo(
              "Foggy",
              AssetImage('assets/images/foggy.png'),
              foggyDayColor,
            );
          } else {
            return WeatherVisualizationInfo(
                "Foggy", AssetImage('assets/images/foggy.png'), nightColor);
          }
        }
      case ("snowing"):
        {
          if (isDay) {
            return WeatherVisualizationInfo(
              "Snowing",
              AssetImage('assets/images/snowing.png'),
              snowyDayColor,
            );
          } else {
            return WeatherVisualizationInfo(
                "Snowing", AssetImage('assets/images/snowing.png'), nightColor);
          }
        }
      case ("raining"):
        {
          if (isDay) {
            return WeatherVisualizationInfo(
              "Raining",
              AssetImage('assets/images/raining.png'),
              rainyDayColor,
            );
          } else {
            return WeatherVisualizationInfo(
              "Raining",
              AssetImage('assets/images/raining.png'),
              nightColor,
            );
          }
        }
      default:
        {
          if (isDay) {
            return WeatherVisualizationInfo(
              "Half cloudy",
              AssetImage('assets/images/halfcloudy_day.png'),
              halfCloudyDayColor,
            );
          } else {
            return WeatherVisualizationInfo("Half cloudy",
                AssetImage('assets/images/halfcloudy_night.png'), nightColor);
          }
        }
    }
  }
}
