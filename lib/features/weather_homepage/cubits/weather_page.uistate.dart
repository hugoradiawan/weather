import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather/features/weather_homepage/data/models/coordinate.dart';
import 'package:weather/features/weather_homepage/data/models/open_weather_response.dart';
import 'package:weather/utils/either.dart';
import 'package:weather/utils/typedefs.dart';

class WeatherPageUiState extends Equatable {
  const WeatherPageUiState({
    this.responses,
    this.isLoading = false,
    this.failure,
    this.coordinate,
    this.countriesCodeAndName,
    this.cityTec,
    this.refreshController,
  });
  final Map<String, OpenWeatherResponse?>? responses;
  final Coordinate? coordinate;
  final Failure? failure;
  final bool isLoading;
  final Map<String, String>? countriesCodeAndName;
  final TextEditingController? cityTec;
  final RefreshController? refreshController;

  WeatherPageUiState copyWith({
    Map<String, OpenWeatherResponse?>? responses,
    bool isLoading = false,
    Failure? failure,
    Coordinate? coordinate,
    Map<String, String>? countriesCodeAndName,
    TextEditingController? cityTec,
    RefreshController? refreshController,
  }) =>
      WeatherPageUiState(
        responses: responses ?? this.responses,
        isLoading: isLoading,
        failure: failure ?? this.failure,
        coordinate: coordinate ?? this.coordinate,
        countriesCodeAndName: countriesCodeAndName ?? this.countriesCodeAndName,
        cityTec: cityTec ?? this.cityTec,
        refreshController: refreshController ?? this.refreshController,
      );

  JSON toJson() => {
        'responses': responses
            ?.map<String, JSON?>((key, value) => MapEntry(key, value?.toJson())),
        'isLoading': isLoading,
        'failure': failure?.toJson(),
        'coordinate': coordinate?.toJson(),
        'countriesCodeAndName': countriesCodeAndName,
        'cityTec': cityTec?.text,
      };

  factory WeatherPageUiState.fromJson(JSON? json) => WeatherPageUiState(
        responses:
            (json?['responses'] as JSON?)?.map<String, OpenWeatherResponse?>(
          (key, value) => MapEntry(key, OpenWeatherResponse.fromJson(value)),
        ),
        isLoading: json?['isLoading'],
        failure: Failure.fromJson(json?['failure']),
        coordinate: Coordinate.fromJson(json?['coordinate']),
        countriesCodeAndName: json?['countriesCodeAndName'],
        cityTec: json?['cityTec'] == null
            ? null
            : TextEditingController(text: json?['cityTec']),
      );

  @override
  List<Object?> get props => [
        responses,
        isLoading,
        failure,
        coordinate,
        countriesCodeAndName,
        cityTec,
        refreshController,
      ];
}
