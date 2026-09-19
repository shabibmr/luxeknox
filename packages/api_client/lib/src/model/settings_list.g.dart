// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsList extends SettingsList {
  @override
  final BuiltList<Setting> data;

  factory _$SettingsList([void Function(SettingsListBuilder)? updates]) =>
      (SettingsListBuilder()..update(updates))._build();

  _$SettingsList._({required this.data}) : super._();
  @override
  SettingsList rebuild(void Function(SettingsListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsListBuilder toBuilder() => SettingsListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsList && data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsList')..add('data', data))
        .toString();
  }
}

class SettingsListBuilder
    implements Builder<SettingsList, SettingsListBuilder> {
  _$SettingsList? _$v;

  ListBuilder<Setting>? _data;
  ListBuilder<Setting> get data => _$this._data ??= ListBuilder<Setting>();
  set data(ListBuilder<Setting>? data) => _$this._data = data;

  SettingsListBuilder() {
    SettingsList._defaults(this);
  }

  SettingsListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsList other) {
    _$v = other as _$SettingsList;
  }

  @override
  void update(void Function(SettingsListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsList build() => _build();

  _$SettingsList _build() {
    _$SettingsList _$result;
    try {
      _$result = _$v ??
          _$SettingsList._(
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SettingsList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
