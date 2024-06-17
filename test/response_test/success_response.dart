import 'package:weather/utils/typedefs.dart';

final JSON successResponse = {
  "coord": {"lon": 106.8451, "lat": -6.2146},
  "weather": [
    {"id": 801, "main": "Clouds", "description": "few clouds", "icon": "02n"}
  ],
  "base": "stations",
  "main": {
    "temp": 27.83,
    "feels_like": 31.26,
    "temp_min": 27.72,
    "temp_max": 28.21,
    "pressure": 1011,
    "humidity": 77,
    "sea_level": 1011,
    "grnd_level": 1009
  },
  "visibility": 10000,
  "wind": {"speed": 2.11, "deg": 120, "gust": 3.24},
  "clouds": {"all": 15},
  "dt": 1718648824,
  "sys": {
    "type": 2,
    "id": 2033644,
    "country": "ID",
    "sunrise": 1718665256,
    "sunset": 1718707596
  },
  "timezone": 25200,
  "id": 1642911,
  "name": "Jakarta",
  "cod": 200
};
