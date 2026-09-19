// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_photo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberPhoto extends MemberPhoto {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final String photoUrl;
  @override
  final bool? isCurrentAvatar;
  @override
  final DateTime? capturedAt;

  factory _$MemberPhoto([void Function(MemberPhotoBuilder)? updates]) =>
      (MemberPhotoBuilder()..update(updates))._build();

  _$MemberPhoto._(
      {required this.id,
      required this.memberId,
      required this.photoUrl,
      this.isCurrentAvatar,
      this.capturedAt})
      : super._();
  @override
  MemberPhoto rebuild(void Function(MemberPhotoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberPhotoBuilder toBuilder() => MemberPhotoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberPhoto &&
        id == other.id &&
        memberId == other.memberId &&
        photoUrl == other.photoUrl &&
        isCurrentAvatar == other.isCurrentAvatar &&
        capturedAt == other.capturedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jc(_$hash, isCurrentAvatar.hashCode);
    _$hash = $jc(_$hash, capturedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberPhoto')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('photoUrl', photoUrl)
          ..add('isCurrentAvatar', isCurrentAvatar)
          ..add('capturedAt', capturedAt))
        .toString();
  }
}

class MemberPhotoBuilder implements Builder<MemberPhoto, MemberPhotoBuilder> {
  _$MemberPhoto? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  bool? _isCurrentAvatar;
  bool? get isCurrentAvatar => _$this._isCurrentAvatar;
  set isCurrentAvatar(bool? isCurrentAvatar) =>
      _$this._isCurrentAvatar = isCurrentAvatar;

  DateTime? _capturedAt;
  DateTime? get capturedAt => _$this._capturedAt;
  set capturedAt(DateTime? capturedAt) => _$this._capturedAt = capturedAt;

  MemberPhotoBuilder() {
    MemberPhoto._defaults(this);
  }

  MemberPhotoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _photoUrl = $v.photoUrl;
      _isCurrentAvatar = $v.isCurrentAvatar;
      _capturedAt = $v.capturedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberPhoto other) {
    _$v = other as _$MemberPhoto;
  }

  @override
  void update(void Function(MemberPhotoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberPhoto build() => _build();

  _$MemberPhoto _build() {
    final _$result = _$v ??
        _$MemberPhoto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MemberPhoto', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'MemberPhoto', 'memberId'),
          photoUrl: BuiltValueNullFieldError.checkNotNull(
              photoUrl, r'MemberPhoto', 'photoUrl'),
          isCurrentAvatar: isCurrentAvatar,
          capturedAt: capturedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
