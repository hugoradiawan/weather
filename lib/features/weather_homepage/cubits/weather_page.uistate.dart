import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather/features/weather_homepage/data/coordinate.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';
import 'package:weather/utils/either.dart';

class WeatherPageUiState extends Equatable {
  const WeatherPageUiState({
    this.responses,
    this.isLoading = false,
    this.failure,
    this.coordinate,
    this.countriesCodeAndName,
    this.cityTec,
  });
  final Map<String, OpenWeatherResponse>? responses;
  final Coordinate? coordinate;
  final Failure? failure;
  final bool isLoading;
  final Map<String, String>? countriesCodeAndName;
  final TextEditingController? cityTec;

  WeatherPageUiState copyWith({
    Map<String,OpenWeatherResponse>? responses,
    bool? isLoading,
    Failure? failure,
    Coordinate? coordinate,
    Map<String, String>? countriesCodeAndName,
    TextEditingController? cityTec,
  }) =>
      WeatherPageUiState(
        responses: responses ?? this.responses,
        isLoading: isLoading ?? this.isLoading,
        failure: failure ?? this.failure,
        coordinate: coordinate ?? this.coordinate,
        countriesCodeAndName: countriesCodeAndName ?? this.countriesCodeAndName,
        cityTec: cityTec ?? this.cityTec,
      );

  @override
  List<Object?> get props => [
        responses,
        isLoading,
        failure,
        coordinate,
        countriesCodeAndName,
        cityTec,
      ];
}
