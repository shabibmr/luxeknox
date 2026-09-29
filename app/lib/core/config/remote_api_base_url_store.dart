import 'package:shared_preferences/shared_preferences.dart';

/// Local cache for the remote `API_BASE_URL` from Firestore.
class RemoteApiBaseUrlStore {
  RemoteApiBaseUrlStore(this._prefs);

  static const String key = 'api_base_url';

  final SharedPreferences _prefs;

  String? read() {
    final value = _prefs.getString(key);
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> write(String url) async {
    await _prefs.setString(key, url.trim());
  }
}
