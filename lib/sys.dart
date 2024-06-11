import 'package:weather/typedefs.dart';

class Sys {
  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  final int? type, id;
  final DateTime sunrise, sunset;
  final String country;

  factory Sys.fromJson(JSON json) => Sys(
        type: json['type'],
        id: json['id'],
        country: json['country'],
        sunrise: DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000),
        sunset: DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000),
      );

  JSON toJson() => {
        'type': type,
        'id': id,
        'country': country,
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      };
}
