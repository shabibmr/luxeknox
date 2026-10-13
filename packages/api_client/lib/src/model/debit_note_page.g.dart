// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_note_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DebitNotePage extends DebitNotePage {
  @override
  final BuiltList<DebitNote> data;
  @override
  final PageMeta meta;

  factory _$DebitNotePage([void Function(DebitNotePageBuilder)? updates]) =>
      (DebitNotePageBuilder()..update(updates))._build();

  _$DebitNotePage._({required this.data, required this.meta}) : super._();
  @override
  DebitNotePage rebuild(void Function(DebitNotePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DebitNotePageBuilder toBuilder() => DebitNotePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DebitNotePage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'DebitNotePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class DebitNotePageBuilder
    implements Builder<DebitNotePage, DebitNotePageBuilder> {
  _$DebitNotePage? _$v;

  ListBuilder<DebitNote>? _data;
  ListBuilder<DebitNote> get data => _$this._data ??= ListBuilder<DebitNote>();
  set data(ListBuilder<DebitNote>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  DebitNotePageBuilder() {
    DebitNotePage._defaults(this);
  }

  DebitNotePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DebitNotePage other) {
    _$v = other as _$DebitNotePage;
  }

  @override
  void update(void Function(DebitNotePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DebitNotePage build() => _build();

  _$DebitNotePage _build() {
    _$DebitNotePage _$result;
    try {
      _$result = _$v ??
          _$DebitNotePage._(
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
            r'DebitNotePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
