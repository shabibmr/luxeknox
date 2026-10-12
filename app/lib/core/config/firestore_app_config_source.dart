import 'package:cloud_firestore/cloud_firestore.dart';

/// Source of remote `API_BASE_URL` values.
abstract class AppConfigRemoteSource {
  Future<String?> fetchApiBaseUrl();
}

/// Reads remote app config from Firestore `config/app`.
class FirestoreAppConfigSource implements AppConfigRemoteSource {
  FirestoreAppConfigSource({
    this._firestore,
    this.apiBaseUrlField = defaultApiBaseUrlField,
  });

  static const String collection = 'config';
  static const String document = 'app';
  static const String defaultApiBaseUrlField = 'API_BASE_URL';

  /// Field read by non-production builds (debug/staging/test), so they can
  /// point at a different API than production.
  static const String debugApiBaseUrlField = 'API_BASE_URL_DEBUG';

  final String apiBaseUrlField;

  /// Resolved on first fetch, so a failed Firebase init surfaces as a fetch
  /// error rather than a constructor throw.
  final FirebaseFirestore? _firestore;

  /// Returns the raw `API_BASE_URL`, or null if the doc or field is missing.
  /// Throws on read errors and after a 2s timeout.
  @override
  Future<String?> fetchApiBaseUrl() async {
    final snap = await (_firestore ?? FirebaseFirestore.instance)
        .collection(collection)
        .doc(document)
        .get()
        .timeout(const Duration(seconds: 2));
    final raw = snap.data()?[apiBaseUrlField];
    return raw is String ? raw : null;
  }
}
