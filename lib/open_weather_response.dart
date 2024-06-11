import 'package:equatable/equatable.dart';
import 'package:weather/clouds.dart';
import 'package:weather/coordinate.dart';
import 'package:weather/main_data.dart';
import 'package:weather/sys.dart';
import 'package:weather/typedefs.dart';
import 'package:weather/weather.dart';
import 'package:weather/wind.dart';

class OpenWeatherResponse extends Equatable {
  const OpenWeatherResponse({
    required this.baseData,
    required this.name,
    required this.timezone,
    required this.id,
    required this.cod,
    required this.visibility,
    required this.coordinate,
    required this.weather,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.dateTime,
    required this.sys,
  });

  final String baseData, name;
  final int timezone, id, cod, visibility;
  final Coordinate coordinate;
  final Weather weather;
  final Main main;
  final Wind wind;
  final Clouds clouds;
  final DateTime dateTime;
  final Sys sys;

  factory OpenWeatherResponse.fromJson(JSON json) => OpenWeatherResponse(
        baseData: json['base'],
        name: json['name'],
        timezone: json['timezone'],
        id: json['id'],
        cod: json['cod'],
        visibility: json['visibility'],
        coordinate: Coordinate.fromJson(json['coord']),
        weather: Weather.fromJson(json['weather'][0]),
        main: Main.fromJson(json['main']),
        wind: Wind.fromJson(json['wind']),
        clouds: Clouds.fromJson(json['clouds']),
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        sys: Sys.fromJson(json['sys']),
      );

  JSON toJson() => {
        'base': baseData,
        'name': name,
        'timezone': timezone,
        'id': id,
        'cod': cod,
        'visibility': visibility,
        'coord': coordinate.toJson(),
        'weather': weather.toJson(),
        'main': main.toJson(),
        'wind': wind.toJson(),
        'clouds': clouds.toJson(),
        'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
        'sys': sys.toJson(),
      };

  @override
  List<Object?> get props => [
        baseData,
        name,
        timezone,
        id,
        cod,
        visibility,
        coordinate,
        weather,
        main,
        wind,
        clouds,
        dateTime,
        sys,
      ];
}
