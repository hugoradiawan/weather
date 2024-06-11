import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/either.dart';
import 'package:weather/open_weather_event.dart';
import 'package:weather/open_weather_repository.dart';
import 'package:weather/open_weather_state.dart';

class OpenWeatherApiBloc
    extends Bloc<OpenWeatherApiEvent, OpenWeatherApiState> {
  OpenWeatherApiBloc({required this.repository})
      : super(const OpenWeatherApiInitial()) {
    on<GetWeatherEvent>(
      _onGetWeather,
      transformer: droppable(),
    );
  }

  final OpenWeatherRepository repository;

  void _onGetWeather(
    GetWeatherEvent event,
    Emitter<OpenWeatherApiState> emit,
  ) async {
    emit(const OpenWeatherLoading());
    try {
      (await repository.getWeather(event.coordinate)).fold(
        (fail) => emit(OpenWeatherFailure(fail)),
        (success) => emit(OpenWeatherSuccess(success)),
      );
    } catch (e) {
      emit(OpenWeatherFailure(Failure('Failed to load weather', 801)));
      rethrow;
    }
  }
}
