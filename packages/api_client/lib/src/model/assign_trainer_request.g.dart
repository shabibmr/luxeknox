// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_trainer_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssignTrainerRequest extends AssignTrainerRequest {
  @override
  final int trainerId;
  @override
  final bool? overrideCapacity;
  @override
  final String? reason;

  factory _$AssignTrainerRequest(
          [void Function(AssignTrainerRequestBuilder)? updates]) =>
      (AssignTrainerRequestBuilder()..update(updates))._build();

  _$AssignTrainerRequest._(
      {required this.trainerId, this.overrideCapacity, this.reason})
      : super._();
  @override
  AssignTrainerRequest rebuild(
          void Function(AssignTrainerRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignTrainerRequestBuilder toBuilder() =>
      AssignTrainerRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignTrainerRequest &&
        trainerId == other.trainerId &&
        overrideCapacity == other.overrideCapacity &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, overrideCapacity.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignTrainerRequest')
          ..add('trainerId', trainerId)
          ..add('overrideCapacity', overrideCapacity)
          ..add('reason', reason))
        .toString();
  }
}

class AssignTrainerRequestBuilder
    implements Builder<AssignTrainerRequest, AssignTrainerRequestBuilder> {
  _$AssignTrainerRequest? _$v;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  bool? _overrideCapacity;
  bool? get overrideCapacity => _$this._overrideCapacity;
  set overrideCapacity(bool? overrideCapacity) =>
      _$this._overrideCapacity = overrideCapacity;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AssignTrainerRequestBuilder() {
    AssignTrainerRequest._defaults(this);
  }

  AssignTrainerRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trainerId = $v.trainerId;
      _overrideCapacity = $v.overrideCapacity;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignTrainerRequest other) {
    _$v = other as _$AssignTrainerRequest;
  }

  @override
  void update(void Function(AssignTrainerRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignTrainerRequest build() => _build();

  _$AssignTrainerRequest _build() {
    final _$result = _$v ??
        _$AssignTrainerRequest._(
          trainerId: BuiltValueNullFieldError.checkNotNull(
              trainerId, r'AssignTrainerRequest', 'trainerId'),
          overrideCapacity: overrideCapacity,
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
