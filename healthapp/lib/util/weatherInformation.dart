import 'package:healthapp/util/cardinalDirections.dart';
import 'package:healthapp/util/weatherType.dart';

class WeatherInformation {
  final String _time;
  final double _temperature;
  final double _precipitation;
  final double _snowfall;
  final double _snow_depth;
  final WeatherType _weather;
  final int _cloudcover;
  final double _windspeed;
  final int _windDegrees;
  final CardinalDirection _windDirection;
  

  WeatherInformation(String time, double temperature, double precipitation, double snowfall, 
  double snow_depth, WeatherType weather, int cloudcover, double windspeed, int windDegrees)
      : _time = time,
        _temperature = temperature,
        _precipitation = precipitation,
        _snowfall = snowfall,
        _snow_depth = snow_depth,
        _weather = weather,
        _cloudcover = cloudcover,
        _windspeed = windspeed,
        _windDegrees = windDegrees,
        _windDirection = _convertDegreesToCardinal(windDegrees);

  double get temperature => _temperature;
  double get windspeed => _windspeed;
  double get precipitation => _precipitation;
  WeatherType get weatherType => _weather;
  CardinalDirection get windDirectionCardinal => _windDirection;
  int get windDirectionDegrees => _windDegrees;

  static CardinalDirection _convertDegreesToCardinal(int degrees) {
    int amount = ((degrees.toDouble() + 22.5) ~/ 45) % 8;
    // amount is an expression converting degrees into which 45* turn it represents.
    switch (amount) {
      case 0:
        return CardinalDirection.north;
      case 1:
        return CardinalDirection.northeast;
      case 2:
        return CardinalDirection.east;
      case 3:
        return CardinalDirection.southeast;
      case 4:
        return CardinalDirection.south;
      case 5:
        return CardinalDirection.southwest;
      case 6:
        return CardinalDirection.west;
      case 7:
        return CardinalDirection.northwest;
    }
    return CardinalDirection.north;
  }
}
