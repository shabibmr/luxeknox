//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/purchase_bill_line_write.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_bill_create.g.dart';

/// PurchaseBillCreate
///
/// Properties:
/// * [vendorId] 
/// * [billDate] 
/// * [supplierInvoiceNo] 
/// * [dueDate] 
/// * [draft] - When true the bill is saved as a draft and posted later via POST /accounting/purchase-bills/{id}/post.
/// * [lines] 
@BuiltValue()
abstract class PurchaseBillCreate implements Built<PurchaseBillCreate, PurchaseBillCreateBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  int get vendorId;

  @BuiltValueField(wireName: r'bill_date')
  Date get billDate;

  @BuiltValueField(wireName: r'supplier_invoice_no')
  String? get supplierInvoiceNo;

  @BuiltValueField(wireName: r'due_date')
  Date? get dueDate;

  /// When true the bill is saved as a draft and posted later via POST /accounting/purchase-bills/{id}/post.
  @BuiltValueField(wireName: r'draft')
  bool? get draft;

  @BuiltValueField(wireName: r'lines')
  BuiltList<PurchaseBillLineWrite> get lines;

  PurchaseBillCreate._();

  factory PurchaseBillCreate([void updates(PurchaseBillCreateBuilder b)]) = _$PurchaseBillCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PurchaseBillCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PurchaseBillCreate> get serializer => _$PurchaseBillCreateSerializer();
}

class _$PurchaseBillCreateSerializer implements PrimitiveSerializer<PurchaseBillCreate> {
  @override
  final Iterable<Type> types = const [PurchaseBillCreate, _$PurchaseBillCreate];

  @override
  final String wireName = r'PurchaseBillCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PurchaseBillCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(int),
    );
    yield r'bill_date';
    yield serializers.serialize(
      object.billDate,
      specifiedType: const FullType(Date),
    );
    if (object.supplierInvoiceNo != null) {
      yield r'supplier_invoice_no';
      yield serializers.serialize(
        object.supplierInvoiceNo,
        specifiedType: const FullType(String),
      );
    }
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.draft != null) {
      yield r'draft';
      yield serializers.serialize(
        object.draft,
        specifiedType: const FullType(bool),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(PurchaseBillLineWrite)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PurchaseBillCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PurchaseBillCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorId = valueDes;
          break;
        case r'bill_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.billDate = valueDes;
          break;
        case r'supplier_invoice_no':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierInvoiceNo = valueDes;
          break;
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dueDate = valueDes;
          break;
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.draft = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PurchaseBillLineWrite)]),
          ) as BuiltList<PurchaseBillLineWrite>;
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
  PurchaseBillCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PurchaseBillCreateBuilder();
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


