import 'package:injectable/injectable.dart';

import '../../features/settings/domain/usecases/get_public_settings_usecase.dart';
import '../usecase/usecase.dart';

/// Caches the gym's configured IANA timezone name (from `GET /settings/public`)
/// for the lifetime of the app session.
///
/// The app has no timezone-conversion library; this only surfaces the label
/// so date/time pickers can tell the user which timezone their input is
/// interpreted in. It does not convert between the device's and the gym's
/// timezone — callers submit wall-clock values as picked.
@lazySingleton
class GymTimezoneProvider {
  GymTimezoneProvider(this._getPublicSettings);

  final GetPublicSettingsUseCase _getPublicSettings;

  String? _cachedTimezone;

  /// The cached timezone name, if [timezone] has already resolved once.
  String? get cachedTimezone => _cachedTimezone;

  /// Returns the gym's IANA timezone name (e.g. `Asia/Kolkata`), fetching and
  /// caching it on first call. Falls back to `null` on failure so callers can
  /// degrade gracefully (e.g. hide the timezone caption).
  Future<String?> timezone() async {
    final cached = _cachedTimezone;
    if (cached != null) return cached;
    final result = await _getPublicSettings(const NoParams());
    return result.fold((_) => null, (settings) {
      _cachedTimezone = settings.timezone;
      return settings.timezone;
    });
  }

  /// Resolves the UTC offset Duration for the gym timezone.
  /// Falls back to local device offset if unresolved.
  Duration getOffset([String? tzName]) {
    final name = tzName ?? _cachedTimezone;
    if (name == null) return DateTime.now().timeZoneOffset;
    return parseTimezoneOffset(name) ?? DateTime.now().timeZoneOffset;
  }
}

/// Parses an offset Duration from an IANA timezone name or offset string (+HH:MM, -HH:MM, Z).
Duration? parseTimezoneOffset(String tz) {
  final trimmed = tz.trim();
  if (trimmed.isEmpty || trimmed == 'UTC' || trimmed == 'GMT' || trimmed == 'Z') {
    return Duration.zero;
  }
  final regex = RegExp(r'^(?:UTC|GMT)?\s*([+-])(\d{1,2})(?::?(\d{2}))?$');
  final match = regex.firstMatch(trimmed);
  if (match != null) {
    final sign = match.group(1) == '-' ? -1 : 1;
    final hours = int.parse(match.group(2)!);
    final minutes = match.group(3) != null ? int.parse(match.group(3)!) : 0;
    return Duration(minutes: sign * (hours * 60 + minutes));
  }
  const known = <String, Duration>{
    'Asia/Kolkata': Duration(hours: 5, minutes: 30),
    'Asia/Calcutta': Duration(hours: 5, minutes: 30),
    'Asia/Colombo': Duration(hours: 5, minutes: 30),
    'Asia/Dubai': Duration(hours: 4),
    'Asia/Singapore': Duration(hours: 8),
    'Asia/Tokyo': Duration(hours: 9),
    'Asia/Bangkok': Duration(hours: 7),
    'Asia/Hong_Kong': Duration(hours: 8),
    'Europe/London': Duration.zero,
    'Europe/Paris': Duration(hours: 1),
    'Europe/Berlin': Duration(hours: 1),
    'America/New_York': Duration(hours: -5),
    'America/Chicago': Duration(hours: -6),
    'America/Denver': Duration(hours: -7),
    'America/Los_Angeles': Duration(hours: -8),
    'Australia/Sydney': Duration(hours: 10),
  };
  return known[trimmed];
}
