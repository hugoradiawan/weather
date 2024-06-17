import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_event.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_state.dart';
import 'package:weather/utils/either.dart';

class OpenWeatherApiBloc
    extends Bloc<OpenWeatherApiEvent, OpenWeatherApiState> {
  OpenWeatherApiBloc({required this.repository})
      : super(const OpenWeatherApiInitial()) {
    on<GetWeatherByPositionEvent>(
      _onGetWeatherByPosition,
      transformer: concurrent(),
    );

    on<GetWeatherByCityEvent>(
      _onGetWeatherByCity,
      transformer: concurrent(),
    );
  }

  final OpenWeatherRepository repository;

  void _onGetWeatherByPosition(
    GetWeatherByPositionEvent event,
    Emitter<OpenWeatherApiState> emit,
  ) async {
    emit(const OpenWeatherLoading());
    try {
      debugPrint('GetWeatherByPositionEvent: XXXXXXXXXXXXXXXX');
      (await repository.getWeatherByPosition(event.coordinate)).fold(
        (fail) => emit(OpenWeatherFailure(fail)),
        (success) {
          debugPrint('GetWeatherByPositionEvent: ${success!.name}');
          emit(OpenWeatherSuccess(success));
        },
      );
    } catch (e) {
      emit(const OpenWeatherFailure(Failure('Failed to load weather', 801)));
      rethrow;
    }
  }

  void _onGetWeatherByCity(
    GetWeatherByCityEvent event,
    Emitter<OpenWeatherApiState> emit,
  ) async {
    emit(const OpenWeatherLoading());
    try {
      (await repository.getWeatherByCity(event.city)).fold(
        (fail) => emit(OpenWeatherFailure(fail)),
        (success) => emit(OpenWeatherSuccess(success!)),
      );
    } catch (e) {
      emit(const OpenWeatherFailure(Failure('Failed to load weather', 801)));
      rethrow;
    }
  }
}
