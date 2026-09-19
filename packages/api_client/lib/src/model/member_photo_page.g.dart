// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_photo_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberPhotoPage extends MemberPhotoPage {
  @override
  final BuiltList<MemberPhoto> data;
  @override
  final PageMeta meta;

  factory _$MemberPhotoPage([void Function(MemberPhotoPageBuilder)? updates]) =>
      (MemberPhotoPageBuilder()..update(updates))._build();

  _$MemberPhotoPage._({required this.data, required this.meta}) : super._();
  @override
  MemberPhotoPage rebuild(void Function(MemberPhotoPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberPhotoPageBuilder toBuilder() => MemberPhotoPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberPhotoPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'MemberPhotoPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MemberPhotoPageBuilder
    implements Builder<MemberPhotoPage, MemberPhotoPageBuilder> {
  _$MemberPhotoPage? _$v;

  ListBuilder<MemberPhoto>? _data;
  ListBuilder<MemberPhoto> get data =>
      _$this._data ??= ListBuilder<MemberPhoto>();
  set data(ListBuilder<MemberPhoto>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MemberPhotoPageBuilder() {
    MemberPhotoPage._defaults(this);
  }

  MemberPhotoPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberPhotoPage other) {
    _$v = other as _$MemberPhotoPage;
  }

  @override
  void update(void Function(MemberPhotoPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberPhotoPage build() => _build();

  _$MemberPhotoPage _build() {
    _$MemberPhotoPage _$result;
    try {
      _$result = _$v ??
          _$MemberPhotoPage._(
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
            r'MemberPhotoPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
