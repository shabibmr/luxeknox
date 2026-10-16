//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/account_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account.g.dart';

/// Account
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [accountType] 
/// * [parentId] 
/// * [isActive] 
/// * [isBank] 
/// * [isControl] 
/// * [controlRole] 
/// * [createdAt] - UTC ISO-8601
/// * [updatedAt] - UTC ISO-8601
@BuiltValue()
abstract class Account implements Built<Account, AccountBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'account_type')
  AccountType get accountType;
  // enum accountTypeEnum {  asset,  liability,  equity,  income,  expense,  };

  @BuiltValueField(wireName: r'parent_id')
  int? get parentId;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  @BuiltValueField(wireName: r'is_bank')
  bool get isBank;

  @BuiltValueField(wireName: r'is_control')
  bool get isControl;

  @BuiltValueField(wireName: r'control_role')
  String? get controlRole;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  Account._();

  factory Account([void updates(AccountBuilder b)]) = _$Account;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Account> get serializer => _$AccountSerializer();
}

class _$AccountSerializer implements PrimitiveSerializer<Account> {
  @override
  final Iterable<Type> types = const [Account, _$Account];

  @override
  final String wireName = r'Account';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Account object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
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
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'is_bank';
    yield serializers.serialize(
      object.isBank,
      specifiedType: const FullType(bool),
    );
    yield r'is_control';
    yield serializers.serialize(
      object.isControl,
      specifiedType: const FullType(bool),
    );
    if (object.controlRole != null) {
      yield r'control_role';
      yield serializers.serialize(
        object.controlRole,
        specifiedType: const FullType(String),
      );
    }
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
    Account object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountBuilder result,
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
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'is_bank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isBank = valueDes;
          break;
        case r'is_control':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
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
  Account deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountBuilder();
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


