import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/presentation/open_weather.provider.dart';

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
