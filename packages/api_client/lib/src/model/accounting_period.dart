//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/draft_document_counts.dart';
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'accounting_period.g.dart';

/// AccountingPeriod
///
/// Properties:
/// * [id] 
/// * [fiscalYearId] 
/// * [startsOn] 
/// * [endsOn] 
/// * [status] 
/// * [closedAt] - UTC ISO-8601
/// * [closedByUserId] 
/// * [draftDocumentCounts] 
@BuiltValue()
abstract class AccountingPeriod implements Built<AccountingPeriod, AccountingPeriodBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'fiscal_year_id')
  int get fiscalYearId;

  @BuiltValueField(wireName: r'starts_on')
  Date get startsOn;

  @BuiltValueField(wireName: r'ends_on')
  Date get endsOn;

  @BuiltValueField(wireName: r'status')
  AccountingPeriodStatusEnum get status;
  // enum statusEnum {  open,  locked,  };

  /// UTC ISO-8601
  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  @BuiltValueField(wireName: r'closed_by_user_id')
  int? get closedByUserId;

  @BuiltValueField(wireName: r'draft_document_counts')
  DraftDocumentCounts? get draftDocumentCounts;

  AccountingPeriod._();

  factory AccountingPeriod([void updates(AccountingPeriodBuilder b)]) = _$AccountingPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountingPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountingPeriod> get serializer => _$AccountingPeriodSerializer();
}

class _$AccountingPeriodSerializer implements PrimitiveSerializer<AccountingPeriod> {
  @override
  final Iterable<Type> types = const [AccountingPeriod, _$AccountingPeriod];

  @override
  final String wireName = r'AccountingPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountingPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'fiscal_year_id';
    yield serializers.serialize(
      object.fiscalYearId,
      specifiedType: const FullType(int),
    );
    yield r'starts_on';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(Date),
    );
    yield r'ends_on';
    yield serializers.serialize(
      object.endsOn,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AccountingPeriodStatusEnum),
    );
    if (object.closedAt != null) {
      yield r'closed_at';
      yield serializers.serialize(
        object.closedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.closedByUserId != null) {
      yield r'closed_by_user_id';
      yield serializers.serialize(
        object.closedByUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.draftDocumentCounts != null) {
      yield r'draft_document_counts';
      yield serializers.serialize(
        object.draftDocumentCounts,
        specifiedType: const FullType(DraftDocumentCounts),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountingPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountingPeriodBuilder result,
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
        case r'fiscal_year_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fiscalYearId = valueDes;
          break;
        case r'starts_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startsOn = valueDes;
          break;
        case r'ends_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endsOn = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountingPeriodStatusEnum),
          ) as AccountingPeriodStatusEnum;
          result.status = valueDes;
          break;
        case r'closed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'closed_by_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.closedByUserId = valueDes;
          break;
        case r'draft_document_counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DraftDocumentCounts),
          ) as DraftDocumentCounts?;
          if (valueDes == null) continue;
          result.draftDocumentCounts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountingPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountingPeriodBuilder();
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


class AccountingPeriodStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'open')
  static const AccountingPeriodStatusEnum open = _$accountingPeriodStatusEnum_open;
  @BuiltValueEnumConst(wireName: r'locked')
  static const AccountingPeriodStatusEnum locked = _$accountingPeriodStatusEnum_locked;

  static Serializer<AccountingPeriodStatusEnum> get serializer => _$accountingPeriodStatusEnumSerializer;

  const AccountingPeriodStatusEnum._(String name): super(name);

  static BuiltSet<AccountingPeriodStatusEnum> get values => _$accountingPeriodStatusEnumValues;
  static AccountingPeriodStatusEnum valueOf(String name) => _$accountingPeriodStatusEnumValueOf(name);
}

