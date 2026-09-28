//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancel_request.g.dart';

/// CancelRequest
///
/// Properties:
/// * [reason] 
/// * [rowVersion] 
/// * [cancelSeries] 
@BuiltValue()
abstract class CancelRequest implements Built<CancelRequest, CancelRequestBuilder> {
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'row_version')
  int? get rowVersion;

  @BuiltValueField(wireName: r'cancel_series')
  bool? get cancelSeries;

  CancelRequest._();

  factory CancelRequest([void updates(CancelRequestBuilder b)]) = _$CancelRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancelRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancelRequest> get serializer => _$CancelRequestSerializer();
}

class _$CancelRequestSerializer implements PrimitiveSerializer<CancelRequest> {
  @override
  final Iterable<Type> types = const [CancelRequest, _$CancelRequest];

  @override
  final String wireName = r'CancelRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.rowVersion != null) {
      yield r'row_version';
      yield serializers.serialize(
        object.rowVersion,
        specifiedType: const FullType(int),
      );
    }
    if (object.cancelSeries != null) {
      yield r'cancel_series';
      yield serializers.serialize(
        object.cancelSeries,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CancelRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancelRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'row_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.rowVersion = valueDes;
          break;
        case r'cancel_series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.cancelSeries = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancelRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancelRequestBuilder();
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


