import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather/coordinate.dart';
import 'package:weather/either.dart';
import 'package:weather/open_weather_response.dart';
import 'package:weather/typedefs.dart';

class OpenWeatherRepository {
  final Dio _client =
      Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'));

  Future<Either<Failure, OpenWeatherResponse>> getWeather(
      Coordinate coor) async {
    final Response<JSON> response = await _client.get<JSON>(
      '/weather',
      queryParameters: {
        'lat': coor.latitude,
        'lon': coor.longitude,
        'appid': '963be00aba4191be02ede62cc7a8131c'
      },
    );

    debugPrint('Response: ${response.data}');

    return response.statusCode == 200
        ? Success(OpenWeatherResponse.fromJson(response.data!))
        : Fail(Failure('Failed to load weather', 800));
  }
}
