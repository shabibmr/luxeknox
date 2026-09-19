//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'facility_write.g.dart';

/// FacilityWrite
///
/// Properties:
/// * [name] 
/// * [capacity] 
/// * [locationDetails] 
/// * [isActive] 
@BuiltValue()
abstract class FacilityWrite implements Built<FacilityWrite, FacilityWriteBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'capacity')
  int? get capacity;

  @BuiltValueField(wireName: r'location_details')
  String? get locationDetails;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  FacilityWrite._();

  factory FacilityWrite([void updates(FacilityWriteBuilder b)]) = _$FacilityWrite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FacilityWriteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FacilityWrite> get serializer => _$FacilityWriteSerializer();
}

class _$FacilityWriteSerializer implements PrimitiveSerializer<FacilityWrite> {
  @override
  final Iterable<Type> types = const [FacilityWrite, _$FacilityWrite];

  @override
  final String wireName = r'FacilityWrite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FacilityWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.capacity != null) {
      yield r'capacity';
      yield serializers.serialize(
        object.capacity,
        specifiedType: const FullType(int),
      );
    }
    if (object.locationDetails != null) {
      yield r'location_details';
      yield serializers.serialize(
        object.locationDetails,
        specifiedType: const FullType(String),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FacilityWrite object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FacilityWriteBuilder result,
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
        case r'capacity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.capacity = valueDes;
          break;
        case r'location_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationDetails = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FacilityWrite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FacilityWriteBuilder();
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


