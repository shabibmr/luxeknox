//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/payment_allocation.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_voucher.g.dart';

/// PaymentVoucher
///
/// Properties:
/// * [id] 
/// * [voucherNumber] 
/// * [paymentDate] 
/// * [bankAccountId] 
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [memo] 
/// * [status] 
/// * [journalEntryId] 
/// * [rowVersion] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] - UTC ISO-8601
/// * [allocations] 
@BuiltValue()
abstract class PaymentVoucher implements Built<PaymentVoucher, PaymentVoucherBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'voucher_number')
  String get voucherNumber;

  @BuiltValueField(wireName: r'payment_date')
  Date get paymentDate;

  @BuiltValueField(wireName: r'bank_account_id')
  int get bankAccountId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String get totalAmount;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'status')
  PaymentVoucherStatusEnum get status;
  // enum statusEnum {  draft,  posted,  };

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

  @BuiltValueField(wireName: r'allocations')
  BuiltList<PaymentAllocation> get allocations;

  PaymentVoucher._();

  factory PaymentVoucher([void updates(PaymentVoucherBuilder b)]) = _$PaymentVoucher;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentVoucherBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentVoucher> get serializer => _$PaymentVoucherSerializer();
}

class _$PaymentVoucherSerializer implements PrimitiveSerializer<PaymentVoucher> {
  @override
  final Iterable<Type> types = const [PaymentVoucher, _$PaymentVoucher];

  @override
  final String wireName = r'PaymentVoucher';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentVoucher object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'voucher_number';
    yield serializers.serialize(
      object.voucherNumber,
      specifiedType: const FullType(String),
    );
    yield r'payment_date';
    yield serializers.serialize(
      object.paymentDate,
      specifiedType: const FullType(Date),
    );
    yield r'bank_account_id';
    yield serializers.serialize(
      object.bankAccountId,
      specifiedType: const FullType(int),
    );
    yield r'total_amount';
    yield serializers.serialize(
      object.totalAmount,
      specifiedType: const FullType(String),
    );
    if (object.memo != null) {
      yield r'memo';
      yield serializers.serialize(
        object.memo,
        specifiedType: const FullType(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PaymentVoucherStatusEnum),
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
    yield r'allocations';
    yield serializers.serialize(
      object.allocations,
      specifiedType: const FullType(BuiltList, [FullType(PaymentAllocation)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentVoucher object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentVoucherBuilder result,
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
        case r'voucher_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.voucherNumber = valueDes;
          break;
        case r'payment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.paymentDate = valueDes;
          break;
        case r'bank_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.bankAccountId = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalAmount = valueDes;
          break;
        case r'memo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.memo = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentVoucherStatusEnum),
          ) as PaymentVoucherStatusEnum;
          result.status = valueDes;
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
        case r'allocations':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaymentAllocation)]),
          ) as BuiltList<PaymentAllocation>;
          result.allocations.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentVoucher deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentVoucherBuilder();
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


class PaymentVoucherStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const PaymentVoucherStatusEnum draft = _$paymentVoucherStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'posted')
  static const PaymentVoucherStatusEnum posted = _$paymentVoucherStatusEnum_posted;

  static Serializer<PaymentVoucherStatusEnum> get serializer => _$paymentVoucherStatusEnumSerializer;

  const PaymentVoucherStatusEnum._(String name): super(name);

  static BuiltSet<PaymentVoucherStatusEnum> get values => _$paymentVoucherStatusEnumValues;
  static PaymentVoucherStatusEnum valueOf(String name) => _$paymentVoucherStatusEnumValueOf(name);
}

