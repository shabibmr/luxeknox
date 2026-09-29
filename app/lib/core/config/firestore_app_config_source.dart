import 'package:cloud_firestore/cloud_firestore.dart';

/// Source of remote `API_BASE_URL` values.
abstract class AppConfigRemoteSource {
  Future<String?> fetchApiBaseUrl();
}

/// Reads remote app config from Firestore `config/app`.
class FirestoreAppConfigSource implements AppConfigRemoteSource {
  FirestoreAppConfigSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collection = 'config';
  static const String document = 'app';
  static const String apiBaseUrlField = 'API_BASE_URL';

  final FirebaseFirestore _firestore;

  /// Returns a non-empty `API_BASE_URL`, or null if missing / unreadable.
  @override
  Future<String?> fetchApiBaseUrl() async {
    try {
      final snap = await _firestore
          .collection(collection)
          .doc(document)
          .get();
      if (!snap.exists) return null;
      final raw = snap.data()?[apiBaseUrlField];
      if (raw is! String) return null;
      final trimmed = raw.trim();
      return trimmed.isEmpty ? null : trimmed;
    } catch (_) {
      return null;
    }
  }
}
