import 'package:logger/logger.dart';

class WeatherLogger {
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
