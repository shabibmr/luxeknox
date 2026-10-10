import 'dart:async';
import 'dart:developer' as developer;

import 'firestore_app_config_source.dart';
import 'remote_api_base_url_store.dart';

/// Resolves `API_BASE_URL`, stale-while-revalidate: a cached URL is returned
/// right away and Firestore refreshes the cache in the background for the next
/// launch. Without a cache, Firestore is awaited, then [fallbackUrl] is used.
class ApiBaseUrlResolver {
  ApiBaseUrlResolver({
    required this._store,
    required this._source,
    required this._fallbackUrl,
  });

  final RemoteApiBaseUrlStore _store;
  final AppConfigRemoteSource _source;
  final String _fallbackUrl;

  /// Canonicalizes an API base URL to `<host>/v1`. Returns an empty string
  /// for a blank value (including `/` or only slashes).
  ///
  /// Contract: Firestore `config/app` and `API_BASE_URL` hold the API host
  /// only (`https://api.luxeknox.com`). This client is built against the v1
  /// API, so it owns the version and appends `/v1` itself. A value already
  /// ending in `/v1` is canonicalized to the same result, so the output is
  /// stable. Any other version suffix (`/v2`) is left untouched rather than
  /// producing `/v2/v1`.
  static String normalize(String raw) {
    final withoutTrailingSlash = raw.trim().replaceFirst(RegExp(r'/+$'), '');
    if (withoutTrailingSlash.isEmpty) return '';
    if (RegExp(r'/v\d+$').hasMatch(withoutTrailingSlash)) {
      return withoutTrailingSlash;
    }
    return '$withoutTrailingSlash/v1';
  }

  Future<String> resolve() async {
    final cached = _normalizeOrNull(_store.read());
    if (cached != null) {
      unawaited(_refresh(cached));
      return cached;
    }
    final remote = await _refresh(null);
    if (remote != null) return remote;
    developer.log(
      'No remote/cached API_BASE_URL; using fallback',
      name: 'AppConfig',
    );
    return normalize(_fallbackUrl);
  }

  /// Fetches the remote URL and caches it. Returns null when it is missing or
  /// the fetch fails.
  Future<String?> _refresh(String? cached) async {
    try {
      final remote = _normalizeOrNull(await _source.fetchApiBaseUrl());
      if (remote != null && remote != cached) await _store.write(remote);
      return remote;
    } catch (e, st) {
      developer.log(
        'Remote API_BASE_URL fetch failed',
        name: 'AppConfig',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  static String? _normalizeOrNull(String? raw) {
    if (raw == null) return null;
    final normalized = normalize(raw);
    return normalized.isEmpty ? null : normalized;
  }
}
