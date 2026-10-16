//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/purchase_bill_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/purchase_bill_line.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'purchase_bill.g.dart';

/// PurchaseBill
///
/// Properties:
/// * [id] 
/// * [billNumber] 
/// * [supplierInvoiceNo] 
/// * [vendorId] 
/// * [billDate] 
/// * [dueDate] 
/// * [status] 
/// * [subtotal] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [journalEntryId] 
/// * [rowVersion] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] - UTC ISO-8601
/// * [lines] 
@BuiltValue()
abstract class PurchaseBill implements Built<PurchaseBill, PurchaseBillBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'bill_number')
  String get billNumber;

  @BuiltValueField(wireName: r'supplier_invoice_no')
  String? get supplierInvoiceNo;

  @BuiltValueField(wireName: r'vendor_id')
  int get vendorId;

  @BuiltValueField(wireName: r'bill_date')
  Date get billDate;

  @BuiltValueField(wireName: r'due_date')
  Date? get dueDate;

  @BuiltValueField(wireName: r'status')
  PurchaseBillStatus get status;
  // enum statusEnum {  draft,  posted,  void,  };

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'subtotal')
  String get subtotal;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'tax_amount')
  String get taxAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String get totalAmount;

  @BuiltValueField(wireName: r'journal_entry_id')
  int? get journalEntryId;

  @BuiltValueField(wireName: r'row_version')
  int get rowVersion;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: r'lines')
  BuiltList<PurchaseBillLine> get lines;

  PurchaseBill._();

  factory PurchaseBill([void updates(PurchaseBillBuilder b)]) = _$PurchaseBill;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PurchaseBillBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PurchaseBill> get serializer => _$PurchaseBillSerializer();
}

class _$PurchaseBillSerializer implements PrimitiveSerializer<PurchaseBill> {
  @override
  final Iterable<Type> types = const [PurchaseBill, _$PurchaseBill];

  @override
  final String wireName = r'PurchaseBill';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PurchaseBill object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'bill_number';
    yield serializers.serialize(
      object.billNumber,
      specifiedType: const FullType(String),
    );
    if (object.supplierInvoiceNo != null) {
      yield r'supplier_invoice_no';
      yield serializers.serialize(
        object.supplierInvoiceNo,
        specifiedType: const FullType(String),
      );
    }
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
    if (object.dueDate != null) {
      yield r'due_date';
      yield serializers.serialize(
        object.dueDate,
        specifiedType: const FullType(Date),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PurchaseBillStatus),
    );
    yield r'subtotal';
    yield serializers.serialize(
      object.subtotal,
      specifiedType: const FullType(String),
    );
    yield r'tax_amount';
    yield serializers.serialize(
      object.taxAmount,
      specifiedType: const FullType(String),
    );
    yield r'total_amount';
    yield serializers.serialize(
      object.totalAmount,
      specifiedType: const FullType(String),
    );
    if (object.journalEntryId != null) {
      yield r'journal_entry_id';
      yield serializers.serialize(
        object.journalEntryId,
        specifiedType: const FullType(int),
      );
    }
    yield r'row_version';
    yield serializers.serialize(
      object.rowVersion,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.updatedAt != null) {
      yield r'updated_at';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(PurchaseBillLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PurchaseBill object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PurchaseBillBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'bill_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.billNumber = valueDes;
          break;
        case r'supplier_invoice_no':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierInvoiceNo = valueDes;
          break;
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
        case r'due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.dueDate = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PurchaseBillStatus),
          ) as PurchaseBillStatus;
          result.status = valueDes;
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
            specifiedType: const FullType(String),
          ) as String;
          result.taxAmount = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalAmount = valueDes;
          break;
        case r'journal_entry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.journalEntryId = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rowVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PurchaseBillLine)]),
          ) as BuiltList<PurchaseBillLine>;
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
  PurchaseBill deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PurchaseBillBuilder();
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


