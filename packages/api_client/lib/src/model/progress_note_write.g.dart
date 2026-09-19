// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_note_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProgressNoteWriteNoteTypeEnum _$progressNoteWriteNoteTypeEnum_memberNote =
    const ProgressNoteWriteNoteTypeEnum._('memberNote');
const ProgressNoteWriteNoteTypeEnum
    _$progressNoteWriteNoteTypeEnum_trainerAssessment =
    const ProgressNoteWriteNoteTypeEnum._('trainerAssessment');

ProgressNoteWriteNoteTypeEnum _$progressNoteWriteNoteTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'memberNote':
      return _$progressNoteWriteNoteTypeEnum_memberNote;
    case 'trainerAssessment':
      return _$progressNoteWriteNoteTypeEnum_trainerAssessment;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProgressNoteWriteNoteTypeEnum>
    _$progressNoteWriteNoteTypeEnumValues = BuiltSet<
        ProgressNoteWriteNoteTypeEnum>(const <ProgressNoteWriteNoteTypeEnum>[
  _$progressNoteWriteNoteTypeEnum_memberNote,
  _$progressNoteWriteNoteTypeEnum_trainerAssessment,
]);

Serializer<ProgressNoteWriteNoteTypeEnum>
    _$progressNoteWriteNoteTypeEnumSerializer =
    _$ProgressNoteWriteNoteTypeEnumSerializer();

class _$ProgressNoteWriteNoteTypeEnumSerializer
    implements PrimitiveSerializer<ProgressNoteWriteNoteTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'memberNote': 'member_note',
    'trainerAssessment': 'trainer_assessment',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'member_note': 'memberNote',
    'trainer_assessment': 'trainerAssessment',
  };

  @override
  final Iterable<Type> types = const <Type>[ProgressNoteWriteNoteTypeEnum];
  @override
  final String wireName = 'ProgressNoteWriteNoteTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ProgressNoteWriteNoteTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProgressNoteWriteNoteTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProgressNoteWriteNoteTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProgressNoteWrite extends ProgressNoteWrite {
  @override
  final String noteText;
  @override
  final ProgressNoteWriteNoteTypeEnum noteType;

  factory _$ProgressNoteWrite(
          [void Function(ProgressNoteWriteBuilder)? updates]) =>
      (ProgressNoteWriteBuilder()..update(updates))._build();

  _$ProgressNoteWrite._({required this.noteText, required this.noteType})
      : super._();
  @override
  ProgressNoteWrite rebuild(void Function(ProgressNoteWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressNoteWriteBuilder toBuilder() =>
      ProgressNoteWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressNoteWrite &&
        noteText == other.noteText &&
        noteType == other.noteType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, noteText.hashCode);
    _$hash = $jc(_$hash, noteType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressNoteWrite')
          ..add('noteText', noteText)
          ..add('noteType', noteType))
        .toString();
  }
}

class ProgressNoteWriteBuilder
    implements Builder<ProgressNoteWrite, ProgressNoteWriteBuilder> {
  _$ProgressNoteWrite? _$v;

  String? _noteText;
  String? get noteText => _$this._noteText;
  set noteText(String? noteText) => _$this._noteText = noteText;

  ProgressNoteWriteNoteTypeEnum? _noteType;
  ProgressNoteWriteNoteTypeEnum? get noteType => _$this._noteType;
  set noteType(ProgressNoteWriteNoteTypeEnum? noteType) =>
      _$this._noteType = noteType;

  ProgressNoteWriteBuilder() {
    ProgressNoteWrite._defaults(this);
  }

  ProgressNoteWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _noteText = $v.noteText;
      _noteType = $v.noteType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressNoteWrite other) {
    _$v = other as _$ProgressNoteWrite;
  }

  @override
  void update(void Function(ProgressNoteWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressNoteWrite build() => _build();

  _$ProgressNoteWrite _build() {
    final _$result = _$v ??
        _$ProgressNoteWrite._(
          noteText: BuiltValueNullFieldError.checkNotNull(
              noteText, r'ProgressNoteWrite', 'noteText'),
          noteType: BuiltValueNullFieldError.checkNotNull(
              noteType, r'ProgressNoteWrite', 'noteType'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
