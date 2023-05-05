import 'package:flutter/material.dart';

class WeatherVisualizationInfo {
  final String _weatherName;
  final AssetImage _image;
  final Color _color;

WeatherVisualizationInfo(String weatherName, AssetImage image, Color color)
  : _weatherName = weatherName,
    _image = image,
    _color = color;

  String get weatherName => _weatherName;
  AssetImage get image => _image;
  Color get color => _color;
}


