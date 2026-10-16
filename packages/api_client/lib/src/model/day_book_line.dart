//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'day_book_line.g.dart';

/// DayBookLine
///
/// Properties:
/// * [id] 
/// * [accountId] 
/// * [accountName] 
/// * [debit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [credit] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [memo] 
/// * [memberId] 
/// * [vendorId] 
@BuiltValue()
abstract class DayBookLine implements Built<DayBookLine, DayBookLineBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'account_id')
  int get accountId;

  @BuiltValueField(wireName: r'account_name')
  String get accountName;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'debit')
  String get debit;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'credit')
  String get credit;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  @BuiltValueField(wireName: r'member_id')
  int? get memberId;

  @BuiltValueField(wireName: r'vendor_id')
  int? get vendorId;

  DayBookLine._();

  factory DayBookLine([void updates(DayBookLineBuilder b)]) = _$DayBookLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DayBookLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DayBookLine> get serializer => _$DayBookLineSerializer();
}

class _$DayBookLineSerializer implements PrimitiveSerializer<DayBookLine> {
  @override
  final Iterable<Type> types = const [DayBookLine, _$DayBookLine];

  @override
  final String wireName = r'DayBookLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DayBookLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
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
    if (object.memo != null) {
      yield r'memo';
      yield serializers.serialize(
        object.memo,
        specifiedType: const FullType(String),
      );
    }
    if (object.memberId != null) {
      yield r'member_id';
      yield serializers.serialize(
        object.memberId,
        specifiedType: const FullType(int),
      );
    }
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DayBookLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DayBookLineBuilder result,
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
        case r'memo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.memo = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.memberId = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DayBookLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DayBookLineBuilder();
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


