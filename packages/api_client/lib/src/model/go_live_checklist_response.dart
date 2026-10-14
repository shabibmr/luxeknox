//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/go_live_payment_method.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/go_live_unearned_match.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/go_live_tax_match.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'go_live_checklist_response.g.dart';

/// GoLiveChecklistResponse
///
/// Properties:
/// * [goLiveDate] 
/// * [postingEnabled] 
/// * [canEnable] 
/// * [failingReasons] 
/// * [openingJournalFound] 
/// * [openingJournalMatches] 
/// * [unearnedMembership] 
/// * [unearnedPt] 
/// * [taxMatch] 
/// * [paymentMethods] 
@BuiltValue()
abstract class GoLiveChecklistResponse implements Built<GoLiveChecklistResponse, GoLiveChecklistResponseBuilder> {
  @BuiltValueField(wireName: r'go_live_date')
  Date get goLiveDate;

  @BuiltValueField(wireName: r'posting_enabled')
  bool get postingEnabled;

  @BuiltValueField(wireName: r'can_enable')
  bool get canEnable;

  @BuiltValueField(wireName: r'failing_reasons')
  BuiltList<String> get failingReasons;

  @BuiltValueField(wireName: r'opening_journal_found')
  bool get openingJournalFound;

  @BuiltValueField(wireName: r'opening_journal_matches')
  bool get openingJournalMatches;

  @BuiltValueField(wireName: r'unearned_membership')
  GoLiveUnearnedMatch get unearnedMembership;

  @BuiltValueField(wireName: r'unearned_pt')
  GoLiveUnearnedMatch get unearnedPt;

  @BuiltValueField(wireName: r'tax_match')
  GoLiveTaxMatch get taxMatch;

  @BuiltValueField(wireName: r'payment_methods')
  BuiltList<GoLivePaymentMethod> get paymentMethods;

  GoLiveChecklistResponse._();

  factory GoLiveChecklistResponse([void updates(GoLiveChecklistResponseBuilder b)]) = _$GoLiveChecklistResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoLiveChecklistResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoLiveChecklistResponse> get serializer => _$GoLiveChecklistResponseSerializer();
}

class _$GoLiveChecklistResponseSerializer implements PrimitiveSerializer<GoLiveChecklistResponse> {
  @override
  final Iterable<Type> types = const [GoLiveChecklistResponse, _$GoLiveChecklistResponse];

  @override
  final String wireName = r'GoLiveChecklistResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoLiveChecklistResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'go_live_date';
    yield serializers.serialize(
      object.goLiveDate,
      specifiedType: const FullType(Date),
    );
    yield r'posting_enabled';
    yield serializers.serialize(
      object.postingEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'can_enable';
    yield serializers.serialize(
      object.canEnable,
      specifiedType: const FullType(bool),
    );
    yield r'failing_reasons';
    yield serializers.serialize(
      object.failingReasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'opening_journal_found';
    yield serializers.serialize(
      object.openingJournalFound,
      specifiedType: const FullType(bool),
    );
    yield r'opening_journal_matches';
    yield serializers.serialize(
      object.openingJournalMatches,
      specifiedType: const FullType(bool),
    );
    yield r'unearned_membership';
    yield serializers.serialize(
      object.unearnedMembership,
      specifiedType: const FullType(GoLiveUnearnedMatch),
    );
    yield r'unearned_pt';
    yield serializers.serialize(
      object.unearnedPt,
      specifiedType: const FullType(GoLiveUnearnedMatch),
    );
    yield r'tax_match';
    yield serializers.serialize(
      object.taxMatch,
      specifiedType: const FullType(GoLiveTaxMatch),
    );
    yield r'payment_methods';
    yield serializers.serialize(
      object.paymentMethods,
      specifiedType: const FullType(BuiltList, [FullType(GoLivePaymentMethod)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoLiveChecklistResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoLiveChecklistResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'go_live_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.goLiveDate = valueDes;
          break;
        case r'posting_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.postingEnabled = valueDes;
          break;
        case r'can_enable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canEnable = valueDes;
          break;
        case r'failing_reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.failingReasons.replace(valueDes);
          break;
        case r'opening_journal_found':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.openingJournalFound = valueDes;
          break;
        case r'opening_journal_matches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.openingJournalMatches = valueDes;
          break;
        case r'unearned_membership':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoLiveUnearnedMatch),
          ) as GoLiveUnearnedMatch;
          result.unearnedMembership.replace(valueDes);
          break;
        case r'unearned_pt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoLiveUnearnedMatch),
          ) as GoLiveUnearnedMatch;
          result.unearnedPt.replace(valueDes);
          break;
        case r'tax_match':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoLiveTaxMatch),
          ) as GoLiveTaxMatch;
          result.taxMatch.replace(valueDes);
          break;
        case r'payment_methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GoLivePaymentMethod)]),
          ) as BuiltList<GoLivePaymentMethod>;
          result.paymentMethods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoLiveChecklistResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoLiveChecklistResponseBuilder();
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


