import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';
import 'package:weather/features/weather_homepage/presentation/components/sunset_time_slider.dart';

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