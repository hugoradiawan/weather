import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather/utils/weather_logger.dart';

class WeatherBlocObserver extends BlocObserver {
  final List<String> blocNames;
  WeatherBlocObserver({this.blocNames = const []});
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    final DateTime time = DateTime.now();
    WeatherLogger.i(
        '${bloc.runtimeType}: ${time.minute.toString().padLeft(1, '0')}:${time.second.toString().padLeft(1, '0')}:${time.millisecond}');
    for (int i = 0; i < change.currentState.props.length; i++) {
      try {
        WeatherLogger.i(
            '   ${change.currentState.props[i]} 👉 ${change.nextState.props[i]}');
      } catch (e) {
        WeatherLogger.i('   ${change.currentState.props[i]}');
      }
    }
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    final DateTime time = DateTime.now();
    WeatherLogger.w(
        '${bloc.runtimeType}: ${time.minute.toString().padLeft(1, '0')}:${time.second.toString().padLeft(1, '0')}:${time.millisecond}  ${transition.currentState.runtimeType} 👉 ${transition.nextState.runtimeType}');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    final DateTime time = DateTime.now();
    WeatherLogger.e(
        '${bloc.runtimeType}: ${time.minute.toString().padLeft(1, '0')}:${time.second.toString().padLeft(1, '0')}:${time.millisecond}');
    WeatherLogger.f(error);
    for (final String line in stackTrace.toString().split('\n')) {
      WeatherLogger.f('   $line');
    }
    super.onError(bloc, error, stackTrace);
  }
}