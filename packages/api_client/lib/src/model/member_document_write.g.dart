// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_document_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MemberDocumentWriteDocumentTypeEnum
    _$memberDocumentWriteDocumentTypeEnum_idProof =
    const MemberDocumentWriteDocumentTypeEnum._('idProof');
const MemberDocumentWriteDocumentTypeEnum
    _$memberDocumentWriteDocumentTypeEnum_waiver =
    const MemberDocumentWriteDocumentTypeEnum._('waiver');
const MemberDocumentWriteDocumentTypeEnum
    _$memberDocumentWriteDocumentTypeEnum_medicalCert =
    const MemberDocumentWriteDocumentTypeEnum._('medicalCert');

MemberDocumentWriteDocumentTypeEnum
    _$memberDocumentWriteDocumentTypeEnumValueOf(String name) {
  switch (name) {
    case 'idProof':
      return _$memberDocumentWriteDocumentTypeEnum_idProof;
    case 'waiver':
      return _$memberDocumentWriteDocumentTypeEnum_waiver;
    case 'medicalCert':
      return _$memberDocumentWriteDocumentTypeEnum_medicalCert;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MemberDocumentWriteDocumentTypeEnum>
    _$memberDocumentWriteDocumentTypeEnumValues = BuiltSet<
        MemberDocumentWriteDocumentTypeEnum>(const <MemberDocumentWriteDocumentTypeEnum>[
  _$memberDocumentWriteDocumentTypeEnum_idProof,
  _$memberDocumentWriteDocumentTypeEnum_waiver,
  _$memberDocumentWriteDocumentTypeEnum_medicalCert,
]);

Serializer<MemberDocumentWriteDocumentTypeEnum>
    _$memberDocumentWriteDocumentTypeEnumSerializer =
    _$MemberDocumentWriteDocumentTypeEnumSerializer();

class _$MemberDocumentWriteDocumentTypeEnumSerializer
    implements PrimitiveSerializer<MemberDocumentWriteDocumentTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    MemberDocumentWriteDocumentTypeEnum
  ];
  @override
  final String wireName = 'MemberDocumentWriteDocumentTypeEnum';

  @override
  Object serialize(
          Serializers serializers, MemberDocumentWriteDocumentTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MemberDocumentWriteDocumentTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MemberDocumentWriteDocumentTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MemberDocumentWrite extends MemberDocumentWrite {
  @override
  final MemberDocumentWriteDocumentTypeEnum documentType;
  @override
  final String? title;
  @override
  final String fileUrl;
  @override
  final int? fileSize;

  factory _$MemberDocumentWrite(
          [void Function(MemberDocumentWriteBuilder)? updates]) =>
      (MemberDocumentWriteBuilder()..update(updates))._build();

  _$MemberDocumentWrite._(
      {required this.documentType,
      this.title,
      required this.fileUrl,
      this.fileSize})
      : super._();
  @override
  MemberDocumentWrite rebuild(
          void Function(MemberDocumentWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberDocumentWriteBuilder toBuilder() =>
      MemberDocumentWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberDocumentWrite &&
        documentType == other.documentType &&
        title == other.title &&
        fileUrl == other.fileUrl &&
        fileSize == other.fileSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documentType.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberDocumentWrite')
          ..add('documentType', documentType)
          ..add('title', title)
          ..add('fileUrl', fileUrl)
          ..add('fileSize', fileSize))
        .toString();
  }
}

class MemberDocumentWriteBuilder
    implements Builder<MemberDocumentWrite, MemberDocumentWriteBuilder> {
  _$MemberDocumentWrite? _$v;

  MemberDocumentWriteDocumentTypeEnum? _documentType;
  MemberDocumentWriteDocumentTypeEnum? get documentType => _$this._documentType;
  set documentType(MemberDocumentWriteDocumentTypeEnum? documentType) =>
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

  MemberDocumentWriteBuilder() {
    MemberDocumentWrite._defaults(this);
  }

  MemberDocumentWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documentType = $v.documentType;
      _title = $v.title;
      _fileUrl = $v.fileUrl;
      _fileSize = $v.fileSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberDocumentWrite other) {
    _$v = other as _$MemberDocumentWrite;
  }

  @override
  void update(void Function(MemberDocumentWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberDocumentWrite build() => _build();

  _$MemberDocumentWrite _build() {
    final _$result = _$v ??
        _$MemberDocumentWrite._(
          documentType: BuiltValueNullFieldError.checkNotNull(
              documentType, r'MemberDocumentWrite', 'documentType'),
          title: title,
          fileUrl: BuiltValueNullFieldError.checkNotNull(
              fileUrl, r'MemberDocumentWrite', 'fileUrl'),
          fileSize: fileSize,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
