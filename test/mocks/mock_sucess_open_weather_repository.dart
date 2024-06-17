import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/data/models/coordinate.dart';
import 'package:weather/features/weather_homepage/data/models/open_weather_response.dart';
import 'package:weather/utils/either.dart';

import '../response_test/success_response.dart';

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