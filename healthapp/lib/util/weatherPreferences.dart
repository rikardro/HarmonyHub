
class WeatherPreferences{
  final double _targetTemp;
  final bool _avoidSnow;
  final double _rainPref;
  final double _cloudPref;
  final double _windPref;

  WeatherPreferences(double temp, bool snow, double rain, double cloud, double wind) :
    _targetTemp = temp,
    _avoidSnow = snow,
    _rainPref = rain,
    _cloudPref = cloud,
    _windPref = wind;

  double get targetTemp => _targetTemp;
  bool get avoidSnow => _avoidSnow;
  double get rainPref => _rainPref;
  double get cloudPref => _cloudPref;
  double get windPref => _windPref;
}
