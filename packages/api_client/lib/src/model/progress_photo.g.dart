// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProgressPhotoPoseEnum _$progressPhotoPoseEnum_front =
    const ProgressPhotoPoseEnum._('front');
const ProgressPhotoPoseEnum _$progressPhotoPoseEnum_side =
    const ProgressPhotoPoseEnum._('side');
const ProgressPhotoPoseEnum _$progressPhotoPoseEnum_back =
    const ProgressPhotoPoseEnum._('back');

ProgressPhotoPoseEnum _$progressPhotoPoseEnumValueOf(String name) {
  switch (name) {
    case 'front':
      return _$progressPhotoPoseEnum_front;
    case 'side':
      return _$progressPhotoPoseEnum_side;
    case 'back':
      return _$progressPhotoPoseEnum_back;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProgressPhotoPoseEnum> _$progressPhotoPoseEnumValues =
    BuiltSet<ProgressPhotoPoseEnum>(const <ProgressPhotoPoseEnum>[
  _$progressPhotoPoseEnum_front,
  _$progressPhotoPoseEnum_side,
  _$progressPhotoPoseEnum_back,
]);

Serializer<ProgressPhotoPoseEnum> _$progressPhotoPoseEnumSerializer =
    _$ProgressPhotoPoseEnumSerializer();

class _$ProgressPhotoPoseEnumSerializer
    implements PrimitiveSerializer<ProgressPhotoPoseEnum> {
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
  final Iterable<Type> types = const <Type>[ProgressPhotoPoseEnum];
  @override
  final String wireName = 'ProgressPhotoPoseEnum';

  @override
  Object serialize(Serializers serializers, ProgressPhotoPoseEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProgressPhotoPoseEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProgressPhotoPoseEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProgressPhoto extends ProgressPhoto {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final String photoUrl;
  @override
  final ProgressPhotoPoseEnum pose;
  @override
  final Date? takenDate;
  @override
  final bool? isPrivate;

  factory _$ProgressPhoto([void Function(ProgressPhotoBuilder)? updates]) =>
      (ProgressPhotoBuilder()..update(updates))._build();

  _$ProgressPhoto._(
      {required this.id,
      required this.memberId,
      required this.photoUrl,
      required this.pose,
      this.takenDate,
      this.isPrivate})
      : super._();
  @override
  ProgressPhoto rebuild(void Function(ProgressPhotoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressPhotoBuilder toBuilder() => ProgressPhotoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressPhoto &&
        id == other.id &&
        memberId == other.memberId &&
        photoUrl == other.photoUrl &&
        pose == other.pose &&
        takenDate == other.takenDate &&
        isPrivate == other.isPrivate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, photoUrl.hashCode);
    _$hash = $jc(_$hash, pose.hashCode);
    _$hash = $jc(_$hash, takenDate.hashCode);
    _$hash = $jc(_$hash, isPrivate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressPhoto')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('photoUrl', photoUrl)
          ..add('pose', pose)
          ..add('takenDate', takenDate)
          ..add('isPrivate', isPrivate))
        .toString();
  }
}

class ProgressPhotoBuilder
    implements Builder<ProgressPhoto, ProgressPhotoBuilder> {
  _$ProgressPhoto? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  ProgressPhotoPoseEnum? _pose;
  ProgressPhotoPoseEnum? get pose => _$this._pose;
  set pose(ProgressPhotoPoseEnum? pose) => _$this._pose = pose;

  Date? _takenDate;
  Date? get takenDate => _$this._takenDate;
  set takenDate(Date? takenDate) => _$this._takenDate = takenDate;

  bool? _isPrivate;
  bool? get isPrivate => _$this._isPrivate;
  set isPrivate(bool? isPrivate) => _$this._isPrivate = isPrivate;

  ProgressPhotoBuilder() {
    ProgressPhoto._defaults(this);
  }

  ProgressPhotoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _photoUrl = $v.photoUrl;
      _pose = $v.pose;
      _takenDate = $v.takenDate;
      _isPrivate = $v.isPrivate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressPhoto other) {
    _$v = other as _$ProgressPhoto;
  }

  @override
  void update(void Function(ProgressPhotoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressPhoto build() => _build();

  _$ProgressPhoto _build() {
    final _$result = _$v ??
        _$ProgressPhoto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProgressPhoto', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'ProgressPhoto', 'memberId'),
          photoUrl: BuiltValueNullFieldError.checkNotNull(
              photoUrl, r'ProgressPhoto', 'photoUrl'),
          pose: BuiltValueNullFieldError.checkNotNull(
              pose, r'ProgressPhoto', 'pose'),
          takenDate: takenDate,
          isPrivate: isPrivate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
