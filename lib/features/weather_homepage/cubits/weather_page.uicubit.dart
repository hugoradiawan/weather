import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_apibloc.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_event.dart';
import 'package:weather/features/weather_homepage/blocs/open_weather/open_weather_state.dart';
import 'package:weather/features/weather_homepage/cubits/weather_page.uistate.dart';
import 'package:weather/features/weather_homepage/presentation/dialogs/add_city_dialog.dart';
import 'package:weather/utils/typedefs.dart';

class WeatherPageUiCubit extends HydratedCubit<WeatherPageUiState> {
  WeatherPageUiCubit({required this.apiBloc})
      : super(const WeatherPageUiState()) {
    _subscription = apiBloc.stream.listen(_onApiStateChange);
    emit(state.copyWith(
      cityTec: TextEditingController(),
      refreshController: RefreshController(),
    ));
    extractCountries();
  }

  final OpenWeatherApiBloc apiBloc;
  late final StreamSubscription<OpenWeatherApiState> _subscription;

  void _onApiStateChange(OpenWeatherApiState newState) {
    switch (newState) {
      case OpenWeatherSuccess success:
        emit(state.copyWith(
          responses: {
            ...state.responses ?? {},
            success.response.name: success.response
          },
        ));
        state.cityTec?.clear();
        state.refreshController?.refreshCompleted();
        break;
      case OpenWeatherFailure fail:
        emit(state.copyWith(
          failure: fail.failure,
        ));
        state.refreshController?.refreshFailed();
        break;
      case OpenWeatherLoading _:
        state.refreshController?.requestRefresh();
        emit(state.copyWith(isLoading: true));
        break;
    }
  }

  void refreshWeather() {
    for (final key in state.responses?.keys.toList() ?? []) {
      apiBloc.add(GetWeatherByCityEvent(key));
    }
  }

  void showAddCityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddCityDialog(mainContext: context),
    );
  }

  void listenToWeatherApiBloc(
    BuildContext context,
    WeatherPageUiState state,
  ) {
    if (state.failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.failure!.message)),
      );
    } else if (state.isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading...')),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void addCity() {
    if (state.cityTec?.text == '') return;
    apiBloc.add(GetWeatherByCityEvent(state.cityTec!.text));
  }

  void fetchWeatherByCity() {
    if (state.cityTec?.text == '') return;
    apiBloc.add(GetWeatherByCityEvent(state.cityTec!.text));
  }

  String? getCountryName(String countryCode) {
    return state.countriesCodeAndName?[countryCode.toUpperCase()]
        ?.replaceAll(' (the)', '');
  }

  void extractCountries() {
    rootBundle.load('assets/countries.csv').then((data) {
      final String value =
          utf8.decode(data.buffer.asUint8List(), allowMalformed: true);
      final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
          .convert(value, fieldDelimiter: ';')
          .skip(1)
          .toList();
      final Map<String, String> countries = Map.fromEntries(
        rowsAsListOfValues.map(
            (e) => MapEntry(e[1].toString().toUpperCase(), e[0].toString())),
      );
      emit(state.copyWith(countriesCodeAndName: countries));
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    state.cityTec?.dispose();
    state.refreshController?.dispose();
    return super.close();
  }

  @override
  WeatherPageUiState? fromJson(JSON json) {
    final temp = json;
    temp.remove('countriesCodeAndName');
    log('fromJSON: $json');
    return WeatherPageUiState.fromJson(json);
  }

  @override
  JSON? toJson(WeatherPageUiState state) {
    final temp = state.toJson();
    // delete key countriesCodeAndName
    temp.remove('countriesCodeAndName');
    log(temp.toString());
    return state.toJson();
  }
}
