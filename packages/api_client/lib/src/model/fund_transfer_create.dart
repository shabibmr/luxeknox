//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fund_transfer_create.g.dart';

/// FundTransferCreate
///
/// Properties:
/// * [transferDate] 
/// * [fromAccountId] 
/// * [toAccountId] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [feeAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [feeAccountId] 
/// * [memo] 
@BuiltValue()
abstract class FundTransferCreate implements Built<FundTransferCreate, FundTransferCreateBuilder> {
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
  String? get feeAmount;

  @BuiltValueField(wireName: r'fee_account_id')
  int? get feeAccountId;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  FundTransferCreate._();

  factory FundTransferCreate([void updates(FundTransferCreateBuilder b)]) = _$FundTransferCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FundTransferCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FundTransferCreate> get serializer => _$FundTransferCreateSerializer();
}

class _$FundTransferCreateSerializer implements PrimitiveSerializer<FundTransferCreate> {
  @override
  final Iterable<Type> types = const [FundTransferCreate, _$FundTransferCreate];

  @override
  final String wireName = r'FundTransferCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FundTransferCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.feeAmount != null) {
      yield r'fee_amount';
      yield serializers.serialize(
        object.feeAmount,
        specifiedType: const FullType(String),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    FundTransferCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FundTransferCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FundTransferCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FundTransferCreateBuilder();
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


