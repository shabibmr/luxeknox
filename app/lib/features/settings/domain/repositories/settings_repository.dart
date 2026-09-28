import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_setting.dart';
import '../entities/gym_public_settings.dart';
import '../entities/setting_category.dart';

abstract class SettingsRepository {
  /// All settings, or only those in [category] when provided.
  Future<Either<Failure, List<AppSetting>>> getSettings({
    SettingCategory? category,
  });

  /// Upserts the given key/value pairs. Returns the full settings list.
  Future<Either<Failure, List<AppSetting>>> updateSettings(
    List<AppSetting> items,
  );

  /// Unauthenticated gym-wide display settings (timezone, currency, ...).
  Future<Either<Failure, GymPublicSettings>> getPublicSettings();
}
