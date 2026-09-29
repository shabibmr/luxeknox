//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_grid_cell.g.dart';

/// PtGridCell
///
/// Properties:
/// * [trainerId] 
/// * [slotStart] 
/// * [status] 
/// * [occupiedBy] 
/// * [conflictDates] 
@BuiltValue()
abstract class PtGridCell implements Built<PtGridCell, PtGridCellBuilder> {
  @BuiltValueField(wireName: r'trainer_id')
  int get trainerId;

  @BuiltValueField(wireName: r'slot_start')
  String get slotStart;

  @BuiltValueField(wireName: r'status')
  PtGridCellStatusEnum get status;
  // enum statusEnum {  free,  occupied,  unavailable,  };

  @BuiltValueField(wireName: r'occupied_by')
  String? get occupiedBy;

  @BuiltValueField(wireName: r'conflict_dates')
  BuiltList<Date> get conflictDates;

  PtGridCell._();

  factory PtGridCell([void updates(PtGridCellBuilder b)]) = _$PtGridCell;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtGridCellBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtGridCell> get serializer => _$PtGridCellSerializer();
}

class _$PtGridCellSerializer implements PrimitiveSerializer<PtGridCell> {
  @override
  final Iterable<Type> types = const [PtGridCell, _$PtGridCell];

  @override
  final String wireName = r'PtGridCell';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtGridCell object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trainer_id';
    yield serializers.serialize(
      object.trainerId,
      specifiedType: const FullType(int),
    );
    yield r'slot_start';
    yield serializers.serialize(
      object.slotStart,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PtGridCellStatusEnum),
    );
    if (object.occupiedBy != null) {
      yield r'occupied_by';
      yield serializers.serialize(
        object.occupiedBy,
        specifiedType: const FullType(String),
      );
    }
    yield r'conflict_dates';
    yield serializers.serialize(
      object.conflictDates,
      specifiedType: const FullType(BuiltList, [FullType(Date)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtGridCell object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtGridCellBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trainer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.trainerId = valueDes;
          break;
        case r'slot_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slotStart = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PtGridCellStatusEnum),
          ) as PtGridCellStatusEnum;
          result.status = valueDes;
          break;
        case r'occupied_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.occupiedBy = valueDes;
          break;
        case r'conflict_dates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Date)]),
          ) as BuiltList<Date>;
          result.conflictDates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtGridCell deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtGridCellBuilder();
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


class PtGridCellStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'free')
  static const PtGridCellStatusEnum free = _$ptGridCellStatusEnum_free;
  @BuiltValueEnumConst(wireName: r'occupied')
  static const PtGridCellStatusEnum occupied = _$ptGridCellStatusEnum_occupied;
  @BuiltValueEnumConst(wireName: r'unavailable')
  static const PtGridCellStatusEnum unavailable = _$ptGridCellStatusEnum_unavailable;

  static Serializer<PtGridCellStatusEnum> get serializer => _$ptGridCellStatusEnumSerializer;

  const PtGridCellStatusEnum._(String name): super(name);

  static BuiltSet<PtGridCellStatusEnum> get values => _$ptGridCellStatusEnumValues;
  static PtGridCellStatusEnum valueOf(String name) => _$ptGridCellStatusEnumValueOf(name);
}

