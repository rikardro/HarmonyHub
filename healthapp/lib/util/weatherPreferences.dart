
class WeatherPreferences{
  final int _targetTemp;
  final bool _avoidSnow;
  final int _rainPref;
  final int _cloudPref;
  final int _windPref;

  WeatherPreferences(int temp, bool snow, int rain, int cloud, int wind) :
    _targetTemp = temp,
    _avoidSnow = snow,
    _rainPref = rain,
    _cloudPref = cloud,
    _windPref = wind;

  int get targetTemp => _targetTemp;
  bool get avoidSnow => _avoidSnow;
  int get rainPref => _rainPref;
  int get cloudPref => _cloudPref;
  int get windPref => _windPref;
}
