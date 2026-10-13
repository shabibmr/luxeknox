//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'open_ap_item.g.dart';

/// OpenApItem
///
/// Properties:
/// * [purchaseBillId] 
/// * [billNumber] 
/// * [billDate] 
/// * [dueDate] 
/// * [vendorId] 
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [allocatedAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [debitNoteAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [openAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [status] 
@BuiltValue()
abstract class OpenApItem implements Built<OpenApItem, OpenApItemBuilder> {
  @BuiltValueField(wireName: r'purchase_bill_id')
  int get purchaseBillId;

  @BuiltValueField(wireName: r'bill_number')
  String get billNumber;

  @BuiltValueField(wireName: r'bill_date')
  Date get billDate;

  @BuiltValueField(wireName: r'due_date')
  Date? get dueDate;

  @BuiltValueField(wireName: r'vendor_id')
  int get vendorId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String get totalAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'allocated_amount')
  String get allocatedAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'debit_note_amount')
  String get debitNoteAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'open_amount')
  String get openAmount;

  @BuiltValueField(wireName: r'status')
  String get status;

  OpenApItem._();

  factory OpenApItem([void updates(OpenApItemBuilder b)]) = _$OpenApItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OpenApItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OpenApItem> get serializer => _$OpenApItemSerializer();
}

class _$OpenApItemSerializer implements PrimitiveSerializer<OpenApItem> {
  @override
  final Iterable<Type> types = const [OpenApItem, _$OpenApItem];

  @override
  final String wireName = r'OpenApItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OpenApItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'purchase_bill_id';
    yield serializers.serialize(
      object.purchaseBillId,
      specifiedType: const FullType(int),
    );
    yield r'bill_number';
    yield serializers.serialize(
      object.billNumber,
      specifiedType: const FullType(String),
    );
    yield r'bill_date';
    yield serializers.serialize(
      object.billDate,
      specifiedType: const FullType(Date),
    );
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType(Date),
      );
    }
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(int),
    );
    yield r'total_amount';
    yield serializers.serialize(
      object.totalAmount,
      specifiedType: const FullType(String),
    );
    yield r'allocated_amount';
    yield serializers.serialize(
      object.allocatedAmount,
      specifiedType: const FullType(String),
    );
    yield r'debit_note_amount';
    yield serializers.serialize(
      object.debitNoteAmount,
      specifiedType: const FullType(String),
    );
    yield r'open_amount';
    yield serializers.serialize(
      object.openAmount,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OpenApItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OpenApItemBuilder result,
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
        case r'bill_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.billNumber = valueDes;
          break;
        case r'bill_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.billDate = valueDes;
          break;
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dueDate = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorId = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalAmount = valueDes;
          break;
        case r'allocated_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.allocatedAmount = valueDes;
          break;
        case r'debit_note_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.debitNoteAmount = valueDes;
          break;
        case r'open_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.openAmount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OpenApItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OpenApItemBuilder();
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


