import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_apibloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_event.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_state.dart';

import 'mocks/mock_sucess_open_weather_repository.dart';
import 'mocks/mocks_fail_open_weather_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('OpenWeatherApiBloc', () {
    blocTest(
      'emits OpenWeatherSuccess when Weather api is added with correct city name',
      build: () => OpenWeatherApiBloc(
        repository: MockSucessOpenWeatherRepository(),
      ),
      act: (bloc) => bloc.add(GetWeatherByCityEvent('jakarta')),
      wait: const Duration(seconds: 1),
      expect: () => [
        isA<OpenWeatherLoading>(),
        isA<OpenWeatherSuccess>()
            .having(
              (s) => s.response.name,
              'name',
              equals('Jakarta'),
            )
            .having(
              (s) => s.response.sys.country,
              'country ID',
              equals('ID'),
            )
            .having(
              (s) => s.response.cod,
              'Response code',
              equals(200),
            ),
      ],
    );

    blocTest(
      'emits OpenWeatherFailure when Weather api is added with wrong city name',
      build: () => OpenWeatherApiBloc(
        repository: MockFailOpenWeatherRepository(),
      ),
      act: (bloc) => bloc.add(GetWeatherByCityEvent('nocityname')),
      wait: const Duration(seconds: 1),
      expect: () => [
        isA<OpenWeatherLoading>(),
        isA<OpenWeatherFailure>()
            .having(
              (s) => s.failure.message,
              'Message',
              equals('city not found'),
            )
            .having(
              (s) => s.failure.code,
              'Response Code',
              equals(404),
            ),
      ],
    );
  });
}
