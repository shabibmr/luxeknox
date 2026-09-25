//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ready_jobs.g.dart';

/// ReadyJobs
///
/// Properties:
/// * [failureCount] 
/// * [retryCount] 
/// * [lastSuccessAt] - UTC ISO-8601
@BuiltValue()
abstract class ReadyJobs implements Built<ReadyJobs, ReadyJobsBuilder> {
  @BuiltValueField(wireName: r'failure_count')
  int? get failureCount;

  @BuiltValueField(wireName: r'retry_count')
  int? get retryCount;

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'last_success_at')
  DateTime? get lastSuccessAt;

  ReadyJobs._();

  factory ReadyJobs([void updates(ReadyJobsBuilder b)]) = _$ReadyJobs;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReadyJobsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReadyJobs> get serializer => _$ReadyJobsSerializer();
}

class _$ReadyJobsSerializer implements PrimitiveSerializer<ReadyJobs> {
  @override
  final Iterable<Type> types = const [ReadyJobs, _$ReadyJobs];

  @override
  final String wireName = r'ReadyJobs';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReadyJobs object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.failureCount != null) {
      yield r'failure_count';
      yield serializers.serialize(
        object.failureCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.retryCount != null) {
      yield r'retry_count';
      yield serializers.serialize(
        object.retryCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.lastSuccessAt != null) {
      yield r'last_success_at';
      yield serializers.serialize(
        object.lastSuccessAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReadyJobs object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReadyJobsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'failure_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.failureCount = valueDes;
          break;
        case r'retry_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.retryCount = valueDes;
          break;
        case r'last_success_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastSuccessAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReadyJobs deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReadyJobsBuilder();
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


