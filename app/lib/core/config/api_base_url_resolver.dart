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

  /// Ensures the Nest global prefix `/v1` is present on absolute API base URLs.
  ///
  /// Firestore has been seeded without `/v1` (`https://api.luxeknox.com`); Nest
  /// only serves routes under `/v1`, so login and every other call 404 without it.
  static String normalize(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;

    final withoutTrailingSlash = trimmed.replaceFirst(RegExp(r'/+$'), '');
    if (withoutTrailingSlash.endsWith('/v1')) {
      return withoutTrailingSlash;
    }
    return '$withoutTrailingSlash/v1';
  }

  Future<String> resolve() async {
    final cached = _store.read();

    final remote = await _source.fetchApiBaseUrl();
    if (remote != null) {
      final normalized = normalize(remote);
      if (normalized != cached) {
        await _store.write(normalized);
      }
      return normalized;
    }

    if (cached != null) return normalize(cached);
    return normalize(_fallbackUrl);
  }
}
