//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/pt_grid_cell.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/pt_grid_trainer.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pt_schedule_grid.g.dart';

/// PtScheduleGrid
///
/// Properties:
/// * [memberId] 
/// * [gender] 
/// * [startDate] 
/// * [endDate] 
/// * [weekdays] 
/// * [hours] 
/// * [trainers] 
/// * [cells] 
@BuiltValue()
abstract class PtScheduleGrid implements Built<PtScheduleGrid, PtScheduleGridBuilder> {
  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  @BuiltValueField(wireName: r'gender')
  PtScheduleGridGenderEnum get gender;
  // enum genderEnum {  male,  female,  };

  @BuiltValueField(wireName: r'start_date')
  Date get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date get endDate;

  @BuiltValueField(wireName: r'weekdays')
  BuiltList<int> get weekdays;

  @BuiltValueField(wireName: r'hours')
  BuiltList<String> get hours;

  @BuiltValueField(wireName: r'trainers')
  BuiltList<PtGridTrainer> get trainers;

  @BuiltValueField(wireName: r'cells')
  BuiltList<PtGridCell> get cells;

  PtScheduleGrid._();

  factory PtScheduleGrid([void updates(PtScheduleGridBuilder b)]) = _$PtScheduleGrid;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PtScheduleGridBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PtScheduleGrid> get serializer => _$PtScheduleGridSerializer();
}

class _$PtScheduleGridSerializer implements PrimitiveSerializer<PtScheduleGrid> {
  @override
  final Iterable<Type> types = const [PtScheduleGrid, _$PtScheduleGrid];

  @override
  final String wireName = r'PtScheduleGrid';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PtScheduleGrid object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'gender';
    yield serializers.serialize(
      object.gender,
      specifiedType: const FullType(PtScheduleGridGenderEnum),
    );
    yield r'start_date';
    yield serializers.serialize(
      object.startDate,
      specifiedType: const FullType(Date),
    );
    yield r'end_date';
    yield serializers.serialize(
      object.endDate,
      specifiedType: const FullType(Date),
    );
    yield r'weekdays';
    yield serializers.serialize(
      object.weekdays,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'trainers';
    yield serializers.serialize(
      object.trainers,
      specifiedType: const FullType(BuiltList, [FullType(PtGridTrainer)]),
    );
    yield r'cells';
    yield serializers.serialize(
      object.cells,
      specifiedType: const FullType(BuiltList, [FullType(PtGridCell)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PtScheduleGrid object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PtScheduleGridBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'gender':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PtScheduleGridGenderEnum),
          ) as PtScheduleGridGenderEnum;
          result.gender = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startDate = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endDate = valueDes;
          break;
        case r'weekdays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.weekdays.replace(valueDes);
          break;
        case r'hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.hours.replace(valueDes);
          break;
        case r'trainers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PtGridTrainer)]),
          ) as BuiltList<PtGridTrainer>;
          result.trainers.replace(valueDes);
          break;
        case r'cells':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PtGridCell)]),
          ) as BuiltList<PtGridCell>;
          result.cells.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PtScheduleGrid deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PtScheduleGridBuilder();
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


class PtScheduleGridGenderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'male')
  static const PtScheduleGridGenderEnum male = _$ptScheduleGridGenderEnum_male;
  @BuiltValueEnumConst(wireName: r'female')
  static const PtScheduleGridGenderEnum female = _$ptScheduleGridGenderEnum_female;

  static Serializer<PtScheduleGridGenderEnum> get serializer => _$ptScheduleGridGenderEnumSerializer;

  const PtScheduleGridGenderEnum._(String name): super(name);

  static BuiltSet<PtScheduleGridGenderEnum> get values => _$ptScheduleGridGenderEnumValues;
  static PtScheduleGridGenderEnum valueOf(String name) => _$ptScheduleGridGenderEnumValueOf(name);
}

