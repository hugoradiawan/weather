import 'package:weather/features/weather_homepage/data/coordinate.dart';

abstract class OpenWeatherApiEvent {
  OpenWeatherApiEvent();
}

class GetWeatherEvent extends OpenWeatherApiEvent {
  GetWeatherEvent(this.coordinate);

  final Coordinate coordinate;
}
