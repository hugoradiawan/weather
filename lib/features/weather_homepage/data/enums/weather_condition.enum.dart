import 'package:flutter/material.dart';

enum WeatherCondition {
  thunderstorm,
  drizzle,
  rain,
  snow,
  atmosphere,
  clear,
  clouds,
  unknown;

  static WeatherCondition fromCode(int? code) {
    if (code == null) return WeatherCondition.unknown;
    if (code >= 200 && code < 300) {
      return WeatherCondition.thunderstorm;
    } else if (code >= 300 && code < 400) {
      return WeatherCondition.drizzle;
    } else if (code >= 500 && code < 600) {
      return WeatherCondition.rain;
    } else if (code >= 600 && code < 700) {
      return WeatherCondition.snow;
    } else if (code >= 700 && code < 800) {
      return WeatherCondition.atmosphere;
    } else if (code == 800) {
      return WeatherCondition.clear;
    } else if (code > 800) {
      return WeatherCondition.clouds;
    } else {
      return WeatherCondition.unknown;
    }
  }

  static Color? getBackgroundColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.thunderstorm:
        return Colors.deepPurple;
      case WeatherCondition.drizzle:
        return Colors.blue;
      case WeatherCondition.rain:
        return Colors.indigo;
      case WeatherCondition.snow:
        return Colors.lightBlue;
      case WeatherCondition.atmosphere:
        return Colors.cyan;
      case WeatherCondition.clear:
        return Colors.lightGreen;
      case WeatherCondition.clouds:
        return Colors.green;
      case WeatherCondition.unknown:
        return null;
    }
  }
}
