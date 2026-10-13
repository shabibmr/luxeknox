// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_note_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DebitNoteStatus _$draft = const DebitNoteStatus._('draft');
const DebitNoteStatus _$posted = const DebitNoteStatus._('posted');
const DebitNoteStatus _$void_ = const DebitNoteStatus._('void_');

DebitNoteStatus _$valueOf(String name) {
  switch (name) {
    case 'draft':
      return _$draft;
    case 'posted':
      return _$posted;
    case 'void_':
      return _$void_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DebitNoteStatus> _$values =
    BuiltSet<DebitNoteStatus>(const <DebitNoteStatus>[
  _$draft,
  _$posted,
  _$void_,
]);

class _$DebitNoteStatusMeta {
  const _$DebitNoteStatusMeta();
  DebitNoteStatus get draft => _$draft;
  DebitNoteStatus get posted => _$posted;
  DebitNoteStatus get void_ => _$void_;
  DebitNoteStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<DebitNoteStatus> get values => _$values;
}

abstract class _$DebitNoteStatusMixin {
  // ignore: non_constant_identifier_names
  _$DebitNoteStatusMeta get DebitNoteStatus => const _$DebitNoteStatusMeta();
}

Serializer<DebitNoteStatus> _$debitNoteStatusSerializer =
    _$DebitNoteStatusSerializer();

class _$DebitNoteStatusSerializer
    implements PrimitiveSerializer<DebitNoteStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'posted': 'posted',
    'void_': 'void',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'posted': 'posted',
    'void': 'void_',
  };

  @override
  final Iterable<Type> types = const <Type>[DebitNoteStatus];
  @override
  final String wireName = 'DebitNoteStatus';

  @override
  Object serialize(Serializers serializers, DebitNoteStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DebitNoteStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DebitNoteStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
