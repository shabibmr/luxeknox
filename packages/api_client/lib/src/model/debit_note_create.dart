//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'debit_note_create.g.dart';

/// DebitNoteCreate
///
/// Properties:
/// * [purchaseBillId] 
/// * [debitNoteDate] 
/// * [reason] 
/// * [subtotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class DebitNoteCreate implements Built<DebitNoteCreate, DebitNoteCreateBuilder> {
  @BuiltValueField(wireName: r'purchase_bill_id')
  int get purchaseBillId;

  @BuiltValueField(wireName: r'debit_note_date')
  Date get debitNoteDate;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'subtotal')
  String get subtotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'tax_amount')
  String? get taxAmount;

  DebitNoteCreate._();

  factory DebitNoteCreate([void updates(DebitNoteCreateBuilder b)]) = _$DebitNoteCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DebitNoteCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DebitNoteCreate> get serializer => _$DebitNoteCreateSerializer();
}

class _$DebitNoteCreateSerializer implements PrimitiveSerializer<DebitNoteCreate> {
  @override
  final Iterable<Type> types = const [DebitNoteCreate, _$DebitNoteCreate];

  @override
  final String wireName = r'DebitNoteCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DebitNoteCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'purchase_bill_id';
    yield serializers.serialize(
      object.purchaseBillId,
      specifiedType: const FullType(int),
    );
    yield r'debit_note_date';
    yield serializers.serialize(
      object.debitNoteDate,
      specifiedType: const FullType(Date),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(String),
    );
    if (object.taxAmount != null) {
      yield r'tax_amount';
      yield serializers.serialize(
        object.taxAmount,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DebitNoteCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DebitNoteCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'purchase_bill_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.purchaseBillId = valueDes;
          break;
        case r'debit_note_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.debitNoteDate = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'subtotal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subtotal = valueDes;
          break;
        case r'tax_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxAmount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DebitNoteCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DebitNoteCreateBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


