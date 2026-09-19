// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_attendance_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MarkAttendanceRequest extends MarkAttendanceRequest {
  @override
  final bool attended;

  factory _$MarkAttendanceRequest(
          [void Function(MarkAttendanceRequestBuilder)? updates]) =>
      (MarkAttendanceRequestBuilder()..update(updates))._build();

  _$MarkAttendanceRequest._({required this.attended}) : super._();
  @override
  MarkAttendanceRequest rebuild(
          void Function(MarkAttendanceRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MarkAttendanceRequestBuilder toBuilder() =>
      MarkAttendanceRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarkAttendanceRequest && attended == other.attended;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, attended.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MarkAttendanceRequest')
          ..add('attended', attended))
        .toString();
  }
}

class MarkAttendanceRequestBuilder
    implements Builder<MarkAttendanceRequest, MarkAttendanceRequestBuilder> {
  _$MarkAttendanceRequest? _$v;

  bool? _attended;
  bool? get attended => _$this._attended;
  set attended(bool? attended) => _$this._attended = attended;

  MarkAttendanceRequestBuilder() {
    MarkAttendanceRequest._defaults(this);
  }

  MarkAttendanceRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _attended = $v.attended;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MarkAttendanceRequest other) {
    _$v = other as _$MarkAttendanceRequest;
  }

  @override
  void update(void Function(MarkAttendanceRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MarkAttendanceRequest build() => _build();

  _$MarkAttendanceRequest _build() {
    final _$result = _$v ??
        _$MarkAttendanceRequest._(
          attended: BuiltValueNullFieldError.checkNotNull(
              attended, r'MarkAttendanceRequest', 'attended'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
