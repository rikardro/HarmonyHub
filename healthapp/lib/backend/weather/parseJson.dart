import 'dart:collection';

import 'package:healthapp/util/weatherType.dart';



class JsonParser{
  HashMap weatherTypeMap = HashMap<String, WeatherType>();

  JsonParser(){
    initWeatherTypes();
  }

  void initWeatherTypes(){
    weatherTypeMap[0] = WeatherType.clear; // clear sky
    weatherTypeMap[1] = WeatherType.halfCloudy; // mainly clear
    weatherTypeMap[2] = WeatherType.halfCloudy; // partly cloudy
    weatherTypeMap[3] = WeatherType.cloudy; // overcast
    weatherTypeMap[45] = WeatherType.foggy; // fog
    weatherTypeMap[48] = WeatherType.foggy; // depositing rime fog
    weatherTypeMap[51] = WeatherType.raining; // light drizzle
    weatherTypeMap[53] = WeatherType.raining; // moderate drizzle
    weatherTypeMap[55] = WeatherType.raining; // dense drizzle
    weatherTypeMap[56] = WeatherType.raining; // light freezing drizzle
    weatherTypeMap[57] = WeatherType.raining; // dense freezing drizzle
    weatherTypeMap[61] = WeatherType.raining; // light rain
    weatherTypeMap[63] = WeatherType.raining; // moderate rain
    weatherTypeMap[65] = WeatherType.raining; // heavy rain
    weatherTypeMap[66] = WeatherType.raining; // light freezing rain
    weatherTypeMap[67] = WeatherType.raining; // heavy freezing rain
    weatherTypeMap[71] = WeatherType.snowing; // slight snow fall
    weatherTypeMap[73] = WeatherType.snowing; // moderate snow fall
    weatherTypeMap[75] = WeatherType.snowing; // heavy snow fall
    weatherTypeMap[77] = WeatherType.snowing; // snow grains
    weatherTypeMap[80] = WeatherType.raining; // slight rain showers
    weatherTypeMap[81] = WeatherType.raining; // moderate rain showers
    weatherTypeMap[82] = WeatherType.raining; // violent rain showers
    weatherTypeMap[85] = WeatherType.snowing; // slight snow showers
    weatherTypeMap[86] = WeatherType.snowing; // heavy snow showers
  }
}



