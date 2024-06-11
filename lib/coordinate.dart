import 'package:equatable/equatable.dart';
import 'package:weather/typedefs.dart';

class Coordinate extends Equatable {
  const Coordinate({
    required this.longitude,
    required this.latitude,
  });

  final double longitude, latitude;

  factory Coordinate.fromJson(JSON json) => Coordinate(
        longitude: json['lon'],
        latitude: json['lat'],
      );

  JSON toJson() => {
        'lon': longitude,
        'lat': latitude,
      };

  @override
  List<Object?> get props => [longitude, latitude];
}