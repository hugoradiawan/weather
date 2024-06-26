import 'package:weather/utils/typedefs.dart';

class Weather {
  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  final int id;
  final String main, description, icon;

  static Weather? fromJson(JSON? json) {
    if (json == null) return null;
    return Weather(
        id: json['id'],
        main: json['main'],
        description: json['description'],
        icon: json['icon'],
      );
  }

  JSON toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}