// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_photo_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberPhotoWrite extends MemberPhotoWrite {
  @override
  final String photoUrl;

  factory _$MemberPhotoWrite(
          [void Function(MemberPhotoWriteBuilder)? updates]) =>
      (MemberPhotoWriteBuilder()..update(updates))._build();

  _$MemberPhotoWrite._({required this.photoUrl}) : super._();
  @override
  MemberPhotoWrite rebuild(void Function(MemberPhotoWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberPhotoWriteBuilder toBuilder() =>
      MemberPhotoWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberPhotoWrite && photoUrl == other.photoUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberPhotoWrite')
          ..add('photoUrl', photoUrl))
        .toString();
  }
}

class MemberPhotoWriteBuilder
    implements Builder<MemberPhotoWrite, MemberPhotoWriteBuilder> {
  _$MemberPhotoWrite? _$v;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  MemberPhotoWriteBuilder() {
    MemberPhotoWrite._defaults(this);
  }

  MemberPhotoWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _photoUrl = $v.photoUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberPhotoWrite other) {
    _$v = other as _$MemberPhotoWrite;
  }

  @override
  void update(void Function(MemberPhotoWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberPhotoWrite build() => _build();

  _$MemberPhotoWrite _build() {
    final _$result = _$v ??
        _$MemberPhotoWrite._(
          photoUrl: BuiltValueNullFieldError.checkNotNull(
              photoUrl, r'MemberPhotoWrite', 'photoUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
