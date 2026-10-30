import '../../../core/presentation/app_date_format.dart';

/// Calendar date as `YYYY-MM-DD`, using the date's own year/month/day.
String formatReviewDate(DateTime date) => AppDateFormat.calendarDate(date);

/// Body-measure number. Whole values drop the fraction. A positive [signed]
/// change gains a leading `+`.
String formatReviewMeasure(num? value, {bool signed = false}) {
  if (value == null) return '—';
  var text = value.toStringAsFixed(2);
  if (text.contains('.')) {
    text = text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
  if (signed && value > 0) return '+$text';
  return text;
}
