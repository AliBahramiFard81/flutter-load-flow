import 'dart:math';
import 'package:flutter/material.dart';

class ResponsiveFont {
  static double responsiveFont(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double value = (width / 1400) * maxTextScaleFactor;
    return max(1, min(value, maxTextScaleFactor));
  }
}
