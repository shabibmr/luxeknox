import 'package:shared_preferences/shared_preferences.dart';

/// Local cache for the remote `API_BASE_URL` from Firestore. Values are stored
/// as given; `ApiBaseUrlResolver.normalize` cleans them up.
class RemoteApiBaseUrlStore {
  RemoteApiBaseUrlStore(this._prefs, {this.key = defaultKey});

  static const String defaultKey = 'api_base_url';

  /// Separate cache key for non-production builds: they can share a web origin
  /// with production (e.g. app.luxeknox.com/test/), and must not read its cache.
  static const String debugKey = 'api_base_url_debug';

  final String key;

  final SharedPreferences _prefs;

  String? read() => _prefs.getString(key);

  Future<void> write(String url) => _prefs.setString(key, url);
}
