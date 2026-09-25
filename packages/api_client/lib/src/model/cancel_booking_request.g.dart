// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_booking_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancelBookingRequest extends CancelBookingRequest {
  @override
  final String? reason;

  factory _$CancelBookingRequest([
    void Function(CancelBookingRequestBuilder)? updates,
  ]) => (CancelBookingRequestBuilder()..update(updates))._build();

  _$CancelBookingRequest._({this.reason}) : super._();

  @override
  CancelBookingRequest rebuild(
    void Function(CancelBookingRequestBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CancelBookingRequestBuilder toBuilder() =>
      CancelBookingRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancelBookingRequest && reason == other.reason;
  }

  @override
  int get hashCode {
    var hash = 0;
    hash = $jc(hash, reason.hashCode);
    hash = $jf(hash);
    return hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CancelBookingRequest',
    )..add('reason', reason)).toString();
  }
}

class CancelBookingRequestBuilder
    implements Builder<CancelBookingRequest, CancelBookingRequestBuilder> {
  _$CancelBookingRequest? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CancelBookingRequestBuilder() {
    CancelBookingRequest._defaults(this);
  }

  CancelBookingRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancelBookingRequest other) {
    _$v = other as _$CancelBookingRequest;
  }

  @override
  void update(void Function(CancelBookingRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancelBookingRequest build() => _build();

  _$CancelBookingRequest _build() {
    final result = _$v ?? _$CancelBookingRequest._(reason: reason);
    replace(result);
    return result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
