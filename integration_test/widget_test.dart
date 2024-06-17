import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/features/weather_homepage/presentation/open_weather_home_page.dart';

import '../test/mocks/mock_sucess_open_weather_repository.dart';

class MockStorage extends Mock implements Storage {
  @override
  Future<void> clear() async {
    return;
  }

  @override
  Future<void> close() async {
    return;
  }

  @override
  Future<void> delete(String key) async {}

  @override
  read(String key) => null;

  @override
  Future<void> write(String key, value) async {}
}

void main() {
  setUp(() {
    HydratedBloc.storage = MockStorage();
  });

  testWidgets('Test Positive Response from Server',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
        ),
        useMaterial3: true,
      ),
      home: OpenWeatherHomePage(
        repository: MockSucessOpenWeatherRepository(),
      ),
    ));

    await tester.tap(find.byIcon(Icons.location_city));
    await tester.pumpAndSettle();

    final Finder textField = find.byType(TextField);
    final Finder button = find.text('Add');
    await tester.tap(textField);
    await tester.pumpAndSettle();
    await tester.enterText(textField, 'jakarta');
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Jakarta, Indonesia'), findsOneWidget);
    expect(find.text('Clouds'), findsOneWidget);
  });
}
