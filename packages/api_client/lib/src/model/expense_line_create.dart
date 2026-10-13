//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expense_line_create.g.dart';

/// ExpenseLineCreate
///
/// Properties:
/// * [accountId] 
/// * [description] 
/// * [amount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [taxCodeId] 
@BuiltValue()
abstract class ExpenseLineCreate implements Built<ExpenseLineCreate, ExpenseLineCreateBuilder> {
  @BuiltValueField(wireName: r'account_id')
  int get accountId;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'tax_code_id')
  int? get taxCodeId;

  ExpenseLineCreate._();

  factory ExpenseLineCreate([void updates(ExpenseLineCreateBuilder b)]) = _$ExpenseLineCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExpenseLineCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExpenseLineCreate> get serializer => _$ExpenseLineCreateSerializer();
}

class _$ExpenseLineCreateSerializer implements PrimitiveSerializer<ExpenseLineCreate> {
  @override
  final Iterable<Type> types = const [ExpenseLineCreate, _$ExpenseLineCreate];

  @override
  final String wireName = r'ExpenseLineCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExpenseLineCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'account_id';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(int),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    if (object.taxCodeId != null) {
      yield r'tax_code_id';
      yield serializers.serialize(
        object.taxCodeId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExpenseLineCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExpenseLineCreateBuilder result,
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'tax_code_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.taxCodeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExpenseLineCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExpenseLineCreateBuilder();
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


