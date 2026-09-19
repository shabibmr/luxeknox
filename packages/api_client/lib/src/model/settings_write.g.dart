// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsWrite extends SettingsWrite {
  @override
  final BuiltList<SettingsWriteItemsInner> items;

  factory _$SettingsWrite([void Function(SettingsWriteBuilder)? updates]) =>
      (SettingsWriteBuilder()..update(updates))._build();

  _$SettingsWrite._({required this.items}) : super._();
  @override
  SettingsWrite rebuild(void Function(SettingsWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsWriteBuilder toBuilder() => SettingsWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsWrite && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsWrite')..add('items', items))
        .toString();
  }
}

class SettingsWriteBuilder
    implements Builder<SettingsWrite, SettingsWriteBuilder> {
  _$SettingsWrite? _$v;

  ListBuilder<SettingsWriteItemsInner>? _items;
  ListBuilder<SettingsWriteItemsInner> get items =>
      _$this._items ??= ListBuilder<SettingsWriteItemsInner>();
  set items(ListBuilder<SettingsWriteItemsInner>? items) =>
      _$this._items = items;

  SettingsWriteBuilder() {
    SettingsWrite._defaults(this);
  }

  SettingsWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsWrite other) {
    _$v = other as _$SettingsWrite;
  }

  @override
  void update(void Function(SettingsWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsWrite build() => _build();

  _$SettingsWrite _build() {
    _$SettingsWrite _$result;
    try {
      _$result = _$v ??
          _$SettingsWrite._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SettingsWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
