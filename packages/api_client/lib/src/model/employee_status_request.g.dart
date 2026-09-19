// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_status_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmployeeStatusRequest extends EmployeeStatusRequest {
  @override
  final EmployeeStatus status;

  factory _$EmployeeStatusRequest(
          [void Function(EmployeeStatusRequestBuilder)? updates]) =>
      (EmployeeStatusRequestBuilder()..update(updates))._build();

  _$EmployeeStatusRequest._({required this.status}) : super._();
  @override
  EmployeeStatusRequest rebuild(
          void Function(EmployeeStatusRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmployeeStatusRequestBuilder toBuilder() =>
      EmployeeStatusRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmployeeStatusRequest && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmployeeStatusRequest')
          ..add('status', status))
        .toString();
  }
}

class EmployeeStatusRequestBuilder
    implements Builder<EmployeeStatusRequest, EmployeeStatusRequestBuilder> {
  _$EmployeeStatusRequest? _$v;

  EmployeeStatus? _status;
  EmployeeStatus? get status => _$this._status;
  set status(EmployeeStatus? status) => _$this._status = status;

  EmployeeStatusRequestBuilder() {
    EmployeeStatusRequest._defaults(this);
  }

  EmployeeStatusRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmployeeStatusRequest other) {
    _$v = other as _$EmployeeStatusRequest;
  }

  @override
  void update(void Function(EmployeeStatusRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmployeeStatusRequest build() => _build();

  _$EmployeeStatusRequest _build() {
    final _$result = _$v ??
        _$EmployeeStatusRequest._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'EmployeeStatusRequest', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
