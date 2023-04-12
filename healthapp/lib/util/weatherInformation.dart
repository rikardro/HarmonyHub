import 'package:healthapp/util/cardinalDirections.dart';
import 'package:healthapp/util/weatherType.dart';

class WeatherInformation {
  final double _temperature;
  final double _windspeed;
  final double _precipitation;
  final WeatherType _weather;
  final CardinalDirection _windDirection;
  final double _windDegrees;

  WeatherInformation(
      {temperature = 0,
      windspeed = 0,
      precipitation = 0,
      weather = WeatherType.clear,
      windDegrees = 0})
      : _temperature = temperature,
        _windspeed = windspeed,
        _precipitation = precipitation,
        _weather = weather,
        _windDegrees = windDegrees,
        _windDirection = _convertDegreesToCardinal(windDegrees);

  double get temperature => _temperature;
  double get windspeed => _windspeed;
  double get precipitation => _precipitation;
  WeatherType get weatherType => _weather;
  CardinalDirection get windDirectionCardinal => _windDirection;
  double get windDirectionDegrees => _windDegrees;

  static CardinalDirection _convertDegreesToCardinal(double degrees) {
    int amount = ((degrees + 22.5) ~/ 45) % 8;
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
