//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/expense_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/expense_voucher_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expense_voucher.g.dart';

/// ExpenseVoucher
///
/// Properties:
/// * [id] 
/// * [expenseNumber] 
/// * [vendorId] 
/// * [payeeName] 
/// * [expenseDate] 
/// * [paidFromAccountId] 
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
abstract class ExpenseVoucher implements Built<ExpenseVoucher, ExpenseVoucherBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'expense_number')
  String get expenseNumber;

  @BuiltValueField(wireName: r'vendor_id')
  int? get vendorId;

  @BuiltValueField(wireName: r'payee_name')
  String? get payeeName;

  @BuiltValueField(wireName: r'expense_date')
  Date get expenseDate;

  @BuiltValueField(wireName: r'paid_from_account_id')
  int? get paidFromAccountId;

  @BuiltValueField(wireName: r'status')
  ExpenseStatus get status;
  // enum statusEnum {  draft,  posted,  };

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
  BuiltList<ExpenseVoucherLine> get lines;

  ExpenseVoucher._();

  factory ExpenseVoucher([void updates(ExpenseVoucherBuilder b)]) = _$ExpenseVoucher;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExpenseVoucherBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExpenseVoucher> get serializer => _$ExpenseVoucherSerializer();
}

class _$ExpenseVoucherSerializer implements PrimitiveSerializer<ExpenseVoucher> {
  @override
  final Iterable<Type> types = const [ExpenseVoucher, _$ExpenseVoucher];

  @override
  final String wireName = r'ExpenseVoucher';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExpenseVoucher object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'expense_number';
    yield serializers.serialize(
      object.expenseNumber,
      specifiedType: const FullType(String),
    );
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType(int),
      );
    }
    if (object.payeeName != null) {
      yield r'payee_name';
      yield serializers.serialize(
        object.payeeName,
        specifiedType: const FullType(String),
      );
    }
    yield r'expense_date';
    yield serializers.serialize(
      object.expenseDate,
      specifiedType: const FullType(Date),
    );
    if (object.paidFromAccountId != null) {
      yield r'paid_from_account_id';
      yield serializers.serialize(
        object.paidFromAccountId,
        specifiedType: const FullType(int),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ExpenseStatus),
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
      specifiedType: const FullType(BuiltList, [FullType(ExpenseVoucherLine)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExpenseVoucher object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExpenseVoucherBuilder result,
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
        case r'expense_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expenseNumber = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        case r'payee_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.payeeName = valueDes;
          break;
        case r'expense_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.expenseDate = valueDes;
          break;
        case r'paid_from_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paidFromAccountId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExpenseStatus),
          ) as ExpenseStatus;
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
            specifiedType: const FullType(BuiltList, [FullType(ExpenseVoucherLine)]),
          ) as BuiltList<ExpenseVoucherLine>;
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
  ExpenseVoucher deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExpenseVoucherBuilder();
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


