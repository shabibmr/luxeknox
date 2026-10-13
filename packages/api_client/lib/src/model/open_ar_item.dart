//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'open_ar_item.g.dart';

/// OpenArItem
///
/// Properties:
/// * [paymentId] 
/// * [invoiceNumber] 
/// * [invoiceDate] 
/// * [memberId] 
/// * [totalAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [amountPaid] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [openAmount] - DECIMAL(12,2) as a two-decimal string. Never a JSON number.
/// * [status] 
@BuiltValue()
abstract class OpenArItem implements Built<OpenArItem, OpenArItemBuilder> {
  @BuiltValueField(wireName: r'payment_id')
  int get paymentId;

  @BuiltValueField(wireName: r'invoice_number')
  String get invoiceNumber;

  @BuiltValueField(wireName: r'invoice_date')
  Date get invoiceDate;

  @BuiltValueField(wireName: r'member_id')
  int get memberId;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'total_amount')
  String get totalAmount;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'amount_paid')
  String get amountPaid;

  /// DECIMAL(12,2) as a two-decimal string. Never a JSON number.
  @BuiltValueField(wireName: r'open_amount')
  String get openAmount;

  @BuiltValueField(wireName: r'status')
  String get status;

  OpenArItem._();

  factory OpenArItem([void updates(OpenArItemBuilder b)]) = _$OpenArItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OpenArItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OpenArItem> get serializer => _$OpenArItemSerializer();
}

class _$OpenArItemSerializer implements PrimitiveSerializer<OpenArItem> {
  @override
  final Iterable<Type> types = const [OpenArItem, _$OpenArItem];

  @override
  final String wireName = r'OpenArItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OpenArItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payment_id';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(int),
    );
    yield r'invoice_number';
    yield serializers.serialize(
      object.invoiceNumber,
      specifiedType: const FullType(String),
    );
    yield r'invoice_date';
    yield serializers.serialize(
      object.invoiceDate,
      specifiedType: const FullType(Date),
    );
    yield r'member_id';
    yield serializers.serialize(
      object.memberId,
      specifiedType: const FullType(int),
    );
    yield r'total_amount';
    yield serializers.serialize(
      object.totalAmount,
      specifiedType: const FullType(String),
    );
    yield r'amount_paid';
    yield serializers.serialize(
      object.amountPaid,
      specifiedType: const FullType(String),
    );
    yield r'open_amount';
    yield serializers.serialize(
      object.openAmount,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OpenArItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OpenArItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payment_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.paymentId = valueDes;
          break;
        case r'invoice_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceNumber = valueDes;
          break;
        case r'invoice_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.invoiceDate = valueDes;
          break;
        case r'member_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberId = valueDes;
          break;
        case r'total_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.totalAmount = valueDes;
          break;
        case r'amount_paid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amountPaid = valueDes;
          break;
        case r'open_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.openAmount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OpenArItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OpenArItemBuilder();
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


