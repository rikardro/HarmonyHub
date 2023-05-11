
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherPreferences{
  final double _targetTemp;
  final bool _avoidSnow;
  final double _rainPref;
  final double _cloudPref;
  final double _windPref;
  final TimeOfDay _startTime;
  final TimeOfDay _endTime;

  WeatherPreferences(double temp, bool snow, double rain, double cloud, double wind, TimeOfDay startTime, TimeOfDay endTime) :
    _targetTemp = temp,
    _avoidSnow = snow,
    _rainPref = rain,
    _cloudPref = cloud,
    _windPref = wind,
    _startTime = startTime,
    _endTime = endTime;

  double get targetTemp => _targetTemp;
  bool get avoidSnow => _avoidSnow;
  double get rainPref => _rainPref;
  double get cloudPref => _cloudPref;
  double get windPref => _windPref;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;

  factory WeatherPreferences.fromMap(Map<String, dynamic> map) {
    return WeatherPreferences(
      map['targetTemp'], 
      map["avoidSnow"], 
      map['rainPref'], 
      map['cloudPref'], 
      map['windPref'],
      TimeOfDay.fromDateTime(DateFormat.Hm().parse(map['startTime'])),
      TimeOfDay.fromDateTime(DateFormat.Hm().parse(map['endTime'])),
    );
  }

  @override
  String toString() {
    return 'WeatherPreferences{_targetTemp: $_targetTemp, _avoidSnow: $_avoidSnow, _rainPref: $_rainPref, _cloudPref: $_cloudPref, _windPref: $_windPref}';
  }
}
