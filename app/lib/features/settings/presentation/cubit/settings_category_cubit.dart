import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/app_setting.dart';
import '../../domain/entities/setting_category.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';

part 'settings_category_cubit.freezed.dart';

@freezed
abstract class SettingsCategoryState with _$SettingsCategoryState {
  const SettingsCategoryState._();

  const factory SettingsCategoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<AppSetting>[]) List<AppSetting> items,
    @Default(<AppSetting>[]) List<AppSetting> originalItems,
    @Default(false) bool saving,
    @Default(false) bool saved,
    Failure? failure,
  }) = _SettingsCategoryState;

  bool get dirty => items.length != originalItems.length ||
      items.asMap().entries.any((entry) =>
          entry.value.key != originalItems[entry.key].key ||
          entry.value.value != originalItems[entry.key].value);
}

@injectable
class SettingsCategoryCubit extends Cubit<SettingsCategoryState> {
  SettingsCategoryCubit(this._getSettings, this._updateSettings)
      : super(const SettingsCategoryState());

  final GetSettingsUseCase _getSettings;
  final UpdateSettingsUseCase _updateSettings;

  SettingCategory? _category;
  int _loadGeneration = 0;

  bool get _editable => state.status == LoadStatus.success;

  Future<void> load(SettingCategory category) async {
    _category = category;
    final generation = ++_loadGeneration;
    emit(state.copyWith(
      status: LoadStatus.loading,
      failure: null,
      saving: false,
      saved: false,
    ));
    final result = await _getSettings(GetSettingsParams(category: category));
    if (isClosed || generation != _loadGeneration) return;
    result.fold(
      (failure) => emit(state.copyWith(
        status: LoadStatus.failure,
        failure: failure,
      )),
      (items) => emit(state.copyWith(
        status: LoadStatus.success,
        items: items,
        originalItems: items,
        failure: null,
        saving: false,
        saved: false,
      )),
    );
  }

  void editValue(String key, String value) {
    if (!_editable) return;
    emit(state.copyWith(
      items: [
        for (final item in state.items)
          if (item.key == key) item.copyWith(value: value) else item,
      ],
      saved: false,
      failure: null,
    ));
  }

  /// Settings keys are catalogue-owned: the UI cannot create arbitrary keys.
  @Deprecated('Settings must be defined by the backend catalogue.')
  void addSetting(String key, String value) {}

  /// Omitted settings are not deleted by the API, so local removal is disabled.
  @Deprecated('Settings are not deletable. Reset to default instead.')
  void removeSetting(String key) {}

  Future<void> save() async {
    if (!_editable || state.saving || !state.dirty) return;
    final current = state;
    emit(current.copyWith(saving: true, saved: false, failure: null));
    final result = await _updateSettings(current.items);
    result.fold(
      (failure) => emit(state.copyWith(
        saving: false,
        saved: false,
        failure: failure,
      )),
      (items) => emit(state.copyWith(
        status: LoadStatus.success,
        items: items,
        originalItems: items,
        saving: false,
        saved: true,
        failure: null,
      )),
    );
  }
}
