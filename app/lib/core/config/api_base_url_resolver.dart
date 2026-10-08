import 'dart:async';

import 'package:flutter/foundation.dart';

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

  /// Trims the URL and ensures the Nest global prefix `/v1` is present on
  /// absolute API base URLs. Returns an empty string for a blank URL.
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
    final cached = _normalizeOrNull(_store.read());
    if (cached != null) {
      unawaited(_refresh(cached));
      return cached;
    }
    final remote = await _refresh(null);
    if (remote != null) return remote;
    debugPrint('AppConfig: no remote/cached API_BASE_URL; using fallback');
    return normalize(_fallbackUrl);
  }

  /// Fetches the remote URL and caches it. Returns null when it is missing or
  /// the fetch fails.
  Future<String?> _refresh(String? cached) async {
    try {
      final remote = _normalizeOrNull(await _source.fetchApiBaseUrl());
      if (remote != null && remote != cached) await _store.write(remote);
      return remote;
    } catch (e) {
      debugPrint('AppConfig: remote API_BASE_URL fetch failed: $e');
      return null;
    }
  }

  static String? _normalizeOrNull(String? raw) {
    if (raw == null) return null;
    final normalized = normalize(raw);
    return normalized.isEmpty ? null : normalized;
  }
}
