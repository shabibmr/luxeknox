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
  const factory SettingsCategoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<AppSetting>[]) List<AppSetting> items,
    @Default(false) bool saving,
    @Default(false) bool saved,
    Failure? failure,
  }) = _SettingsCategoryState;
}

@injectable
class SettingsCategoryCubit extends Cubit<SettingsCategoryState> {
  SettingsCategoryCubit(this._getSettings, this._updateSettings)
    : super(const SettingsCategoryState());

  final GetSettingsUseCase _getSettings;
  final UpdateSettingsUseCase _updateSettings;

  SettingCategory? _category;

  bool get _editable => state.status == LoadStatus.success;

  Future<void> load(SettingCategory category) async {
    _category = category;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        saving: false,
        saved: false,
      ),
    );
    final result = await _getSettings(GetSettingsParams(category: category));
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (items) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: items,
          failure: null,
          saving: false,
          saved: false,
        ),
      ),
    );
  }

  void editValue(String key, String value) {
    if (!_editable) return;
    emit(
      state.copyWith(
        items: [
          for (final item in state.items)
            if (item.key == key) item.copyWith(value: value) else item,
        ],
        saved: false,
        failure: null,
      ),
    );
  }

  void addSetting(String key, String value) {
    final category = _category;
    if (!_editable || category == null) return;
    if (key.trim().isEmpty) return;
    if (state.items.any((item) => item.key == key)) return;
    emit(
      state.copyWith(
        items: [
          ...state.items,
          AppSetting(key: key.trim(), value: value, category: category),
        ],
        saved: false,
        failure: null,
      ),
    );
  }

  void removeSetting(String key) {
    if (!_editable) return;
    emit(
      state.copyWith(
        items: state.items.where((item) => item.key != key).toList(),
        saved: false,
        failure: null,
      ),
    );
  }

  Future<void> save() async {
    if (!_editable || state.saving) return;
    final current = state;
    emit(current.copyWith(saving: true, saved: false, failure: null));
    final result = await _updateSettings(current.items);
    result.fold(
      (failure) => emit(
        current.copyWith(saving: false, saved: false, failure: failure),
      ),
      (items) => emit(
        current.copyWith(
          status: LoadStatus.success,
          items: items,
          saving: false,
          saved: true,
          failure: null,
        ),
      ),
    );
  }
}
