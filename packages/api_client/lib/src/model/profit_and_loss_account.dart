//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profit_and_loss_account.g.dart';

/// ProfitAndLossAccount
///
/// Properties:
/// * [accountId] 
/// * [accountName] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class ProfitAndLossAccount implements Built<ProfitAndLossAccount, ProfitAndLossAccountBuilder> {
  @BuiltValueField(wireName: r'account_id')
  int get accountId;

  @BuiltValueField(wireName: r'account_name')
  String get accountName;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  ProfitAndLossAccount._();

  factory ProfitAndLossAccount([void updates(ProfitAndLossAccountBuilder b)]) = _$ProfitAndLossAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfitAndLossAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfitAndLossAccount> get serializer => _$ProfitAndLossAccountSerializer();
}

class _$ProfitAndLossAccountSerializer implements PrimitiveSerializer<ProfitAndLossAccount> {
  @override
  final Iterable<Type> types = const [ProfitAndLossAccount, _$ProfitAndLossAccount];

  @override
  final String wireName = r'ProfitAndLossAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfitAndLossAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'account_id';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(int),
    );
    yield r'account_name';
    yield serializers.serialize(
      object.accountName,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfitAndLossAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProfitAndLossAccountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accountId = valueDes;
          break;
        case r'account_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountName = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfitAndLossAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfitAndLossAccountBuilder();
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


