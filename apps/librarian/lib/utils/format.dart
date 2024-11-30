import 'package:intl/intl.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');
final _humanDateFormat = DateFormat('MM/dd/yyyy');

String? formatNumber(double? n) {
  return n == null ? null : NumberFormat.decimalPattern('en').format(n);
}

String formatDate(DateTime dateTime) {
  return _dateFormat.format(dateTime);
}

String formatDateForHumans(DateTime dateTime) {
  return _humanDateFormat.format(dateTime);
}

String formatHours(int seconds) {
  Duration duration = Duration(seconds: seconds);
  return [duration.inHours, duration.inMinutes]
      .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
      .join(':');
}

String formatPhone(String phone) {
  final parsed = PhoneNumber.parse(phone, callerCountry: IsoCode.US);
  return parsed.formatNsn();
}
