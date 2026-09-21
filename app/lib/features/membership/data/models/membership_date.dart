import 'package:api_client/api_client.dart' as api;

/// `api.Date` <-> `DateTime` conversion shared by the membership models.
/// Membership dates (start/end/freeze range) are calendar dates, not
/// instants, so only year/month/day round-trip — time-of-day is discarded.
DateTime apiDateToDateTime(api.Date date) =>
    DateTime(date.year, date.month, date.day);

api.Date dateTimeToApiDate(DateTime dateTime) =>
    api.Date(dateTime.year, dateTime.month, dateTime.day);
