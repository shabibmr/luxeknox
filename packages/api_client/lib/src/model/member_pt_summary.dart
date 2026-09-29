//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/pt_subscription.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_pt_summary.g.dart';

/// MemberPtSummary
///
/// Properties:
/// * [current] 
/// * [history] 
/// * [trainerAccess] - Set only when the caller is a trainer. read_only once the caller's PT with the member has ended.
@BuiltValue()
abstract class MemberPtSummary implements Built<MemberPtSummary, MemberPtSummaryBuilder> {
  @BuiltValueField(wireName: r'current')
  PtSubscription? get current;

  @BuiltValueField(wireName: r'history')
  BuiltList<PtSubscription> get history;

  /// Set only when the caller is a trainer. read_only once the caller's PT with the member has ended.
  @BuiltValueField(wireName: r'trainer_access')
  MemberPtSummaryTrainerAccessEnum? get trainerAccess;
  // enum trainerAccessEnum {  full,  read_only,  };

  MemberPtSummary._();

  factory MemberPtSummary([void updates(MemberPtSummaryBuilder b)]) = _$MemberPtSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberPtSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberPtSummary> get serializer => _$MemberPtSummarySerializer();
}

class _$MemberPtSummarySerializer implements PrimitiveSerializer<MemberPtSummary> {
  @override
  final Iterable<Type> types = const [MemberPtSummary, _$MemberPtSummary];

  @override
  final String wireName = r'MemberPtSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberPtSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.current != null) {
      yield r'current';
      yield serializers.serialize(
        object.current,
        specifiedType: const FullType(PtSubscription),
      );
    }
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [FullType(PtSubscription)]),
    );
    if (object.trainerAccess != null) {
      yield r'trainer_access';
      yield serializers.serialize(
        object.trainerAccess,
        specifiedType: const FullType(MemberPtSummaryTrainerAccessEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberPtSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberPtSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PtSubscription),
          ) as PtSubscription?;
          if (valueDes == null) continue;
          result.current.replace(valueDes);
          break;
        case r'history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PtSubscription)]),
          ) as BuiltList<PtSubscription>;
          result.history.replace(valueDes);
          break;
        case r'trainer_access':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MemberPtSummaryTrainerAccessEnum),
          ) as MemberPtSummaryTrainerAccessEnum?;
          if (valueDes == null) continue;
          result.trainerAccess = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberPtSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberPtSummaryBuilder();
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


/// Set only when the caller is a trainer. read_only once the caller's PT with the member has ended.
class MemberPtSummaryTrainerAccessEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'full')
  static const MemberPtSummaryTrainerAccessEnum full = _$memberPtSummaryTrainerAccessEnum_full;
  @BuiltValueEnumConst(wireName: r'read_only')
  static const MemberPtSummaryTrainerAccessEnum readOnly = _$memberPtSummaryTrainerAccessEnum_readOnly;

  static Serializer<MemberPtSummaryTrainerAccessEnum> get serializer => _$memberPtSummaryTrainerAccessEnumSerializer;

  const MemberPtSummaryTrainerAccessEnum._(String name): super(name);

  static BuiltSet<MemberPtSummaryTrainerAccessEnum> get values => _$memberPtSummaryTrainerAccessEnumValues;
  static MemberPtSummaryTrainerAccessEnum valueOf(String name) => _$memberPtSummaryTrainerAccessEnumValueOf(name);
}

