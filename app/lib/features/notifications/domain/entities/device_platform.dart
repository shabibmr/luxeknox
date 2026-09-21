enum DevicePlatform {
  ios,
  android,
  web;

  String get wireName => name;

  static DevicePlatform fromWire(String raw) {
    final normalized = raw.trim().toLowerCase();
    return DevicePlatform.values.firstWhere(
      (v) => v.name == normalized,
      orElse: () => DevicePlatform.android,
    );
  }
}
