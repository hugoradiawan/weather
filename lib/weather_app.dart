import 'package:flutter/material.dart';
import 'package:weather/features/weather_homepage/presentation/open_weather_home_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(_) => MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey,
          ),
          useMaterial3: true,
        ),
        home: OpenWeatherHomePage(),
      );
}
