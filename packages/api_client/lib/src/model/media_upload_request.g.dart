// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MediaUploadRequestPurposeEnum
    _$mediaUploadRequestPurposeEnum_exerciseMedia =
    const MediaUploadRequestPurposeEnum._('exerciseMedia');
const MediaUploadRequestPurposeEnum _$mediaUploadRequestPurposeEnum_avatar =
    const MediaUploadRequestPurposeEnum._('avatar');
const MediaUploadRequestPurposeEnum
    _$mediaUploadRequestPurposeEnum_progressPhoto =
    const MediaUploadRequestPurposeEnum._('progressPhoto');
const MediaUploadRequestPurposeEnum _$mediaUploadRequestPurposeEnum_idProof =
    const MediaUploadRequestPurposeEnum._('idProof');
const MediaUploadRequestPurposeEnum _$mediaUploadRequestPurposeEnum_waiver =
    const MediaUploadRequestPurposeEnum._('waiver');
const MediaUploadRequestPurposeEnum
    _$mediaUploadRequestPurposeEnum_medicalCert =
    const MediaUploadRequestPurposeEnum._('medicalCert');
const MediaUploadRequestPurposeEnum _$mediaUploadRequestPurposeEnum_receiptPdf =
    const MediaUploadRequestPurposeEnum._('receiptPdf');

MediaUploadRequestPurposeEnum _$mediaUploadRequestPurposeEnumValueOf(
    String name) {
  switch (name) {
    case 'exerciseMedia':
      return _$mediaUploadRequestPurposeEnum_exerciseMedia;
    case 'avatar':
      return _$mediaUploadRequestPurposeEnum_avatar;
    case 'progressPhoto':
      return _$mediaUploadRequestPurposeEnum_progressPhoto;
    case 'idProof':
      return _$mediaUploadRequestPurposeEnum_idProof;
    case 'waiver':
      return _$mediaUploadRequestPurposeEnum_waiver;
    case 'medicalCert':
      return _$mediaUploadRequestPurposeEnum_medicalCert;
    case 'receiptPdf':
      return _$mediaUploadRequestPurposeEnum_receiptPdf;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MediaUploadRequestPurposeEnum>
    _$mediaUploadRequestPurposeEnumValues = BuiltSet<
        MediaUploadRequestPurposeEnum>(const <MediaUploadRequestPurposeEnum>[
  _$mediaUploadRequestPurposeEnum_exerciseMedia,
  _$mediaUploadRequestPurposeEnum_avatar,
  _$mediaUploadRequestPurposeEnum_progressPhoto,
  _$mediaUploadRequestPurposeEnum_idProof,
  _$mediaUploadRequestPurposeEnum_waiver,
  _$mediaUploadRequestPurposeEnum_medicalCert,
  _$mediaUploadRequestPurposeEnum_receiptPdf,
]);

Serializer<MediaUploadRequestPurposeEnum>
    _$mediaUploadRequestPurposeEnumSerializer =
    _$MediaUploadRequestPurposeEnumSerializer();

class _$MediaUploadRequestPurposeEnumSerializer
    implements PrimitiveSerializer<MediaUploadRequestPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'exerciseMedia': 'exercise_media',
    'avatar': 'avatar',
    'progressPhoto': 'progress_photo',
    'idProof': 'id_proof',
    'waiver': 'waiver',
    'medicalCert': 'medical_cert',
    'receiptPdf': 'receipt_pdf',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'exercise_media': 'exerciseMedia',
    'avatar': 'avatar',
    'progress_photo': 'progressPhoto',
    'id_proof': 'idProof',
    'waiver': 'waiver',
    'medical_cert': 'medicalCert',
    'receipt_pdf': 'receiptPdf',
  };

  @override
  final Iterable<Type> types = const <Type>[MediaUploadRequestPurposeEnum];
  @override
  final String wireName = 'MediaUploadRequestPurposeEnum';

  @override
  Object serialize(
          Serializers serializers, MediaUploadRequestPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MediaUploadRequestPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MediaUploadRequestPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MediaUploadRequest extends MediaUploadRequest {
  @override
  final MediaUploadRequestPurposeEnum purpose;
  @override
  final String contentType;
  @override
  final int sizeBytes;

  factory _$MediaUploadRequest(
          [void Function(MediaUploadRequestBuilder)? updates]) =>
      (MediaUploadRequestBuilder()..update(updates))._build();

  _$MediaUploadRequest._(
      {required this.purpose,
      required this.contentType,
      required this.sizeBytes})
      : super._();
  @override
  MediaUploadRequest rebuild(
          void Function(MediaUploadRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaUploadRequestBuilder toBuilder() =>
      MediaUploadRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaUploadRequest &&
        purpose == other.purpose &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaUploadRequest')
          ..add('purpose', purpose)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class MediaUploadRequestBuilder
    implements Builder<MediaUploadRequest, MediaUploadRequestBuilder> {
  _$MediaUploadRequest? _$v;

  MediaUploadRequestPurposeEnum? _purpose;
  MediaUploadRequestPurposeEnum? get purpose => _$this._purpose;
  set purpose(MediaUploadRequestPurposeEnum? purpose) =>
      _$this._purpose = purpose;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  MediaUploadRequestBuilder() {
    MediaUploadRequest._defaults(this);
  }

  MediaUploadRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purpose = $v.purpose;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaUploadRequest other) {
    _$v = other as _$MediaUploadRequest;
  }

  @override
  void update(void Function(MediaUploadRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaUploadRequest build() => _build();

  _$MediaUploadRequest _build() {
    final _$result = _$v ??
        _$MediaUploadRequest._(
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'MediaUploadRequest', 'purpose'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'MediaUploadRequest', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'MediaUploadRequest', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
