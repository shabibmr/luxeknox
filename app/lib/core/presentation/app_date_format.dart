import 'package:intl/intl.dart';

/// Shared date/time formatting for people, PT, and workout screens.
abstract final class AppDateFormat {
  static final DateFormat _mediumDate = DateFormat.yMMMd();
  static final DateFormat _mediumDateTime = DateFormat.yMMMd().add_jm();
  static final DateFormat _historyDateTime = DateFormat('MMM d, yyyy · h:mm a');
  static final DateFormat _weekdayDateTime = DateFormat('EEE, MMM d • HH:mm');
  static final DateFormat _shortDayMonth = DateFormat('dd MMM');

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// Calendar date as `YYYY-MM-DD`, using the date's own year/month/day.
  static String calendarDate(DateTime date) =>
      '${date.year}-${_two(date.month)}-${_two(date.day)}';

  /// Localized medium date (`Jan 1, 2026`).
  static String mediumDate(DateTime date) => _mediumDate.format(date);

  /// Localized medium date and time in local zone.
  static String mediumDateTime(DateTime date) =>
      _mediumDateTime.format(date.toLocal());

  /// Exercise-history stamp (`Jan 1, 2026 · 10:00 AM`).
  static String historyDateTime(DateTime date) =>
      _historyDateTime.format(date.toLocal());

  /// Weekday, short month, day, and 24h time in local zone.
  static String weekdayDateTime(DateTime date) =>
      _weekdayDateTime.format(date.toLocal());

  /// Short day + month (`01 Jan`).
  static String shortDayMonth(DateTime date) => _shortDayMonth.format(date);

  /// Compact local stamp `yyyy-MM-dd HH:mm`.
  static String sessionStamp(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)} '
        '${_two(local.hour)}:${_two(local.minute)}';
  }
}
