// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorBody extends ErrorBody {
  @override
  final ErrorCode code;
  @override
  final String message;
  @override
  final BuiltList<ErrorDetail> details;
  @override
  final String requestId;

  factory _$ErrorBody([void Function(ErrorBodyBuilder)? updates]) =>
      (ErrorBodyBuilder()..update(updates))._build();

  _$ErrorBody._(
      {required this.code,
      required this.message,
      required this.details,
      required this.requestId})
      : super._();
  @override
  ErrorBody rebuild(void Function(ErrorBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorBodyBuilder toBuilder() => ErrorBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorBody &&
        code == other.code &&
        message == other.message &&
        details == other.details &&
        requestId == other.requestId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorBody')
          ..add('code', code)
          ..add('message', message)
          ..add('details', details)
          ..add('requestId', requestId))
        .toString();
  }
}

class ErrorBodyBuilder implements Builder<ErrorBody, ErrorBodyBuilder> {
  _$ErrorBody? _$v;

  ErrorCode? _code;
  ErrorCode? get code => _$this._code;
  set code(ErrorCode? code) => _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ListBuilder<ErrorDetail>? _details;
  ListBuilder<ErrorDetail> get details =>
      _$this._details ??= ListBuilder<ErrorDetail>();
  set details(ListBuilder<ErrorDetail>? details) => _$this._details = details;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  ErrorBodyBuilder() {
    ErrorBody._defaults(this);
  }

  ErrorBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _message = $v.message;
      _details = $v.details.toBuilder();
      _requestId = $v.requestId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorBody other) {
    _$v = other as _$ErrorBody;
  }

  @override
  void update(void Function(ErrorBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorBody build() => _build();

  _$ErrorBody _build() {
    _$ErrorBody _$result;
    try {
      _$result = _$v ??
          _$ErrorBody._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ErrorBody', 'code'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'ErrorBody', 'message'),
            details: details.build(),
            requestId: BuiltValueNullFieldError.checkNotNull(
                requestId, r'ErrorBody', 'requestId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        details.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ErrorBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
