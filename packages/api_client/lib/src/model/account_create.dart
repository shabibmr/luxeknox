//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/account_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_create.g.dart';

/// AccountCreate
///
/// Properties:
/// * [name] 
/// * [accountType] 
/// * [parentId] 
/// * [isActive] 
/// * [isBank] 
/// * [isControl] 
/// * [controlRole] 
@BuiltValue()
abstract class AccountCreate implements Built<AccountCreate, AccountCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'account_type')
  AccountType get accountType;
  // enum accountTypeEnum {  asset,  liability,  equity,  income,  expense,  };

  @BuiltValueField(wireName: r'parent_id')
  int? get parentId;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  @BuiltValueField(wireName: r'is_bank')
  bool? get isBank;

  @BuiltValueField(wireName: r'is_control')
  bool? get isControl;

  @BuiltValueField(wireName: r'control_role')
  String? get controlRole;

  AccountCreate._();

  factory AccountCreate([void updates(AccountCreateBuilder b)]) = _$AccountCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountCreateBuilder b) => b
      ..isActive = true
      ..isBank = false
      ..isControl = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountCreate> get serializer => _$AccountCreateSerializer();
}

class _$AccountCreateSerializer implements PrimitiveSerializer<AccountCreate> {
  @override
  final Iterable<Type> types = const [AccountCreate, _$AccountCreate];

  @override
  final String wireName = r'AccountCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'account_type';
    yield serializers.serialize(
      object.accountType,
      specifiedType: const FullType(AccountType),
    );
    if (object.parentId != null) {
      yield r'parent_id';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType(int),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isBank != null) {
      yield r'is_bank';
      yield serializers.serialize(
        object.isBank,
        specifiedType: const FullType(bool),
      );
    }
    if (object.isControl != null) {
      yield r'is_control';
      yield serializers.serialize(
        object.isControl,
        specifiedType: const FullType(bool),
      );
    }
    if (object.controlRole != null) {
      yield r'control_role';
      yield serializers.serialize(
        object.controlRole,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'account_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountType),
          ) as AccountType;
          result.accountType = valueDes;
          break;
        case r'parent_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        case r'is_bank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isBank = valueDes;
          break;
        case r'is_control':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isControl = valueDes;
          break;
        case r'control_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.controlRole = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountCreateBuilder();
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


