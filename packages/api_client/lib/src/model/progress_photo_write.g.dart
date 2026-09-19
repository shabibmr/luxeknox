// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProgressPhotoWritePoseEnum _$progressPhotoWritePoseEnum_front =
    const ProgressPhotoWritePoseEnum._('front');
const ProgressPhotoWritePoseEnum _$progressPhotoWritePoseEnum_side =
    const ProgressPhotoWritePoseEnum._('side');
const ProgressPhotoWritePoseEnum _$progressPhotoWritePoseEnum_back =
    const ProgressPhotoWritePoseEnum._('back');

ProgressPhotoWritePoseEnum _$progressPhotoWritePoseEnumValueOf(String name) {
  switch (name) {
    case 'front':
      return _$progressPhotoWritePoseEnum_front;
    case 'side':
      return _$progressPhotoWritePoseEnum_side;
    case 'back':
      return _$progressPhotoWritePoseEnum_back;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProgressPhotoWritePoseEnum> _$progressPhotoWritePoseEnumValues =
    BuiltSet<ProgressPhotoWritePoseEnum>(const <ProgressPhotoWritePoseEnum>[
  _$progressPhotoWritePoseEnum_front,
  _$progressPhotoWritePoseEnum_side,
  _$progressPhotoWritePoseEnum_back,
]);

Serializer<ProgressPhotoWritePoseEnum> _$progressPhotoWritePoseEnumSerializer =
    _$ProgressPhotoWritePoseEnumSerializer();

class _$ProgressPhotoWritePoseEnumSerializer
    implements PrimitiveSerializer<ProgressPhotoWritePoseEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'front': 'front',
    'side': 'side',
    'back': 'back',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'front': 'front',
    'side': 'side',
    'back': 'back',
  };

  @override
  final Iterable<Type> types = const <Type>[ProgressPhotoWritePoseEnum];
  @override
  final String wireName = 'ProgressPhotoWritePoseEnum';

  @override
  Object serialize(Serializers serializers, ProgressPhotoWritePoseEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProgressPhotoWritePoseEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProgressPhotoWritePoseEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProgressPhotoWrite extends ProgressPhotoWrite {
  @override
  final String photoUrl;
  @override
  final ProgressPhotoWritePoseEnum pose;
  @override
  final Date? takenDate;
  @override
  final bool? isPrivate;

  factory _$ProgressPhotoWrite(
          [void Function(ProgressPhotoWriteBuilder)? updates]) =>
      (ProgressPhotoWriteBuilder()..update(updates))._build();

  _$ProgressPhotoWrite._(
      {required this.photoUrl,
      required this.pose,
      this.takenDate,
      this.isPrivate})
      : super._();
  @override
  ProgressPhotoWrite rebuild(
          void Function(ProgressPhotoWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressPhotoWriteBuilder toBuilder() =>
      ProgressPhotoWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressPhotoWrite &&
        photoUrl == other.photoUrl &&
        pose == other.pose &&
        takenDate == other.takenDate &&
        isPrivate == other.isPrivate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jc(_$hash, pose.hashCode);
    _$hash = $jc(_$hash, takenDate.hashCode);
    _$hash = $jc(_$hash, isPrivate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressPhotoWrite')
          ..add('photoUrl', photoUrl)
          ..add('pose', pose)
          ..add('takenDate', takenDate)
          ..add('isPrivate', isPrivate))
        .toString();
  }
}

class ProgressPhotoWriteBuilder
    implements Builder<ProgressPhotoWrite, ProgressPhotoWriteBuilder> {
  _$ProgressPhotoWrite? _$v;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  ProgressPhotoWritePoseEnum? _pose;
  ProgressPhotoWritePoseEnum? get pose => _$this._pose;
  set pose(ProgressPhotoWritePoseEnum? pose) => _$this._pose = pose;

  Date? _takenDate;
  Date? get takenDate => _$this._takenDate;
  set takenDate(Date? takenDate) => _$this._takenDate = takenDate;

  bool? _isPrivate;
  bool? get isPrivate => _$this._isPrivate;
  set isPrivate(bool? isPrivate) => _$this._isPrivate = isPrivate;

  ProgressPhotoWriteBuilder() {
    ProgressPhotoWrite._defaults(this);
  }

  ProgressPhotoWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _photoUrl = $v.photoUrl;
      _pose = $v.pose;
      _takenDate = $v.takenDate;
      _isPrivate = $v.isPrivate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressPhotoWrite other) {
    _$v = other as _$ProgressPhotoWrite;
  }

  @override
  void update(void Function(ProgressPhotoWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressPhotoWrite build() => _build();

  _$ProgressPhotoWrite _build() {
    final _$result = _$v ??
        _$ProgressPhotoWrite._(
          photoUrl: BuiltValueNullFieldError.checkNotNull(
              photoUrl, r'ProgressPhotoWrite', 'photoUrl'),
          pose: BuiltValueNullFieldError.checkNotNull(
              pose, r'ProgressPhotoWrite', 'pose'),
          takenDate: takenDate,
          isPrivate: isPrivate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
