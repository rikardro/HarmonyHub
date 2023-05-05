import 'dart:math';

import 'package:flutter/material.dart';

class GradientColor {
  static const Color mRed = Color(0xFFFF6363);
  static const Color mPurple = Color(0xFFA771FF);
  static const Color mBlue = Color(0xFF63ABFF);
  static const Color mGreen = Color(0xFF48D681);

  static Color hueShift(int c) {
    var hslColor = HSLColor.fromColor(Color(c));
    var increment = max(min(hslColor.hue*0.1, 50), 25); // just looks good
    return hslColor.withHue(hslColor.hue+increment).toColor();
  }

  static List<Color> getGradient(int c){
    return [hueShift(c), Color(c)];
  }

  static Color lightenColor(int c) {
    var hslColor = HSLColor.fromColor(Color(c));
    return hslColor.withLightness(0.92).withSaturation(1).toColor();
  }
}