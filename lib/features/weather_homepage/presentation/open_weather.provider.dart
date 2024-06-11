import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_apibloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_repository.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uicubit.dart';

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
