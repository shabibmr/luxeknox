import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/app_setting.dart';
import '../../domain/entities/setting_category.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';

sealed class SettingsCategoryState extends Equatable {
  const SettingsCategoryState();

  @override
  List<Object?> get props => [];
}

final class SettingsCategoryLoading extends SettingsCategoryState {
  const SettingsCategoryLoading();
}

final class SettingsCategoryLoaded extends SettingsCategoryState {
  const SettingsCategoryLoaded({
    required this.items,
    this.saving = false,
    this.saved = false,
  });

  final List<AppSetting> items;
  final bool saving;
  final bool saved;

  SettingsCategoryLoaded copyWith({
    List<AppSetting>? items,
    bool? saving,
    bool? saved,
  }) {
    return SettingsCategoryLoaded(
      items: items ?? this.items,
      saving: saving ?? this.saving,
      saved: saved ?? false,
    );
  }

  @override
  List<Object?> get props => [items, saving, saved];
}

final class SettingsCategoryFailure extends SettingsCategoryState {
  const SettingsCategoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class SettingsCategoryCubit extends Cubit<SettingsCategoryState> {
  SettingsCategoryCubit(this._getSettings, this._updateSettings)
    : super(const SettingsCategoryLoading());

  final GetSettingsUseCase _getSettings;
  final UpdateSettingsUseCase _updateSettings;

  SettingCategory? _category;

  Future<void> load(SettingCategory category) async {
    _category = category;
    emit(const SettingsCategoryLoading());
    final result = await _getSettings(GetSettingsParams(category: category));
    result.fold(
      (failure) => emit(SettingsCategoryFailure(_message(failure))),
      (items) => emit(SettingsCategoryLoaded(items: items)),
    );
  }

  void editValue(String key, String value) {
    final current = state;
    if (current is! SettingsCategoryLoaded) return;
    emit(
      current.copyWith(
        items: [
          for (final item in current.items)
            if (item.key == key) item.copyWith(value: value) else item,
        ],
      ),
    );
  }

  void addSetting(String key, String value) {
    final current = state;
    final category = _category;
    if (current is! SettingsCategoryLoaded || category == null) return;
    if (key.trim().isEmpty) return;
    if (current.items.any((item) => item.key == key)) return;
    emit(
      current.copyWith(
        items: [
          ...current.items,
          AppSetting(key: key.trim(), value: value, category: category),
        ],
      ),
    );
  }

  void removeSetting(String key) {
    final current = state;
    if (current is! SettingsCategoryLoaded) return;
    emit(
      current.copyWith(
        items: current.items.where((item) => item.key != key).toList(),
      ),
    );
  }

  Future<void> save() async {
    final current = state;
    if (current is! SettingsCategoryLoaded) return;
    emit(current.copyWith(saving: true));
    final result = await _updateSettings(current.items);
    result.fold(
      (failure) => emit(SettingsCategoryFailure(_message(failure))),
      (items) => emit(
        SettingsCategoryLoaded(items: items, saving: false, saved: true),
      ),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
