// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Setting extends Setting {
  @override
  final int? id;
  @override
  final String settingKey;
  @override
  final String settingValue;
  @override
  final SettingCategory category;

  factory _$Setting([void Function(SettingBuilder)? updates]) =>
      (SettingBuilder()..update(updates))._build();

  _$Setting._(
      {this.id,
      required this.settingKey,
      required this.settingValue,
      required this.category})
      : super._();
  @override
  Setting rebuild(void Function(SettingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingBuilder toBuilder() => SettingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Setting &&
        id == other.id &&
        settingKey == other.settingKey &&
        settingValue == other.settingValue &&
        category == other.category;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, settingKey.hashCode);
    _$hash = $jc(_$hash, settingValue.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Setting')
          ..add('id', id)
          ..add('settingKey', settingKey)
          ..add('settingValue', settingValue)
          ..add('category', category))
        .toString();
  }
}

class SettingBuilder implements Builder<Setting, SettingBuilder> {
  _$Setting? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _settingKey;
  String? get settingKey => _$this._settingKey;
  set settingKey(String? settingKey) => _$this._settingKey = settingKey;

  String? _settingValue;
  String? get settingValue => _$this._settingValue;
  set settingValue(String? settingValue) => _$this._settingValue = settingValue;

  SettingCategory? _category;
  SettingCategory? get category => _$this._category;
  set category(SettingCategory? category) => _$this._category = category;

  SettingBuilder() {
    Setting._defaults(this);
  }

  SettingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _settingKey = $v.settingKey;
      _settingValue = $v.settingValue;
      _category = $v.category;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Setting other) {
    _$v = other as _$Setting;
  }

  @override
  void update(void Function(SettingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Setting build() => _build();

  _$Setting _build() {
    final _$result = _$v ??
        _$Setting._(
          id: id,
          settingKey: BuiltValueNullFieldError.checkNotNull(
              settingKey, r'Setting', 'settingKey'),
          settingValue: BuiltValueNullFieldError.checkNotNull(
              settingValue, r'Setting', 'settingValue'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'Setting', 'category'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
