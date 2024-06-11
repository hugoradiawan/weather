import 'package:equatable/equatable.dart';
import 'package:weather/features/weather_homepage/data/coordinate.dart';
import 'package:weather/utils/either.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';

class WeatherPageUiState extends Equatable {
  const WeatherPageUiState({
    this.response,
    this.isLoading = false,
    this.failure,
    this.coordinate,
  });
  final OpenWeatherResponse? response;
  final Coordinate? coordinate;
  final Failure? failure;
  final bool isLoading;

  WeatherPageUiState copyWith({
    OpenWeatherResponse? response,
    bool? isLoading,
    Failure? failure,
    Coordinate? coordinate,
  }) =>
      WeatherPageUiState(
        response: response ?? this.response,
        isLoading: isLoading ?? this.isLoading,
        failure: failure ?? this.failure,
        coordinate: coordinate ?? this.coordinate,
      );

  @override
  List<Object?> get props => [
        response,
        isLoading,
        failure,
        coordinate,
      ];
}
