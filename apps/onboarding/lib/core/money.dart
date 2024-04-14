import 'package:intl/intl.dart';

class Money {
  static final _format = NumberFormat.simpleCurrency();

  static String format(double value) {
    return _format.format(value);
  }
}
