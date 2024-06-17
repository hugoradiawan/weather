import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';
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

class AddCityDialog extends StatelessWidget {
  const AddCityDialog({
    super.key,
    required this.mainContext,
  });

  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:
                    mainContext.read<WeatherPageUiCubit>().state.cityTec,
                decoration: const InputDecoration(
                  labelText: 'Add New City',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  mainContext.read<WeatherPageUiCubit>().fetchWeatherByCity();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              )
            ],
          ),
        ),
      );
}

class WeatherTile extends StatelessWidget {
  const WeatherTile({super.key, required this.response});

  final OpenWeatherResponse response;

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: WeatherCondition.getBackgroundColor(
                    WeatherCondition.fromCode(response.weather?[0]?.id)) ??
                Colors.grey,
          ),
          sliderTheme: SliderThemeData(
            trackHeight: 18,
            overlayShape: SliderComponentShape.noThumb,
            overlayColor: Colors.transparent,
            disabledThumbColor: Colors.transparent,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 0,
              elevation: 0,
              pressedElevation: 0,
              disabledThumbRadius: 0,
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: WeatherCondition.getBackgroundColor(
                        WeatherCondition.fromCode(response.weather?[0]?.id))
                    ?.withOpacity(0.2) ??
                Colors.grey,
          ),
          height: 200,
          child: Column(children: [
            Expanded(
              flex: 3,
              child: Row(children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Expanded(
                        flex: 3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: (response.getWeatherUrl() != null)
                              ? CircleAvatar(
                                  radius: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: response.getWeatherUrl()!,
                                    progressIndicatorBuilder: (_, __, ___) =>
                                        const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (_, __, ___) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      Flexible(
                        child: Text(response.weather?[0]?.main ?? ''),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: (response.main.temp != null &&
                              response.main.tempMin != null &&
                              response.main.tempMax != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  AutoSizeText(
                                    '${response.main.temp.toString()} °C',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(children: [
                                    if (response.main.tempMin != null)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: AutoSizeText(
                                          minFontSize: 4,
                                          maxLines: 1,
                                          'min ${response.main.tempMin} °C',
                                          style: const TextStyle(
                                            fontSize: 100,
                                          ),
                                        ),
                                      ),
                                    if (response.main.tempMax != null)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: AutoSizeText(
                                          'max ${response.main.tempMax} °C',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          maxLines: 1,
                                          minFontSize: 4,
                                        ),
                                      ),
                                  ]),
                                ])
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
                          buildWhen: (previous, current) =>
                              previous.countriesCodeAndName !=
                                  current.countriesCodeAndName ||
                              previous.responses != current.responses,
                          builder: (context, _) => AutoSizeText(
                            '${response.name}, ${context.read<WeatherPageUiCubit>().getCountryName(response.sys.country) ?? ''}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
                  ]),
                )
              ]),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SunsetTimeSlider(response: response),
              ),
            )
          ]),
        ),
      );
}

class SunsetTimeSlider extends StatelessWidget {
  const SunsetTimeSlider({super.key, required this.response});

  final OpenWeatherResponse response;

  @override
  Widget build(_) => BlocBuilder<WeatherPageUiCubit, WeatherPageUiState>(
          builder: (context, _) {
        if (response.getSunrise() == null || response.getSunset() == null) {
          return const SizedBox.shrink();
        }
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sunset time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Stack(alignment: Alignment.center, children: [
            RangeSlider(
              values: (response.getSunrise()?.hour ?? 6) >
                      (response.getSunset()?.hour ?? 8)
                  ? RangeValues(
                      (response.getSunset()?.hour ?? 6).toDouble(),
                      (response.getSunrise()?.hour ?? 8).toDouble(),
                    )
                  : RangeValues(
                      (response.getSunrise()?.hour ?? 6).toDouble(),
                      (response.getSunset()?.hour ?? 8).toDouble(),
                    ),
              min: 0,
              max: 23,
              onChanged: (_) {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  24,
                  (index) => Expanded(
                    child: TimeOfDay.now().hour == index
                        ? Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: const Icon(
                              Icons.sunny,
                              size: 15,
                              color: Colors.yellow,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                24,
                (index) => Expanded(
                  child: AutoSizeText(
                    minFontSize: 8,
                    maxFontSize: 12,
                    index % 2 == 0 ? index.toString() : '',
                    style: const TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
        ]);
      });
}
