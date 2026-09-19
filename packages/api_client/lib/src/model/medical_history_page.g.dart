// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_history_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MedicalHistoryPage extends MedicalHistoryPage {
  @override
  final BuiltList<MedicalHistory> data;
  @override
  final PageMeta meta;

  factory _$MedicalHistoryPage(
          [void Function(MedicalHistoryPageBuilder)? updates]) =>
      (MedicalHistoryPageBuilder()..update(updates))._build();

  _$MedicalHistoryPage._({required this.data, required this.meta}) : super._();
  @override
  MedicalHistoryPage rebuild(
          void Function(MedicalHistoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MedicalHistoryPageBuilder toBuilder() =>
      MedicalHistoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MedicalHistoryPage &&
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
    return (newBuiltValueToStringHelper(r'MedicalHistoryPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MedicalHistoryPageBuilder
    implements Builder<MedicalHistoryPage, MedicalHistoryPageBuilder> {
  _$MedicalHistoryPage? _$v;

  ListBuilder<MedicalHistory>? _data;
  ListBuilder<MedicalHistory> get data =>
      _$this._data ??= ListBuilder<MedicalHistory>();
  set data(ListBuilder<MedicalHistory>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MedicalHistoryPageBuilder() {
    MedicalHistoryPage._defaults(this);
  }

  MedicalHistoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MedicalHistoryPage other) {
    _$v = other as _$MedicalHistoryPage;
  }

  @override
  void update(void Function(MedicalHistoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MedicalHistoryPage build() => _build();

  _$MedicalHistoryPage _build() {
    _$MedicalHistoryPage _$result;
    try {
      _$result = _$v ??
          _$MedicalHistoryPage._(
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
            r'MedicalHistoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
