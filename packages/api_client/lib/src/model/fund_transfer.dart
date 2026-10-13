//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fund_transfer.g.dart';

/// FundTransfer
///
/// Properties:
/// * [id] 
/// * [transferNumber] 
/// * [transferDate] 
/// * [fromAccountId] 
/// * [toAccountId] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [feeAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [feeAccountId] 
/// * [memo] 
/// * [status] 
/// * [journalEntryId] 
/// * [rowVersion] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] - UTC ISO-8601
@BuiltValue()
abstract class FundTransfer implements Built<FundTransfer, FundTransferBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'transfer_number')
  String get transferNumber;

  @BuiltValueField(wireName: r'transfer_date')
  Date get transferDate;

  @BuiltValueField(wireName: r'from_account_id')
  int get fromAccountId;

  @BuiltValueField(wireName: r'to_account_id')
  int get toAccountId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'fee_amount')
  String get feeAmount;

  @BuiltValueField(wireName: r'fee_account_id')
  int? get feeAccountId;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'status')
  FundTransferStatusEnum get status;
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

  FundTransfer._();

  factory FundTransfer([void updates(FundTransferBuilder b)]) = _$FundTransfer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FundTransferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FundTransfer> get serializer => _$FundTransferSerializer();
}

class _$FundTransferSerializer implements PrimitiveSerializer<FundTransfer> {
  @override
  final Iterable<Type> types = const [FundTransfer, _$FundTransfer];

  @override
  final String wireName = r'FundTransfer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FundTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'transfer_number';
    yield serializers.serialize(
      object.transferNumber,
      specifiedType: const FullType(String),
    );
    yield r'transfer_date';
    yield serializers.serialize(
      object.transferDate,
      specifiedType: const FullType(Date),
    );
    yield r'from_account_id';
    yield serializers.serialize(
      object.fromAccountId,
      specifiedType: const FullType(int),
    );
    yield r'to_account_id';
    yield serializers.serialize(
      object.toAccountId,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'fee_amount';
    yield serializers.serialize(
      object.feeAmount,
      specifiedType: const FullType(String),
    );
    if (object.feeAccountId != null) {
      yield r'fee_account_id';
      yield serializers.serialize(
        object.feeAccountId,
        specifiedType: const FullType(int),
      );
    }
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
      specifiedType: const FullType(FundTransferStatusEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FundTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FundTransferBuilder result,
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
        case r'transfer_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.transferNumber = valueDes;
          break;
        case r'transfer_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.transferDate = valueDes;
          break;
        case r'from_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fromAccountId = valueDes;
          break;
        case r'to_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.toAccountId = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'fee_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.feeAmount = valueDes;
          break;
        case r'fee_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.feeAccountId = valueDes;
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
            specifiedType: const FullType(FundTransferStatusEnum),
          ) as FundTransferStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FundTransfer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FundTransferBuilder();
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


class FundTransferStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'draft')
  static const FundTransferStatusEnum draft = _$fundTransferStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'posted')
  static const FundTransferStatusEnum posted = _$fundTransferStatusEnum_posted;

  static Serializer<FundTransferStatusEnum> get serializer => _$fundTransferStatusEnumSerializer;

  const FundTransferStatusEnum._(String name): super(name);

  static BuiltSet<FundTransferStatusEnum> get values => _$fundTransferStatusEnumValues;
  static FundTransferStatusEnum valueOf(String name) => _$fundTransferStatusEnumValueOf(name);
}

