import 'app_config.dart';

/// Holds the runtime [AppConfig] resolved before DI init.
class AppConfigBootstrap {
  AppConfigBootstrap._();

  static AppConfig? resolved;
}
