import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather/weather_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = YouAppBlocObserver(blocNames: ['WeatherPageUiCubit']);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(const WeatherApp());
}

class YouAppBlocObserver extends BlocObserver {
  final List<String> blocNames;
  YouAppBlocObserver({this.blocNames = const []});
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    final DateTime time = DateTime.now();
    YouLogger.i(
        '${bloc.runtimeType}: ${time.minute.toString().padLeft(1, '0')}:${time.second.toString().padLeft(1, '0')}:${time.millisecond}');
    for (int i = 0; i < change.currentState.props.length; i++) {
      try {
        YouLogger.i(
            '   ${change.currentState.props[i]} 👉 ${change.nextState.props[i]}');
      } catch (e) {
        YouLogger.i('   ${change.currentState.props[i]}');
      }
    }
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    final DateTime time = DateTime.now();
    YouLogger.w(
        '${bloc.runtimeType}: ${time.minute.toString().padLeft(1, '0')}:${time.second.toString().padLeft(1, '0')}:${time.millisecond}  ${transition.currentState.runtimeType} 👉 ${transition.nextState.runtimeType}');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (!blocNames.contains(bloc.runtimeType.toString())) return;
    final DateTime time = DateTime.now();
    YouLogger.e(
        '${bloc.runtimeType}: ${time.minute.toString().padLeft(1, '0')}:${time.second.toString().padLeft(1, '0')}:${time.millisecond}');
    YouLogger.f(error);
    for (final String line in stackTrace.toString().split('\n')) {
      YouLogger.f('   $line');
    }
    super.onError(bloc, error, stackTrace);
  }
}

class YouLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      levelEmojis: {
        Level.info: '✍',
        Level.error: '🚨',
        Level.fatal: '❗',
        Level.warning: '🔍',
        Level.trace: '🖥️',
        Level.off: '🚦',
      },
      levelColors: {
        // onChange
        Level.info: const AnsiColor.fg(3),
        // onError
        Level.error: const AnsiColor.fg(1),
        Level.fatal: const AnsiColor.fg(166),
        // onTransition
        Level.warning: const AnsiColor.fg(4),
        Level.trace: const AnsiColor.fg(15),
        Level.off: const AnsiColor.fg(8),
      },
      printTime: false,
      noBoxingByDefault: true,
    ),
  );

  static void i(dynamic message) => _logger.i(message);

  static void w(dynamic message) => _logger.w(message);

  static void e(dynamic message) => _logger.e(message);

  static void f(dynamic message) => _logger.e(message);

  static void debug(dynamic message) => _logger.log(Level.off, message);

  static void seeResponse({required String label, required dynamic response}) {
    _logger.i('Response from $label');
    _logger.t(response);
  }
}
