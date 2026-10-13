//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'debit_note_status.g.dart';

class DebitNoteStatus extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const DebitNoteStatus draft = _$draft;
  @BuiltValueEnumConst(wireName: r'posted')
  static const DebitNoteStatus posted = _$posted;
  @BuiltValueEnumConst(wireName: r'void')
  static const DebitNoteStatus void_ = _$void_;

  static Serializer<DebitNoteStatus> get serializer => _$debitNoteStatusSerializer;

  const DebitNoteStatus._(String name): super(name);

  static BuiltSet<DebitNoteStatus> get values => _$values;
  static DebitNoteStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DebitNoteStatusMixin = Object with _$DebitNoteStatusMixin;

