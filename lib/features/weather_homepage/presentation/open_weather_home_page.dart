import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/presentation/dialogs/add_city_dialog.dart';
import 'package:weather/features/weather_homepage/presentation/open_weather.provider.dart';
import 'package:weather/features/weather_homepage/presentation/components/weather_tile.dart';

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
        child: BlocListener<WeatherPageUiCubit, WeatherPageUiState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure ||
              previous.isLoading != current.isLoading,
          listener: (ctx, state) {
            if (state.failure != null) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(state.failure!.message)),
              );
            } else if (state.isLoading) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Loading...')),
              );
            } else {
              ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(
                'Weather App',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              actions: [
                BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
                  buildWhen: (_, __) => false,
                  builder: (ctx, _) => IconButton(
                    onPressed: ctx.read<WeatherPageUiCubit>().refreshWeather,
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
                  buildWhen: (_, __) => false,
                  builder: (ctx, _) => IconButton(
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (_) => AddCityDialog(mainContext: ctx),
                      );
                    },
                    icon: const Icon(Icons.location_city),
                  ),
                ),
              ],
            ),
            body: BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
              buildWhen: (previous, current) =>
                  previous.responses != current.responses ||
                  previous.refreshController != current.refreshController,
              builder: (ctx, state) => state.refreshController != null
                  ? SmartRefresher(
                      controller: state.refreshController!,
                      onRefresh: ctx.read<WeatherPageUiCubit>().refreshWeather,
                      child: state.responses != null
                          ? ListView(
                              children: state.responses?.values
                                      .map((e) => WeatherTile(response: e!))
                                      .toList() ??
                                  [],
                            )
                          : const SizedBox.shrink(),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
}
