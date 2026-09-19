// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_write_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsWriteItemsInner extends SettingsWriteItemsInner {
  @override
  final String settingKey;
  @override
  final String settingValue;

  factory _$SettingsWriteItemsInner(
          [void Function(SettingsWriteItemsInnerBuilder)? updates]) =>
      (SettingsWriteItemsInnerBuilder()..update(updates))._build();

  _$SettingsWriteItemsInner._(
      {required this.settingKey, required this.settingValue})
      : super._();
  @override
  SettingsWriteItemsInner rebuild(
          void Function(SettingsWriteItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsWriteItemsInnerBuilder toBuilder() =>
      SettingsWriteItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsWriteItemsInner &&
        settingKey == other.settingKey &&
        settingValue == other.settingValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, settingKey.hashCode);
    _$hash = $jc(_$hash, settingValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsWriteItemsInner')
          ..add('settingKey', settingKey)
          ..add('settingValue', settingValue))
        .toString();
  }
}

class SettingsWriteItemsInnerBuilder
    implements
        Builder<SettingsWriteItemsInner, SettingsWriteItemsInnerBuilder> {
  _$SettingsWriteItemsInner? _$v;

  String? _settingKey;
  String? get settingKey => _$this._settingKey;
  set settingKey(String? settingKey) => _$this._settingKey = settingKey;

  String? _settingValue;
  String? get settingValue => _$this._settingValue;
  set settingValue(String? settingValue) => _$this._settingValue = settingValue;

  SettingsWriteItemsInnerBuilder() {
    SettingsWriteItemsInner._defaults(this);
  }

  SettingsWriteItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _settingKey = $v.settingKey;
      _settingValue = $v.settingValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsWriteItemsInner other) {
    _$v = other as _$SettingsWriteItemsInner;
  }

  @override
  void update(void Function(SettingsWriteItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsWriteItemsInner build() => _build();

  _$SettingsWriteItemsInner _build() {
    final _$result = _$v ??
        _$SettingsWriteItemsInner._(
          settingKey: BuiltValueNullFieldError.checkNotNull(
              settingKey, r'SettingsWriteItemsInner', 'settingKey'),
          settingValue: BuiltValueNullFieldError.checkNotNull(
              settingValue, r'SettingsWriteItemsInner', 'settingValue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
