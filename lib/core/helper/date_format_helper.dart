import 'package:intl/intl.dart';

abstract class DateFormatHelper {
  /// Wed, 12 Sep
  static String dayMonth(DateTime date, {String? locale}) =>
      DateFormat('EEE, d MMM', locale).format(date);

  /// Wed, 12 Sep 2026
  static String dayMonthYear(DateTime date, {String? locale}) =>
      DateFormat('EEE, d MMM y', locale).format(date);
}
