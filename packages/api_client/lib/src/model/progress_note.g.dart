// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_note.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProgressNoteNoteTypeEnum _$progressNoteNoteTypeEnum_memberNote =
    const ProgressNoteNoteTypeEnum._('memberNote');
const ProgressNoteNoteTypeEnum _$progressNoteNoteTypeEnum_trainerAssessment =
    const ProgressNoteNoteTypeEnum._('trainerAssessment');

ProgressNoteNoteTypeEnum _$progressNoteNoteTypeEnumValueOf(String name) {
  switch (name) {
    case 'memberNote':
      return _$progressNoteNoteTypeEnum_memberNote;
    case 'trainerAssessment':
      return _$progressNoteNoteTypeEnum_trainerAssessment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProgressNoteNoteTypeEnum> _$progressNoteNoteTypeEnumValues =
    BuiltSet<ProgressNoteNoteTypeEnum>(const <ProgressNoteNoteTypeEnum>[
  _$progressNoteNoteTypeEnum_memberNote,
  _$progressNoteNoteTypeEnum_trainerAssessment,
]);

Serializer<ProgressNoteNoteTypeEnum> _$progressNoteNoteTypeEnumSerializer =
    _$ProgressNoteNoteTypeEnumSerializer();

class _$ProgressNoteNoteTypeEnumSerializer
    implements PrimitiveSerializer<ProgressNoteNoteTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'memberNote': 'member_note',
    'trainerAssessment': 'trainer_assessment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'member_note': 'memberNote',
    'trainer_assessment': 'trainerAssessment',
  };

  @override
  final Iterable<Type> types = const <Type>[ProgressNoteNoteTypeEnum];
  @override
  final String wireName = 'ProgressNoteNoteTypeEnum';

  @override
  Object serialize(Serializers serializers, ProgressNoteNoteTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProgressNoteNoteTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProgressNoteNoteTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProgressNote extends ProgressNote {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int authorUserId;
  @override
  final String noteText;
  @override
  final ProgressNoteNoteTypeEnum noteType;
  @override
  final DateTime createdAt;

  factory _$ProgressNote([void Function(ProgressNoteBuilder)? updates]) =>
      (ProgressNoteBuilder()..update(updates))._build();

  _$ProgressNote._(
      {required this.id,
      required this.memberId,
      required this.authorUserId,
      required this.noteText,
      required this.noteType,
      required this.createdAt})
      : super._();
  @override
  ProgressNote rebuild(void Function(ProgressNoteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressNoteBuilder toBuilder() => ProgressNoteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressNote &&
        id == other.id &&
        memberId == other.memberId &&
        authorUserId == other.authorUserId &&
        noteText == other.noteText &&
        noteType == other.noteType &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, authorUserId.hashCode);
    _$hash = $jc(_$hash, noteText.hashCode);
    _$hash = $jc(_$hash, noteType.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressNote')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('authorUserId', authorUserId)
          ..add('noteText', noteText)
          ..add('noteType', noteType)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ProgressNoteBuilder
    implements Builder<ProgressNote, ProgressNoteBuilder> {
  _$ProgressNote? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _authorUserId;
  int? get authorUserId => _$this._authorUserId;
  set authorUserId(int? authorUserId) => _$this._authorUserId = authorUserId;

  String? _noteText;
  String? get noteText => _$this._noteText;
  set noteText(String? noteText) => _$this._noteText = noteText;

  ProgressNoteNoteTypeEnum? _noteType;
  ProgressNoteNoteTypeEnum? get noteType => _$this._noteType;
  set noteType(ProgressNoteNoteTypeEnum? noteType) =>
      _$this._noteType = noteType;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ProgressNoteBuilder() {
    ProgressNote._defaults(this);
  }

  ProgressNoteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _authorUserId = $v.authorUserId;
      _noteText = $v.noteText;
      _noteType = $v.noteType;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressNote other) {
    _$v = other as _$ProgressNote;
  }

  @override
  void update(void Function(ProgressNoteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressNote build() => _build();

  _$ProgressNote _build() {
    final _$result = _$v ??
        _$ProgressNote._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProgressNote', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'ProgressNote', 'memberId'),
          authorUserId: BuiltValueNullFieldError.checkNotNull(
              authorUserId, r'ProgressNote', 'authorUserId'),
          noteText: BuiltValueNullFieldError.checkNotNull(
              noteText, r'ProgressNote', 'noteText'),
          noteType: BuiltValueNullFieldError.checkNotNull(
              noteType, r'ProgressNote', 'noteType'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ProgressNote', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
