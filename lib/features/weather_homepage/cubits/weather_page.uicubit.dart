import 'dart:async';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_apibloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_event.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_state.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/data/coordinate.dart';

class WeatherPageUiCubit extends Cubit<WeatherPageUiState> {
  WeatherPageUiCubit({required this.apiBloc})
      : super(
          const WeatherPageUiState().copyWith(
            coordinate: const Coordinate(
              longitude: 44.34,
              latitude: 10.99,
            ),
            isLoading: false,
          ),
        ) {
    _subscription = apiBloc.stream.listen(_onApiStateChange);
    emit(state.copyWith(cityTec: TextEditingController()));
    extractCountries();
  }

  final OpenWeatherApiBloc apiBloc;
  late final StreamSubscription<OpenWeatherApiState> _subscription;

  void _onApiStateChange(OpenWeatherApiState newState) {
    switch (newState) {
      case OpenWeatherSuccess success:
        emit(state.copyWith(
          responses: {
            ...state.responses ?? {},
            getCountryName(success.response.sys.country) ?? '': success.response
          },
          isLoading: false,
        ));
        state.cityTec?.clear();
        break;
      case OpenWeatherFailure fail:
        emit(state.copyWith(failure: fail.failure, isLoading: false));
        break;
      case OpenWeatherLoading _:
        emit(state.copyWith(isLoading: true));
        break;
    }
  }

  void addCity() {
    if (state.cityTec?.text == '') return;
    apiBloc.add(GetWeatherByCityEvent(state.cityTec!.text));
  }

  void fetchWeatherByCity() {
    if (state.cityTec?.text == '') return;
    apiBloc.add(GetWeatherByCityEvent(state.cityTec!.text));
  }

  String? getCountryName(String countryCode) {
    return state.countriesCodeAndName?[countryCode.toUpperCase()];
  }

  void extractCountries() {
    rootBundle.load('assets/countries.csv').then((data) {
      String value =
          utf8.decode(data.buffer.asUint8List(), allowMalformed: true);
      // skip header
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
          .convert(value, fieldDelimiter: ';')
          .skip(1)
          .toList();
      final Map<String, String> countries = Map.fromEntries(
        rowsAsListOfValues.map(
            (e) => MapEntry(e[1].toString().toUpperCase(), e[0].toString())),
      );
      emit(state.copyWith(countriesCodeAndName: countries));
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    state.cityTec?.dispose();
    return super.close();
  }
}

enum WeatherCondition {
  thunderstorm,
  drizzle,
  rain,
  snow,
  atmosphere,
  clear,
  clouds,
  unknown;

  static WeatherCondition fromCode(int code) {
    if (code >= 200 && code < 300) {
      return WeatherCondition.thunderstorm;
    } else if (code >= 300 && code < 400) {
      return WeatherCondition.drizzle;
    } else if (code >= 500 && code < 600) {
      return WeatherCondition.rain;
    } else if (code >= 600 && code < 700) {
      return WeatherCondition.snow;
    } else if (code >= 700 && code < 800) {
      return WeatherCondition.atmosphere;
    } else if (code == 800) {
      return WeatherCondition.clear;
    } else if (code > 800) {
      return WeatherCondition.clouds;
    } else {
      return WeatherCondition.unknown;
    }
  }

  static Color? getBackgroundColor(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.thunderstorm:
        return Colors.deepPurple;
      case WeatherCondition.drizzle:
        return Colors.blue;
      case WeatherCondition.rain:
        return Colors.indigo;
      case WeatherCondition.snow:
        return Colors.lightBlue;
      case WeatherCondition.atmosphere:
        return Colors.cyan;
      case WeatherCondition.clear:
        return Colors.lightGreen;
      case WeatherCondition.clouds:
        return Colors.green;
      case WeatherCondition.unknown:
        return null;
    }
  }
}
