import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather/features/weather_homepage/data/coordinate.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';
import 'package:weather/utils/either.dart';
import 'package:weather/utils/typedefs.dart';

class OpenWeatherRepository {
  final Dio _client =
      Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'));

  Future<Either<Failure, OpenWeatherResponse>> getWeatherByPosition(
      Coordinate coor) async {
    final Response<JSON> response = await _client.get<JSON>(
      '/weather',
      queryParameters: {
        'lat': coor.latitude,
        'lon': coor.longitude,
        'appid': '963be00aba4191be02ede62cc7a8131c',
        'units': 'metric',
      },
    );

    debugPrint('Response: ${response.data}');

    return response.statusCode == 200
        ? Success(OpenWeatherResponse.fromJson(response.data!))
        : Fail(Failure('Failed to load weather', 800));
  }

  Future<Either<Failure, OpenWeatherResponse>> getWeatherByCity(
      String city) async {
    final Response<JSON> response = await _client.get<JSON>(
      '/weather',
      queryParameters: {
        'q': city,
        'appid': '963be00aba4191be02ede62cc7a8131c',
        'units': 'metric',
      },
    );

    debugPrint('Response: ${response.data}');

    return response.statusCode == 200
        ? Success(OpenWeatherResponse.fromJson(response.data!))
        : Fail(Failure('Failed to load weather', 800));
  }
}
