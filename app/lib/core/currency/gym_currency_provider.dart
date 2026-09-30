import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../features/settings/domain/usecases/get_public_settings_usecase.dart';
import '../usecase/usecase.dart';

/// Caches the gym's configured currency code (from `GET /settings/public`,
/// e.g. `USD`, `INR`) for the lifetime of the app session.
///
/// Mirrors [GymTimezoneProvider]'s fetch-once-and-cache shape.
@lazySingleton
class GymCurrencyProvider {
  GymCurrencyProvider(this._getPublicSettings);

  final GetPublicSettingsUseCase _getPublicSettings;

  String? _cachedCurrencyCode;

  /// The cached ISO 4217 currency code, if [currencyCode] has already
  /// resolved once. `null` until then.
  String? get cachedCurrencyCode => _cachedCurrencyCode;

  /// Returns the gym's currency code (e.g. `USD`), fetching and caching it
  /// on first call. Falls back to `null` on failure so callers can fall back
  /// to a default symbol/decimal count.
  Future<String?> currencyCode() async {
    final cached = _cachedCurrencyCode;
    if (cached != null) return cached;
    final result = await _getPublicSettings(const NoParams());
    return result.fold((_) => null, (settings) {
      _cachedCurrencyCode = settings.currency;
      return settings.currency;
    });
  }
}

/// Number of decimal digits the given currency code is quoted in
/// (e.g. 2 for `USD`, 0 for `JPY`). Defaults to 2 for an unknown/null code.
int currencyDecimalDigits(String? currencyCode) {
  if (currencyCode == null || currencyCode.trim().isEmpty) return 2;
  try {
    return NumberFormat.simpleCurrency(name: currencyCode).decimalDigits ?? 2;
  } catch (_) {
    return 2;
  }
}

/// Display symbol for the given currency code (e.g. `$` for `USD`).
/// Falls back to the raw code, or `$` if none is set.
String currencySymbol(String? currencyCode) {
  if (currencyCode == null || currencyCode.trim().isEmpty) return r'$';
  try {
    return NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
  } catch (_) {
    return currencyCode;
  }
}
