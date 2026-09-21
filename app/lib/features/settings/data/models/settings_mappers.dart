import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/app_setting.dart';
import '../../domain/entities/setting_category.dart';

SettingCategory _categoryFromApi(api.SettingCategory category) {
  return parseSettingCategory(category.name) ?? SettingCategory.general;
}

api.SettingCategory categoryToApi(SettingCategory category) {
  return api.SettingCategory.values.firstWhere(
    (v) => v.name == category.wireName,
    orElse: () => api.SettingCategory.general,
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
