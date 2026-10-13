//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/purchase_bill_line_write.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_bill_update.g.dart';

/// PurchaseBillUpdate
///
/// Properties:
/// * [vendorId] 
/// * [billDate] 
/// * [dueDate] 
/// * [lines] 
@BuiltValue()
abstract class PurchaseBillUpdate implements Built<PurchaseBillUpdate, PurchaseBillUpdateBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  int? get vendorId;

  @BuiltValueField(wireName: r'bill_date')
  Date? get billDate;

  @BuiltValueField(wireName: r'due_date')
  Date? get dueDate;

  @BuiltValueField(wireName: r'lines')
  BuiltList<PurchaseBillLineWrite>? get lines;

  PurchaseBillUpdate._();

  factory PurchaseBillUpdate([void updates(PurchaseBillUpdateBuilder b)]) = _$PurchaseBillUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PurchaseBillUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PurchaseBillUpdate> get serializer => _$PurchaseBillUpdateSerializer();
}

class _$PurchaseBillUpdateSerializer implements PrimitiveSerializer<PurchaseBillUpdate> {
  @override
  final Iterable<Type> types = const [PurchaseBillUpdate, _$PurchaseBillUpdate];

  @override
  final String wireName = r'PurchaseBillUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PurchaseBillUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType(int),
      );
    }
    if (object.billDate != null) {
      yield r'bill_date';
      yield serializers.serialize(
        object.billDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.lines != null) {
      yield r'lines';
      yield serializers.serialize(
        object.lines,
        specifiedType: const FullType(BuiltList, [FullType(PurchaseBillLineWrite)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PurchaseBillUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PurchaseBillUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        case r'bill_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
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
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(PurchaseBillLineWrite)]),
          ) as BuiltList<PurchaseBillLineWrite>?;
          if (valueDes == null) continue;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PurchaseBillUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PurchaseBillUpdateBuilder();
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


