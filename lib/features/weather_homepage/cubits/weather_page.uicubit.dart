import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/data/coordinate.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_apibloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_event.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_state.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';

class WeatherPageUiCubit extends Cubit<WeatherPageUiState> {
  WeatherPageUiCubit({required this.apiBloc})
      : super(const WeatherPageUiState().copyWith(
          coordinate: const Coordinate(
            longitude: 44.34,
            latitude: 10.99,
          ),
        )) {
    _subscription = apiBloc.stream.listen(_onApiStateChange);
  }

  final OpenWeatherApiBloc apiBloc;
  late final StreamSubscription<OpenWeatherApiState> _subscription;

  void _onApiStateChange(OpenWeatherApiState newState) {
    switch (newState) {
      case OpenWeatherSuccess success:
        emit(state.copyWith(response: success.response, isLoading: false));
        break;
      case OpenWeatherFailure fail:
        emit(state.copyWith(failure: fail.failure, isLoading: false));
        break;
      case OpenWeatherLoading _:
        emit(const WeatherPageUiState(isLoading: true));
        break;
    }
  }

  void fetchWeather() {
    if (state.coordinate == null) return;
    apiBloc.add(GetWeatherEvent(state.coordinate!));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}