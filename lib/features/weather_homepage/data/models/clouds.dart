import 'package:weather/utils/typedefs.dart';

class Clouds {
  Clouds({required this.all});

  final int all;

  factory Clouds.fromJson(JSON json) => Clouds(
        all: json['all'],
      );

  JSON toJson() => {
        'all': all,
      };
}