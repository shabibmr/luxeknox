import 'package:equatable/equatable.dart';

import 'setting_category.dart';

/// A single key/value gym setting.
class AppSetting extends Equatable {
  const AppSetting({
    required this.key,
    required this.value,
    required this.category,
  });

  final String key;
  final String value;
  final SettingCategory category;

  AppSetting copyWith({String? value}) =>
      AppSetting(key: key, value: value ?? this.value, category: category);

  @override
  List<Object?> get props => [key, value, category];
}
