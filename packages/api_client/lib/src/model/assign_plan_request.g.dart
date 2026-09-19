// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_plan_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssignPlanRequest extends AssignPlanRequest {
  @override
  final int memberId;

  factory _$AssignPlanRequest(
          [void Function(AssignPlanRequestBuilder)? updates]) =>
      (AssignPlanRequestBuilder()..update(updates))._build();

  _$AssignPlanRequest._({required this.memberId}) : super._();
  @override
  AssignPlanRequest rebuild(void Function(AssignPlanRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignPlanRequestBuilder toBuilder() =>
      AssignPlanRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignPlanRequest && memberId == other.memberId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignPlanRequest')
          ..add('memberId', memberId))
        .toString();
  }
}

class AssignPlanRequestBuilder
    implements Builder<AssignPlanRequest, AssignPlanRequestBuilder> {
  _$AssignPlanRequest? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  AssignPlanRequestBuilder() {
    AssignPlanRequest._defaults(this);
  }

  AssignPlanRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignPlanRequest other) {
    _$v = other as _$AssignPlanRequest;
  }

  @override
  void update(void Function(AssignPlanRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignPlanRequest build() => _build();

  _$AssignPlanRequest _build() {
    final _$result = _$v ??
        _$AssignPlanRequest._(
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'AssignPlanRequest', 'memberId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
