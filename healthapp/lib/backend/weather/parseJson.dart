import 'dart:collection';

import 'package:healthapp/util/weatherType.dart';



class JsonParser{
  HashMap weatherTypeMap = HashMap<String, WeatherType>();

  JsonParser(){
    initWeatherTypes();
  }

  Null initWeatherTypes(){
    weatherTypeMap["clear sky"] = WeatherType.clear;
    weatherTypeMap["mainly clear"] = WeatherType.halfCloudy;
    weatherTypeMap["partly cloudy"] = WeatherType.halfCloudy;
    weatherTypeMap["overcast"] = WeatherType.cloudy;
    weatherTypeMap["light rain"] = WeatherType.raining;
    weatherTypeMap["moderate rain"] = WeatherType.raining;
    weatherTypeMap["heavy rain"] = WeatherType.raining;
    weatherTypeMap["light drizzle"] = WeatherType.raining;
    weatherTypeMap["moderate drizzle"] = WeatherType.raining;
    weatherTypeMap["dense drizzle"] = WeatherType.raining;
    weatherTypeMap["light freezing drizzle"] = WeatherType.raining;
    weatherTypeMap["dense freezing drizzle"] = WeatherType.raining;
    weatherTypeMap[]
    
}