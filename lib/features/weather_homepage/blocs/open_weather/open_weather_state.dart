import 'package:equatable/equatable.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';
import 'package:weather/utils/either.dart';

abstract class OpenWeatherApiState extends Equatable {
  const OpenWeatherApiState();
}

class OpenWeatherApiInitial extends OpenWeatherApiState {
  const OpenWeatherApiInitial() : super();

  @override
  List<Object?> get props => [];
}

class OpenWeatherSuccess extends OpenWeatherApiState {
  const OpenWeatherSuccess(this.response) : super();

  final OpenWeatherResponse response;

  @override
  List<Object?> get props => [];
}

class OpenWeatherFailure extends OpenWeatherApiState {
  const OpenWeatherFailure(this.failure) : super();

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class OpenWeatherLoading extends OpenWeatherApiState {
  const OpenWeatherLoading() : super();

  @override
  List<Object?> get props => [];
}
