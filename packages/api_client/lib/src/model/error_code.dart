//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'error_code.g.dart';

class ErrorCode extends EnumClass {

  @BuiltValueEnumConst(wireName: r'validation_error')
  static const ErrorCode validationError = _$validationError;
  @BuiltValueEnumConst(wireName: r'unauthenticated')
  static const ErrorCode unauthenticated = _$unauthenticated;
  @BuiltValueEnumConst(wireName: r'forbidden')
  static const ErrorCode forbidden = _$forbidden;
  @BuiltValueEnumConst(wireName: r'not_found')
  static const ErrorCode notFound = _$notFound;
  @BuiltValueEnumConst(wireName: r'conflict')
  static const ErrorCode conflict = _$conflict;
  @BuiltValueEnumConst(wireName: r'business_rule')
  static const ErrorCode businessRule = _$businessRule;
  @BuiltValueEnumConst(wireName: r'rate_limited')
  static const ErrorCode rateLimited = _$rateLimited;

  static Serializer<ErrorCode> get serializer => _$errorCodeSerializer;

  const ErrorCode._(String name): super(name);

  static BuiltSet<ErrorCode> get values => _$values;
  static ErrorCode valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ErrorCodeMixin = Object with _$ErrorCodeMixin;

