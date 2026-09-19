// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ErrorCode _$validationError = const ErrorCode._('validationError');
const ErrorCode _$unauthenticated = const ErrorCode._('unauthenticated');
const ErrorCode _$forbidden = const ErrorCode._('forbidden');
const ErrorCode _$notFound = const ErrorCode._('notFound');
const ErrorCode _$conflict = const ErrorCode._('conflict');
const ErrorCode _$businessRule = const ErrorCode._('businessRule');
const ErrorCode _$rateLimited = const ErrorCode._('rateLimited');

ErrorCode _$valueOf(String name) {
  switch (name) {
    case 'validationError':
      return _$validationError;
    case 'unauthenticated':
      return _$unauthenticated;
    case 'forbidden':
      return _$forbidden;
    case 'notFound':
      return _$notFound;
    case 'conflict':
      return _$conflict;
    case 'businessRule':
      return _$businessRule;
    case 'rateLimited':
      return _$rateLimited;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ErrorCode> _$values = BuiltSet<ErrorCode>(const <ErrorCode>[
  _$validationError,
  _$unauthenticated,
  _$forbidden,
  _$notFound,
  _$conflict,
  _$businessRule,
  _$rateLimited,
]);

class _$ErrorCodeMeta {
  const _$ErrorCodeMeta();
  ErrorCode get validationError => _$validationError;
  ErrorCode get unauthenticated => _$unauthenticated;
  ErrorCode get forbidden => _$forbidden;
  ErrorCode get notFound => _$notFound;
  ErrorCode get conflict => _$conflict;
  ErrorCode get businessRule => _$businessRule;
  ErrorCode get rateLimited => _$rateLimited;
  ErrorCode valueOf(String name) => _$valueOf(name);
  BuiltSet<ErrorCode> get values => _$values;
}

abstract class _$ErrorCodeMixin {
  // ignore: non_constant_identifier_names
  _$ErrorCodeMeta get ErrorCode => const _$ErrorCodeMeta();
}

Serializer<ErrorCode> _$errorCodeSerializer = _$ErrorCodeSerializer();

class _$ErrorCodeSerializer implements PrimitiveSerializer<ErrorCode> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'validationError': 'validation_error',
    'unauthenticated': 'unauthenticated',
    'forbidden': 'forbidden',
    'notFound': 'not_found',
    'conflict': 'conflict',
    'businessRule': 'business_rule',
    'rateLimited': 'rate_limited',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'validation_error': 'validationError',
    'unauthenticated': 'unauthenticated',
    'forbidden': 'forbidden',
    'not_found': 'notFound',
    'conflict': 'conflict',
    'business_rule': 'businessRule',
    'rate_limited': 'rateLimited',
  };

  @override
  final Iterable<Type> types = const <Type>[ErrorCode];
  @override
  final String wireName = 'ErrorCode';

  @override
  Object serialize(Serializers serializers, ErrorCode object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ErrorCode deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ErrorCode.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
