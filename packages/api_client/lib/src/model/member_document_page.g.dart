// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_document_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberDocumentPage extends MemberDocumentPage {
  @override
  final BuiltList<MemberDocument> data;
  @override
  final PageMeta meta;

  factory _$MemberDocumentPage(
          [void Function(MemberDocumentPageBuilder)? updates]) =>
      (MemberDocumentPageBuilder()..update(updates))._build();

  _$MemberDocumentPage._({required this.data, required this.meta}) : super._();
  @override
  MemberDocumentPage rebuild(
          void Function(MemberDocumentPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberDocumentPageBuilder toBuilder() =>
      MemberDocumentPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberDocumentPage &&
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
    return (newBuiltValueToStringHelper(r'MemberDocumentPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MemberDocumentPageBuilder
    implements Builder<MemberDocumentPage, MemberDocumentPageBuilder> {
  _$MemberDocumentPage? _$v;

  ListBuilder<MemberDocument>? _data;
  ListBuilder<MemberDocument> get data =>
      _$this._data ??= ListBuilder<MemberDocument>();
  set data(ListBuilder<MemberDocument>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MemberDocumentPageBuilder() {
    MemberDocumentPage._defaults(this);
  }

  MemberDocumentPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberDocumentPage other) {
    _$v = other as _$MemberDocumentPage;
  }

  @override
  void update(void Function(MemberDocumentPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberDocumentPage build() => _build();

  _$MemberDocumentPage _build() {
    _$MemberDocumentPage _$result;
    try {
      _$result = _$v ??
          _$MemberDocumentPage._(
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
            r'MemberDocumentPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
