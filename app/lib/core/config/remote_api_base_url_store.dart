import 'package:shared_preferences/shared_preferences.dart';

/// Local cache for the remote `API_BASE_URL` from Firestore. Values are stored
/// as given; `ApiBaseUrlResolver.normalize` cleans them up.
class RemoteApiBaseUrlStore {
  RemoteApiBaseUrlStore(this._prefs);

  static const String key = 'api_base_url';

  final SharedPreferences _prefs;

  String? read() => _prefs.getString(key);

  Future<void> write(String url) => _prefs.setString(key, url);
}
