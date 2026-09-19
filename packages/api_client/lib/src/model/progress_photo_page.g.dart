// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressPhotoPage extends ProgressPhotoPage {
  @override
  final BuiltList<ProgressPhoto> data;
  @override
  final PageMeta meta;

  factory _$ProgressPhotoPage(
          [void Function(ProgressPhotoPageBuilder)? updates]) =>
      (ProgressPhotoPageBuilder()..update(updates))._build();

  _$ProgressPhotoPage._({required this.data, required this.meta}) : super._();
  @override
  ProgressPhotoPage rebuild(void Function(ProgressPhotoPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressPhotoPageBuilder toBuilder() =>
      ProgressPhotoPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressPhotoPage &&
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
    return (newBuiltValueToStringHelper(r'ProgressPhotoPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ProgressPhotoPageBuilder
    implements Builder<ProgressPhotoPage, ProgressPhotoPageBuilder> {
  _$ProgressPhotoPage? _$v;

  ListBuilder<ProgressPhoto>? _data;
  ListBuilder<ProgressPhoto> get data =>
      _$this._data ??= ListBuilder<ProgressPhoto>();
  set data(ListBuilder<ProgressPhoto>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ProgressPhotoPageBuilder() {
    ProgressPhotoPage._defaults(this);
  }

  ProgressPhotoPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressPhotoPage other) {
    _$v = other as _$ProgressPhotoPage;
  }

  @override
  void update(void Function(ProgressPhotoPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressPhotoPage build() => _build();

  _$ProgressPhotoPage _build() {
    _$ProgressPhotoPage _$result;
    try {
      _$result = _$v ??
          _$ProgressPhotoPage._(
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
            r'ProgressPhotoPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
