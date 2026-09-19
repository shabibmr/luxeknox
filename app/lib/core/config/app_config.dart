/// Application environment name.
enum AppEnvironment {
  dev,
  staging,
  production;

  static AppEnvironment fromString(String value) {
    switch (value.toLowerCase()) {
      case 'staging':
        return AppEnvironment.staging;
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'dev':
      case 'development':
      default:
        return AppEnvironment.dev;
    }
  }
}

/// Compile-time / runtime environment configuration for the app.
///
/// Values are supplied via `--dart-define=API_BASE_URL=...` and
/// `--dart-define=ENV=...`. When not supplied, sensible dev defaults are
/// used so local development works out of the box.
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.environment});

  final String apiBaseUrl;
  final AppEnvironment environment;

  static const String _defaultApiBaseUrl = 'https://api.dev.luxeknox.com';
  static const String _defaultEnv = 'dev';

  static const String _apiBaseUrlDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );

  static const String _envDefine = String.fromEnvironment(
    'ENV',
    defaultValue: _defaultEnv,
  );

  /// Builds an [AppConfig] from the `--dart-define` values supplied at
  /// build/run time, falling back to development defaults.
  factory AppConfig.fromEnv() {
    return AppConfig(
      apiBaseUrl: _apiBaseUrlDefine,
      environment: AppEnvironment.fromString(_envDefine),
    );
  }

  bool get isDev => environment == AppEnvironment.dev;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;
}
