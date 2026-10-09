import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/app_setting.dart';
import '../../domain/entities/gym_public_settings.dart';
import '../../domain/entities/setting_category.dart';

SettingCategory _categoryFromApi(api.SettingCategory category) {
  final parsed = parseSettingCategory(category.name);
  if (parsed == null) {
    throw FormatException('Unsupported settings category from API: ${category.name}');
  }
  return parsed;
}

api.SettingCategory categoryToApi(SettingCategory category) {
  return api.SettingCategory.values.firstWhere(
    (value) => value.name == category.wireName ||
        value.name == category.name,
    orElse: () => throw StateError(
      'Settings category ${category.wireName} is not supported by api_client. '
      'Regenerate the client from docs/openapi/v1.yaml.',
    ),
  );
}

AppSetting appSettingFromApi(api.Setting setting) {
  return AppSetting(
    key: setting.settingKey,
    value: setting.settingValue,
    category: _categoryFromApi(setting.category),
  );
}

api.SettingsWriteItemsInner settingsWriteItemFromDomain(AppSetting setting) {
  return api.SettingsWriteItemsInner(
    (b) => b
      ..settingKey = setting.key
      ..settingValue = setting.value,
  );
}

GymPublicSettings gymPublicSettingsFromApi(api.PublicSettings settings) {
  return GymPublicSettings(
    timezone: settings.timezone,
    currency: settings.currency,
    dateFormat: settings.dateFormat,
    defaultPageSize: settings.defaultPageSize,
    operatingHours: settings.operatingHours,
    cancellationCutoffMinutes: settings.cancellationCutoffMinutes,
  );
}
