import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/data/open_weather_response.dart';

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
