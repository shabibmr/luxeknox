//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'journal_reverse.g.dart';

/// JournalReverse
///
/// Properties:
/// * [entryDate] 
/// * [memo] 
@BuiltValue()
abstract class JournalReverse implements Built<JournalReverse, JournalReverseBuilder> {
  @BuiltValueField(wireName: r'entry_date')
  Date? get entryDate;

  @BuiltValueField(wireName: r'memo')
  String? get memo;

  JournalReverse._();

  factory JournalReverse([void updates(JournalReverseBuilder b)]) = _$JournalReverse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JournalReverseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JournalReverse> get serializer => _$JournalReverseSerializer();
}

class _$JournalReverseSerializer implements PrimitiveSerializer<JournalReverse> {
  @override
  final Iterable<Type> types = const [JournalReverse, _$JournalReverse];

  @override
  final String wireName = r'JournalReverse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JournalReverse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.entryDate != null) {
      yield r'entry_date';
      yield serializers.serialize(
        object.entryDate,
        specifiedType: const FullType(Date),
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
    JournalReverse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JournalReverseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'entry_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.entryDate = valueDes;
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
  JournalReverse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JournalReverseBuilder();
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


