import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/coordinate.dart';
import 'package:weather/either.dart';
import 'package:weather/open_weather_apibloc.dart';
import 'package:weather/open_weather_event.dart';
import 'package:weather/open_weather_repository.dart';
import 'package:weather/open_weather_response.dart';
import 'package:weather/open_weather_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(_) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home: OpenWeatherHomePage(),
      );
}

class OpenWeatherProvider extends StatelessWidget {
  const OpenWeatherProvider({
    super.key,
    required this.repository,
    required this.child,
  });

  final OpenWeatherRepository repository;
  final Widget child;

  @override
  Widget build(_) => MultiBlocProvider(
        providers: [
          BlocProvider<OpenWeatherApiBloc>(
            create: (_) => OpenWeatherApiBloc(
              repository: repository,
            ),
          ),
          BlocProvider<WeatherPageUiCubit>(
            create: (ctx) => WeatherPageUiCubit(
              apiBloc: ctx.read<OpenWeatherApiBloc>(),
            ),
          ),
        ],
        child: child,
      );
}

class OpenWeatherHomePage extends StatelessWidget {
  OpenWeatherHomePage({
    super.key,
    OpenWeatherRepository? repository,
  }) {
    this.repository = repository ?? OpenWeatherRepository();
  }

  late final OpenWeatherRepository repository;

  @override
  Widget build(BuildContext context) => OpenWeatherProvider(
        repository: repository,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              'Weather App',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.response != current.response ||
                previous.failure != current.failure,
            builder: (context, state) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    state.isLoading.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    state.response.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton:
              BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
            builder: (ctx, _) => FloatingActionButton(
              onPressed: ctx.read<WeatherPageUiCubit>().fetchWeather,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
}

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
    debugPrint('New state: $newState');
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
