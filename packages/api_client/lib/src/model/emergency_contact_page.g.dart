// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmergencyContactPage extends EmergencyContactPage {
  @override
  final BuiltList<EmergencyContact> data;
  @override
  final PageMeta meta;

  factory _$EmergencyContactPage(
          [void Function(EmergencyContactPageBuilder)? updates]) =>
      (EmergencyContactPageBuilder()..update(updates))._build();

  _$EmergencyContactPage._({required this.data, required this.meta})
      : super._();
  @override
  EmergencyContactPage rebuild(
          void Function(EmergencyContactPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmergencyContactPageBuilder toBuilder() =>
      EmergencyContactPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmergencyContactPage &&
        data == other.data &&
        meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmergencyContactPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class EmergencyContactPageBuilder
    implements Builder<EmergencyContactPage, EmergencyContactPageBuilder> {
  _$EmergencyContactPage? _$v;

  ListBuilder<EmergencyContact>? _data;
  ListBuilder<EmergencyContact> get data =>
      _$this._data ??= ListBuilder<EmergencyContact>();
  set data(ListBuilder<EmergencyContact>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  EmergencyContactPageBuilder() {
    EmergencyContactPage._defaults(this);
  }

  EmergencyContactPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmergencyContactPage other) {
    _$v = other as _$EmergencyContactPage;
  }

  @override
  void update(void Function(EmergencyContactPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmergencyContactPage build() => _build();

  _$EmergencyContactPage _build() {
    _$EmergencyContactPage _$result;
    try {
      _$result = _$v ??
          _$EmergencyContactPage._(
            data: data.build(),
            meta: meta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EmergencyContactPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
