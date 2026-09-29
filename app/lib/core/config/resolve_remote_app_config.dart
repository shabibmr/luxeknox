import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import 'api_base_url_resolver.dart';
import 'app_config.dart';
import 'app_config_bootstrap.dart';
import 'firestore_app_config_source.dart';
import 'remote_api_base_url_store.dart';

/// Initializes Firebase (when configured), resolves `API_BASE_URL`, and
/// stores the result on [AppConfigBootstrap.resolved].
Future<AppConfig> resolveRemoteAppConfig() async {
  final env = AppConfig.fromEnv();

  if (!DefaultFirebaseOptions.isConfigured) {
    AppConfigBootstrap.resolved = env;
    return env;
  }

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final prefs = await SharedPreferences.getInstance();
  final store = RemoteApiBaseUrlStore(prefs);
  final resolver = ApiBaseUrlResolver(
    store: store,
    source: FirestoreAppConfigSource(),
    fallbackUrl: env.apiBaseUrl,
  );

  final apiBaseUrl = await resolver.resolve();
  final resolved = env.copyWith(apiBaseUrl: apiBaseUrl);
  AppConfigBootstrap.resolved = resolved;
  return resolved;
}
