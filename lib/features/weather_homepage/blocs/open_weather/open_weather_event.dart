import 'package:weather/features/weather_homepage/data/coordinate.dart';

abstract class OpenWeatherApiEvent {
  OpenWeatherApiEvent();
}

class GetWeatherByPositionEvent extends OpenWeatherApiEvent {
  GetWeatherByPositionEvent(this.coordinate);

  final Coordinate coordinate;
}

class GetWeatherByCityEvent extends OpenWeatherApiEvent {
  GetWeatherByCityEvent(this.city);

  final String city;
}
