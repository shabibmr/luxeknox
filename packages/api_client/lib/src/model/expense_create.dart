//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/date.dart';
import 'package:api_client/src/model/expense_line_create.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expense_create.g.dart';

/// ExpenseCreate
///
/// Properties:
/// * [expenseDate] 
/// * [paidFromAccountId] 
/// * [vendorId] 
/// * [payeeName] 
/// * [lines] 
@BuiltValue()
abstract class ExpenseCreate implements Built<ExpenseCreate, ExpenseCreateBuilder> {
  @BuiltValueField(wireName: r'expense_date')
  Date get expenseDate;

  @BuiltValueField(wireName: r'paid_from_account_id')
  int? get paidFromAccountId;

  @BuiltValueField(wireName: r'vendor_id')
  int? get vendorId;

  @BuiltValueField(wireName: r'payee_name')
  String? get payeeName;

  @BuiltValueField(wireName: r'lines')
  BuiltList<ExpenseLineCreate> get lines;

  ExpenseCreate._();

  factory ExpenseCreate([void updates(ExpenseCreateBuilder b)]) = _$ExpenseCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExpenseCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExpenseCreate> get serializer => _$ExpenseCreateSerializer();
}

class _$ExpenseCreateSerializer implements PrimitiveSerializer<ExpenseCreate> {
  @override
  final Iterable<Type> types = const [ExpenseCreate, _$ExpenseCreate];

  @override
  final String wireName = r'ExpenseCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExpenseCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expense_date';
    yield serializers.serialize(
      object.expenseDate,
      specifiedType: const FullType(Date),
    );
    if (object.paidFromAccountId != null) {
      yield r'paid_from_account_id';
      yield serializers.serialize(
        object.paidFromAccountId,
        specifiedType: const FullType(int),
      );
    }
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType(int),
      );
    }
    if (object.payeeName != null) {
      yield r'payee_name';
      yield serializers.serialize(
        object.payeeName,
        specifiedType: const FullType(String),
      );
    }
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(ExpenseLineCreate)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ExpenseCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ExpenseCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expense_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.expenseDate = valueDes;
          break;
        case r'paid_from_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.paidFromAccountId = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        case r'payee_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.payeeName = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ExpenseLineCreate)]),
          ) as BuiltList<ExpenseLineCreate>;
          result.lines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExpenseCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExpenseCreateBuilder();
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


