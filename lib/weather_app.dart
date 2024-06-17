import 'package:flutter/material.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/data/models/coordinate.dart';
import 'package:weather/features/weather_homepage/data/models/open_weather_response.dart';
import 'package:weather/features/weather_homepage/presentation/open_weather_home_page.dart';
import 'package:weather/utils/either.dart';
import 'package:weather/utils/typedefs.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(_) => MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey,
          ),
          useMaterial3: true,
        ),
        home:
            OpenWeatherHomePage(repository: MockSucessOpenWeatherRepository()),
      );
}

final JSON successResponse = {
  "coord": {
    "lon": 106.8451,
    "lat": -6.2146
  },
  "weather": [
    {
      "id": 801,
      "main": "Clouds",
      "description": "few clouds",
      "icon": "02n"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 27.83,
    "feels_like": 31.26,
    "temp_min": 27.72,
    "temp_max": 28.21,
    "pressure": 1011,
    "humidity": 77,
    "sea_level": 1011,
    "grnd_level": 1009
  },
  "visibility": 10000,
  "wind": {
    "speed": 2.11,
    "deg": 120,
    "gust": 3.24
  },
  "clouds": {
    "all": 15
  },
  "dt": 1718648824,
  "sys": {
    "type": 2,
    "id": 2033644,
    "country": "ID",
    "sunrise": 1718665256,
    "sunset": 1718707596
  },
  "timezone": 25200,
  "id": 1642911,
  "name": "Jakarta",
  "cod": 200
};

class MockSucessOpenWeatherRepository implements OpenWeatherRepository {
  @override
  Future<Either<Failure, OpenWeatherResponse?>> getWeatherByCity(
      String city) async {
    return Future.value(
      Success(OpenWeatherResponse.fromJson(successResponse)),
    );
  }

  @override
  Future<Either<Failure, OpenWeatherResponse?>> getWeatherByPosition(
      Coordinate coor) {
    throw UnimplementedError();
  }
}
