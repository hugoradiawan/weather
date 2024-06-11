import 'package:weather/either.dart';
import 'package:weather/open_weather_response.dart';

abstract class OpenWeatherApiState {
  const OpenWeatherApiState();
}

class OpenWeatherApiInitial extends OpenWeatherApiState {
  const OpenWeatherApiInitial() : super();
}

class OpenWeatherSuccess extends OpenWeatherApiState {
  const OpenWeatherSuccess(this.response) : super();

  final OpenWeatherResponse response;
}

class OpenWeatherFailure extends OpenWeatherApiState {
  const OpenWeatherFailure(this.failure) : super();

  final Failure failure;
}

class OpenWeatherLoading extends OpenWeatherApiState {
  const OpenWeatherLoading() : super();
}