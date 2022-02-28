import 'package:logger/logger.dart';
import 'retrofit_server.dart';

class LoggerPrint{
  static var logger = Logger();

  static void d(String message) {
    if (isTester) logger.d(message);
  }

  static void i(String message) {
    if (isTester) logger.i(message);
  }

  static void w(String message) {
    if (isTester) logger.w(message);
  }

  static void e(String message) {
    if (isTester) logger.e(message);
  }

}