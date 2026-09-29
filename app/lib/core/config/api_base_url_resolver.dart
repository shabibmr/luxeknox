import 'firestore_app_config_source.dart';
import 'remote_api_base_url_store.dart';

/// Resolves `API_BASE_URL`: cache → Firestore → [fallbackUrl].
class ApiBaseUrlResolver {
  ApiBaseUrlResolver({
    required this._store,
    required this._source,
    required this._fallbackUrl,
  });

  final RemoteApiBaseUrlStore _store;
  final AppConfigRemoteSource _source;
  final String _fallbackUrl;

  Future<String> resolve() async {
    final cached = _store.read();

    final remote = await _source.fetchApiBaseUrl();
    if (remote != null) {
      if (remote != cached) {
        await _store.write(remote);
      }
      return remote;
    }

    if (cached != null) return cached;
    return _fallbackUrl;
  }
}
