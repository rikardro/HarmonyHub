
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

  factory WeatherPreferences.fromMap(Map<String, dynamic> map) {
    return WeatherPreferences(
      map['targetTemp'], 
      map["avoidSnow"], 
      map['rainPref'], 
      map['cloudPref'], 
      map['windPref']);
  }

  @override
  String toString() {
    return 'WeatherPreferences{_targetTemp: $_targetTemp, _avoidSnow: $_avoidSnow, _rainPref: $_rainPref, _cloudPref: $_cloudPref, _windPref: $_windPref}';
  }
}
