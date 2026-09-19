// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_document.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MemberDocumentDocumentTypeEnum _$memberDocumentDocumentTypeEnum_idProof =
    const MemberDocumentDocumentTypeEnum._('idProof');
const MemberDocumentDocumentTypeEnum _$memberDocumentDocumentTypeEnum_waiver =
    const MemberDocumentDocumentTypeEnum._('waiver');
const MemberDocumentDocumentTypeEnum
    _$memberDocumentDocumentTypeEnum_medicalCert =
    const MemberDocumentDocumentTypeEnum._('medicalCert');

MemberDocumentDocumentTypeEnum _$memberDocumentDocumentTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'idProof':
      return _$memberDocumentDocumentTypeEnum_idProof;
    case 'waiver':
      return _$memberDocumentDocumentTypeEnum_waiver;
    case 'medicalCert':
      return _$memberDocumentDocumentTypeEnum_medicalCert;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MemberDocumentDocumentTypeEnum>
    _$memberDocumentDocumentTypeEnumValues = BuiltSet<
        MemberDocumentDocumentTypeEnum>(const <MemberDocumentDocumentTypeEnum>[
  _$memberDocumentDocumentTypeEnum_idProof,
  _$memberDocumentDocumentTypeEnum_waiver,
  _$memberDocumentDocumentTypeEnum_medicalCert,
]);

Serializer<MemberDocumentDocumentTypeEnum>
    _$memberDocumentDocumentTypeEnumSerializer =
    _$MemberDocumentDocumentTypeEnumSerializer();

class _$MemberDocumentDocumentTypeEnumSerializer
    implements PrimitiveSerializer<MemberDocumentDocumentTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'idProof': 'id_proof',
    'waiver': 'waiver',
    'medicalCert': 'medical_cert',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'id_proof': 'idProof',
    'waiver': 'waiver',
    'medical_cert': 'medicalCert',
  };

  @override
  final Iterable<Type> types = const <Type>[MemberDocumentDocumentTypeEnum];
  @override
  final String wireName = 'MemberDocumentDocumentTypeEnum';

  @override
  Object serialize(
          Serializers serializers, MemberDocumentDocumentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MemberDocumentDocumentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MemberDocumentDocumentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MemberDocument extends MemberDocument {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final MemberDocumentDocumentTypeEnum documentType;
  @override
  final String? title;
  @override
  final String? fileUrl;
  @override
  final int? fileSize;
  @override
  final int? verifiedByUserId;
  @override
  final DateTime? verifiedAt;

  factory _$MemberDocument([void Function(MemberDocumentBuilder)? updates]) =>
      (MemberDocumentBuilder()..update(updates))._build();

  _$MemberDocument._(
      {required this.id,
      required this.memberId,
      required this.documentType,
      this.title,
      this.fileUrl,
      this.fileSize,
      this.verifiedByUserId,
      this.verifiedAt})
      : super._();
  @override
  MemberDocument rebuild(void Function(MemberDocumentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberDocumentBuilder toBuilder() => MemberDocumentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberDocument &&
        id == other.id &&
        memberId == other.memberId &&
        documentType == other.documentType &&
        title == other.title &&
        fileUrl == other.fileUrl &&
        fileSize == other.fileSize &&
        verifiedByUserId == other.verifiedByUserId &&
        verifiedAt == other.verifiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, documentType.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jc(_$hash, verifiedByUserId.hashCode);
    _$hash = $jc(_$hash, verifiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberDocument')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('documentType', documentType)
          ..add('title', title)
          ..add('fileUrl', fileUrl)
          ..add('fileSize', fileSize)
          ..add('verifiedByUserId', verifiedByUserId)
          ..add('verifiedAt', verifiedAt))
        .toString();
  }
}

class MemberDocumentBuilder
    implements Builder<MemberDocument, MemberDocumentBuilder> {
  _$MemberDocument? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  MemberDocumentDocumentTypeEnum? _documentType;
  MemberDocumentDocumentTypeEnum? get documentType => _$this._documentType;
  set documentType(MemberDocumentDocumentTypeEnum? documentType) =>
      _$this._documentType = documentType;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  int? _fileSize;
  int? get fileSize => _$this._fileSize;
  set fileSize(int? fileSize) => _$this._fileSize = fileSize;

  int? _verifiedByUserId;
  int? get verifiedByUserId => _$this._verifiedByUserId;
  set verifiedByUserId(int? verifiedByUserId) =>
      _$this._verifiedByUserId = verifiedByUserId;

  DateTime? _verifiedAt;
  DateTime? get verifiedAt => _$this._verifiedAt;
  set verifiedAt(DateTime? verifiedAt) => _$this._verifiedAt = verifiedAt;

  MemberDocumentBuilder() {
    MemberDocument._defaults(this);
  }

  MemberDocumentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _documentType = $v.documentType;
      _title = $v.title;
      _fileUrl = $v.fileUrl;
      _fileSize = $v.fileSize;
      _verifiedByUserId = $v.verifiedByUserId;
      _verifiedAt = $v.verifiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberDocument other) {
    _$v = other as _$MemberDocument;
  }

  @override
  void update(void Function(MemberDocumentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberDocument build() => _build();

  _$MemberDocument _build() {
    final _$result = _$v ??
        _$MemberDocument._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MemberDocument', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'MemberDocument', 'memberId'),
          documentType: BuiltValueNullFieldError.checkNotNull(
              documentType, r'MemberDocument', 'documentType'),
          title: title,
          fileUrl: fileUrl,
          fileSize: fileSize,
          verifiedByUserId: verifiedByUserId,
          verifiedAt: verifiedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
