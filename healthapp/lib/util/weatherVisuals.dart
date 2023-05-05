

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/backend/weather/sunUp.dart';
import 'package:healthapp/backend/weather/weather.dart';
import 'package:healthapp/util/weatherType.dart';
import 'package:healthapp/util/weatherVisualizationInfo.dart';

class WeatherVisuals{
  static Future<WeatherVisualizationInfo> getWeatherVisuals(String weather) async{
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
          return WeatherVisualizationInfo(
          "Sunny", 
          AssetImage('assets/images/clear_day.png'), 
          Color(0xFFFF9900)
          );
        } else {
          return WeatherVisualizationInfo(
          "Sunny", 
          AssetImage('assets/images/clear_night.png'), 
          Color.fromARGB(255, 115, 22, 255)
          );
        }
      }
    case ("cloudy"):
      {
        if (isDay) {
          return WeatherVisualizationInfo(
          "Cloudy", 
          AssetImage('assets/images/cloudy.png'), 
          Color.fromARGB(255, 152, 166, 182)
          );
        } else {
          return WeatherVisualizationInfo(
          "Cloudy", 
          AssetImage('assets/images/cloudy.png'), 
          Color.fromARGB(255, 115, 22, 255)
          );
        }
      } 
    case ("foggy"):
      {
        if (isDay) {
          return WeatherVisualizationInfo(
          "Foggy", 
          AssetImage('assets/images/foggy.png'), 
          Color.fromARGB(255, 194, 223, 255)
          );
        } else {
          return WeatherVisualizationInfo(
          "Foggy", 
          AssetImage('assets/images/foggy.png'), 
          Color.fromARGB(255, 115, 22, 255)
          );
        }
      }    
    case ("snowing"):
      {
        if (isDay) {
          return WeatherVisualizationInfo(
          "Snowing", 
          AssetImage('assets/images/snowing.png'), 
          Color.fromARGB(255, 203, 210, 255)
          );
        } else {
          return WeatherVisualizationInfo(
          "Snowing", 
          AssetImage('assets/images/snowing.png'), 
          Color.fromARGB(255, 115, 22, 255)
          );
        }
      }
    case ("raining"):
      {
        if (isDay) {
          return WeatherVisualizationInfo(
          "Raining", 
          AssetImage('assets/images/raining.png'), 
          Color.fromARGB(255, 137, 192, 255)
          );
        } else {
          return WeatherVisualizationInfo(
          "Raining", 
          AssetImage('assets/images/raining.png'), 
          Color.fromARGB(255, 115, 22, 255)
          );
        }
      }
    default:
      {
        if (isDay) {
          return WeatherVisualizationInfo(
          "Half cloudy", 
          AssetImage('assets/images/halfcloudy_day.png'), 
          Color.fromARGB(255, 255, 216, 143)
          );
        } else {
          return WeatherVisualizationInfo(
          "Half cloudy", 
          AssetImage('assets/images/halfcloudy_night.png'), 
          Color.fromARGB(255, 115, 22, 255)
          );
        }
      }
    }  
  }

}