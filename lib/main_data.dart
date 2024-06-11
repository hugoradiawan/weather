import 'package:weather/typedefs.dart';

class Main {
  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  final double? temp,
      feelsLike,
      tempMin,
      tempMax,
      pressure,
      humidity,
      seaLevel,
      grndLevel;

  factory Main.fromJson(JSON json) => Main(
        temp: double.tryParse('${json['temp']}'),
        feelsLike: double.tryParse('${json['feels_like']}'),
        tempMin: double.tryParse('${json['temp_min']}'),
        tempMax: double.tryParse('${json['temp_max']}'),
        pressure: double.tryParse('${json['pressure']}'),
        humidity: double.tryParse('${json['humidity']}'),
        seaLevel: double.tryParse('${json['sea_level']}'),
        grndLevel: double.tryParse('${json['grnd_level']}'),
      );

  JSON toJson() => {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
        'sea_level': seaLevel,
        'grnd_level': grndLevel,
      };
}
