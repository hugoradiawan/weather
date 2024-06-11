import 'package:weather/utils/typedefs.dart';

class Wind {
  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  final double? speed, deg, gust;

  factory Wind.fromJson(JSON json) => Wind(
        speed: double.tryParse('${json['speed']}'),
        deg: double.tryParse('${json['deg']}'),
        gust: double.tryParse('${json['gust']}'),
      );

  JSON toJson() => {
        'speed': speed,
        'deg': deg,
        'gust': gust,
      };
}
