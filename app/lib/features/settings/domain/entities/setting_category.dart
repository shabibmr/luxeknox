/// Gym settings categories, mirroring the backend `SettingCategory` enum
/// (see `api_client`'s `SettingCategory`).
enum SettingCategory {
  general,
  membership,
  attendanceGate,
  bookingRules,
  billing,
  workout,
  diet,
  notification,
  measurement,
}

extension SettingCategoryX on SettingCategory {
  /// OpenAPI / path wire value.
  String get wireName => switch (this) {
    SettingCategory.general => 'general',
    SettingCategory.membership => 'membership',
    SettingCategory.attendanceGate => 'attendance_gate',
    SettingCategory.bookingRules => 'booking_rules',
    SettingCategory.billing => 'billing',
    SettingCategory.workout => 'workout',
    SettingCategory.diet => 'diet',
    SettingCategory.notification => 'notification',
    SettingCategory.measurement => 'measurement',
  };

  /// URL category segment.
  String get category => wireName;

  String get label => switch (this) {
    SettingCategory.general => 'General',
    SettingCategory.membership => 'Membership',
    SettingCategory.attendanceGate => 'Attendance Gate',
    SettingCategory.bookingRules => 'Booking Rules',
    SettingCategory.billing => 'Billing',
    SettingCategory.workout => 'Workout',
    SettingCategory.diet => 'Diet',
    SettingCategory.notification => 'Notifications',
    SettingCategory.measurement => 'Measurement Units',
  };

  String get description => switch (this) {
    SettingCategory.general =>
      'Gym name, timezone, currency, and business hours.',
    SettingCategory.membership => 'Membership defaults and renewal rules.',
    SettingCategory.attendanceGate =>
      'Check-in windows and hardware/biometric gate rules.',
    SettingCategory.bookingRules => 'Class and PT booking policy.',
    SettingCategory.billing => 'Invoicing, taxes, and payment policy.',
    SettingCategory.workout => 'Workout plan defaults.',
    SettingCategory.diet => 'Diet plan defaults.',
    SettingCategory.notification => 'Notification delivery preferences.',
    SettingCategory.measurement => 'Units for weight, height, and distance.',
  };
}

/// Parses a path/category segment into a [SettingCategory].
///
/// Accepts the wire values above plus a couple of legacy nav aliases:
/// `gym` (§4 nav historically linked "Settings" straight to the general
/// gym-info category).
SettingCategory? parseSettingCategory(String raw) {
  final key = raw.trim().toLowerCase();
  if (key == 'gym') return SettingCategory.general;
  for (final value in SettingCategory.values) {
    if (value.wireName == key || value.name.toLowerCase() == key) {
      return value;
    }
  }
  return null;
}
