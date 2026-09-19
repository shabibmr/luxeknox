// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_note_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressNotePage extends ProgressNotePage {
  @override
  final BuiltList<ProgressNote> data;
  @override
  final PageMeta meta;

  factory _$ProgressNotePage(
          [void Function(ProgressNotePageBuilder)? updates]) =>
      (ProgressNotePageBuilder()..update(updates))._build();

  _$ProgressNotePage._({required this.data, required this.meta}) : super._();
  @override
  ProgressNotePage rebuild(void Function(ProgressNotePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressNotePageBuilder toBuilder() =>
      ProgressNotePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressNotePage &&
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
    return (newBuiltValueToStringHelper(r'ProgressNotePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ProgressNotePageBuilder
    implements Builder<ProgressNotePage, ProgressNotePageBuilder> {
  _$ProgressNotePage? _$v;

  ListBuilder<ProgressNote>? _data;
  ListBuilder<ProgressNote> get data =>
      _$this._data ??= ListBuilder<ProgressNote>();
  set data(ListBuilder<ProgressNote>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ProgressNotePageBuilder() {
    ProgressNotePage._defaults(this);
  }

  ProgressNotePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressNotePage other) {
    _$v = other as _$ProgressNotePage;
  }

  @override
  void update(void Function(ProgressNotePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressNotePage build() => _build();

  _$ProgressNotePage _build() {
    _$ProgressNotePage _$result;
    try {
      _$result = _$v ??
          _$ProgressNotePage._(
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
            r'ProgressNotePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
