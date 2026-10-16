//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'trial_balance_account.g.dart';

/// TrialBalanceAccount
///
/// Properties:
/// * [accountId] 
/// * [accountName] 
/// * [accountType] 
/// * [debit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [credit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
@BuiltValue()
abstract class TrialBalanceAccount implements Built<TrialBalanceAccount, TrialBalanceAccountBuilder> {
  @BuiltValueField(wireName: r'account_id')
  int get accountId;

  @BuiltValueField(wireName: r'account_name')
  String get accountName;

  @BuiltValueField(wireName: r'account_type')
  String get accountType;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'debit')
  String get debit;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'credit')
  String get credit;

  TrialBalanceAccount._();

  factory TrialBalanceAccount([void updates(TrialBalanceAccountBuilder b)]) = _$TrialBalanceAccount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TrialBalanceAccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TrialBalanceAccount> get serializer => _$TrialBalanceAccountSerializer();
}

class _$TrialBalanceAccountSerializer implements PrimitiveSerializer<TrialBalanceAccount> {
  @override
  final Iterable<Type> types = const [TrialBalanceAccount, _$TrialBalanceAccount];

  @override
  final String wireName = r'TrialBalanceAccount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TrialBalanceAccount object, {
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
    yield r'account_type';
    yield serializers.serialize(
      object.accountType,
      specifiedType: const FullType(String),
    );
    yield r'debit';
    yield serializers.serialize(
      object.debit,
      specifiedType: const FullType(String),
    );
    yield r'credit';
    yield serializers.serialize(
      object.credit,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TrialBalanceAccount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TrialBalanceAccountBuilder result,
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
        case r'account_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountType = valueDes;
          break;
        case r'debit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.debit = valueDes;
          break;
        case r'credit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.credit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TrialBalanceAccount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TrialBalanceAccountBuilder();
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


