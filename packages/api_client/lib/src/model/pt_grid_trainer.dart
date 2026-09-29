//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_grid_trainer.g.dart';

/// PtGridTrainer
///
/// Properties:
/// * [id] 
/// * [name] 
@BuiltValue()
abstract class PtGridTrainer implements Built<PtGridTrainer, PtGridTrainerBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  PtGridTrainer._();

  factory PtGridTrainer([void updates(PtGridTrainerBuilder b)]) = _$PtGridTrainer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtGridTrainerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtGridTrainer> get serializer => _$PtGridTrainerSerializer();
}

class _$PtGridTrainerSerializer implements PrimitiveSerializer<PtGridTrainer> {
  @override
  final Iterable<Type> types = const [PtGridTrainer, _$PtGridTrainer];

  @override
  final String wireName = r'PtGridTrainer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtGridTrainer object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PtGridTrainer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtGridTrainerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtGridTrainer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtGridTrainerBuilder();
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


