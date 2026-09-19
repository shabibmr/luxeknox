//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_settings.g.dart';

/// PublicSettings
///
/// Properties:
/// * [timezone] 
/// * [currency] 
/// * [dateFormat] 
/// * [defaultPageSize] 
/// * [operatingHours] 
/// * [cancellationCutoffMinutes] 
@BuiltValue()
abstract class PublicSettings implements Built<PublicSettings, PublicSettingsBuilder> {
  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'date_format')
  String? get dateFormat;

  @BuiltValueField(wireName: r'default_page_size')
  int? get defaultPageSize;

  @BuiltValueField(wireName: r'operating_hours')
  String? get operatingHours;

  @BuiltValueField(wireName: r'cancellation_cutoff_minutes')
  int? get cancellationCutoffMinutes;

  PublicSettings._();

  factory PublicSettings([void updates(PublicSettingsBuilder b)]) = _$PublicSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicSettings> get serializer => _$PublicSettingsSerializer();
}

class _$PublicSettingsSerializer implements PrimitiveSerializer<PublicSettings> {
  @override
  final Iterable<Type> types = const [PublicSettings, _$PublicSettings];

  @override
  final String wireName = r'PublicSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    if (object.dateFormat != null) {
      yield r'date_format';
      yield serializers.serialize(
        object.dateFormat,
        specifiedType: const FullType(String),
      );
    }
    if (object.defaultPageSize != null) {
      yield r'default_page_size';
      yield serializers.serialize(
        object.defaultPageSize,
        specifiedType: const FullType(int),
      );
    }
    if (object.operatingHours != null) {
      yield r'operating_hours';
      yield serializers.serialize(
        object.operatingHours,
        specifiedType: const FullType(String),
      );
    }
    if (object.cancellationCutoffMinutes != null) {
      yield r'cancellation_cutoff_minutes';
      yield serializers.serialize(
        object.cancellationCutoffMinutes,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        case r'date_format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dateFormat = valueDes;
          break;
        case r'default_page_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.defaultPageSize = valueDes;
          break;
        case r'operating_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.operatingHours = valueDes;
          break;
        case r'cancellation_cutoff_minutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.cancellationCutoffMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicSettingsBuilder();
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


