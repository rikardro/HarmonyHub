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
    weatherTypeMap["fog"] = WeatherType.foggy;
    weatherTypeMap["depositing rime fog"] = WeatherType.foggy;
    weatherTypeMap["light drizzle"] = WeatherType.raining;
    weatherTypeMap["moderate drizzle"] = WeatherType.raining;
    weatherTypeMap["dense drizzle"] = WeatherType.raining;
    weatherTypeMap["light freezing drizzle"] = WeatherType.raining;
    weatherTypeMap["dense freezing drizzle"] = WeatherType.raining;
    weatherTypeMap["light rain"] = WeatherType.raining;
    weatherTypeMap["moderate rain"] = WeatherType.raining;
    weatherTypeMap["heavy rain"] = WeatherType.raining;
    weatherTypeMap["light freezing rain"] = WeatherType.raining;
    weatherTypeMap["heavy freezing rain"] = WeatherType.raining;
    weatherTypeMap["slight snow fall"] = WeatherType.snowing;
    weatherTypeMap["moderate snow fall"] = WeatherType.snowing;
    weatherTypeMap["heavy snow fall"] = WeatherType.snowing;
    weatherTypeMap["snow grains"] = WeatherType.snowing;
    weatherTypeMap["slight rain showers"] = WeatherType.raining;
    weatherTypeMap["moderate rain showers"] = WeatherType.raining;
    weatherTypeMap["violent rain showers"] = WeatherType.raining;
    weatherTypeMap["slight snow showers"] = WeatherType.snowing;
    weatherTypeMap["heavy snow showers"] = WeatherType.snowing;
  }
}