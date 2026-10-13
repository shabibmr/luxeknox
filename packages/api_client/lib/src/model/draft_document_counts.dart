//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'draft_document_counts.g.dart';

/// DraftDocumentCounts
///
/// Properties:
/// * [purchaseBills] 
/// * [expenseVouchers] 
/// * [paymentVouchers] 
/// * [creditNotes] 
/// * [debitNotes] 
/// * [total] 
@BuiltValue()
abstract class DraftDocumentCounts implements Built<DraftDocumentCounts, DraftDocumentCountsBuilder> {
  @BuiltValueField(wireName: r'purchase_bills')
  int get purchaseBills;

  @BuiltValueField(wireName: r'expense_vouchers')
  int get expenseVouchers;

  @BuiltValueField(wireName: r'payment_vouchers')
  int get paymentVouchers;

  @BuiltValueField(wireName: r'credit_notes')
  int get creditNotes;

  @BuiltValueField(wireName: r'debit_notes')
  int get debitNotes;

  @BuiltValueField(wireName: r'total')
  int get total;

  DraftDocumentCounts._();

  factory DraftDocumentCounts([void updates(DraftDocumentCountsBuilder b)]) = _$DraftDocumentCounts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DraftDocumentCountsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DraftDocumentCounts> get serializer => _$DraftDocumentCountsSerializer();
}

class _$DraftDocumentCountsSerializer implements PrimitiveSerializer<DraftDocumentCounts> {
  @override
  final Iterable<Type> types = const [DraftDocumentCounts, _$DraftDocumentCounts];

  @override
  final String wireName = r'DraftDocumentCounts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DraftDocumentCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'purchase_bills';
    yield serializers.serialize(
      object.purchaseBills,
      specifiedType: const FullType(int),
    );
    yield r'expense_vouchers';
    yield serializers.serialize(
      object.expenseVouchers,
      specifiedType: const FullType(int),
    );
    yield r'payment_vouchers';
    yield serializers.serialize(
      object.paymentVouchers,
      specifiedType: const FullType(int),
    );
    yield r'credit_notes';
    yield serializers.serialize(
      object.creditNotes,
      specifiedType: const FullType(int),
    );
    yield r'debit_notes';
    yield serializers.serialize(
      object.debitNotes,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DraftDocumentCounts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DraftDocumentCountsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'purchase_bills':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.purchaseBills = valueDes;
          break;
        case r'expense_vouchers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expenseVouchers = valueDes;
          break;
        case r'payment_vouchers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentVouchers = valueDes;
          break;
        case r'credit_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditNotes = valueDes;
          break;
        case r'debit_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.debitNotes = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DraftDocumentCounts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DraftDocumentCountsBuilder();
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


