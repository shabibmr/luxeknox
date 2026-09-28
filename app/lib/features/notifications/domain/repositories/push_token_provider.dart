/// Abstraction over the platform push token (FCM when configured).
///
/// When Firebase is not configured, [isLive] is false and [getToken] returns
/// null so [DeviceTokenRegistrar] can fall back to a stub token.
abstract class PushTokenProvider {
  /// True when Firebase is configured and messaging has started successfully.
  bool get isLive;

  /// Initializes Firebase + messaging permissions when configured.
  Future<void> ensureStarted();

  /// Current FCM token, or null when unavailable / not live.
  Future<String?> getToken({bool forceRefresh = false});

  /// Emits new tokens after rotation by the FCM SDK.
  Stream<String> get onTokenRefresh;
}
