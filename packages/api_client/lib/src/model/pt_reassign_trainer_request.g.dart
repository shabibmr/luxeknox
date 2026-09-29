// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_reassign_trainer_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtReassignTrainerRequest extends PtReassignTrainerRequest {
  @override
  final int trainerId;
  @override
  final Date effectiveDate;
  @override
  final String? reason;

  factory _$PtReassignTrainerRequest(
          [void Function(PtReassignTrainerRequestBuilder)? updates]) =>
      (PtReassignTrainerRequestBuilder()..update(updates))._build();

  _$PtReassignTrainerRequest._(
      {required this.trainerId, required this.effectiveDate, this.reason})
      : super._();
  @override
  PtReassignTrainerRequest rebuild(
          void Function(PtReassignTrainerRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtReassignTrainerRequestBuilder toBuilder() =>
      PtReassignTrainerRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtReassignTrainerRequest &&
        trainerId == other.trainerId &&
        effectiveDate == other.effectiveDate &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, effectiveDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtReassignTrainerRequest')
          ..add('trainerId', trainerId)
          ..add('effectiveDate', effectiveDate)
          ..add('reason', reason))
        .toString();
  }
}

class PtReassignTrainerRequestBuilder
    implements
        Builder<PtReassignTrainerRequest, PtReassignTrainerRequestBuilder> {
  _$PtReassignTrainerRequest? _$v;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  Date? _effectiveDate;
  Date? get effectiveDate => _$this._effectiveDate;
  set effectiveDate(Date? effectiveDate) =>
      _$this._effectiveDate = effectiveDate;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PtReassignTrainerRequestBuilder() {
    PtReassignTrainerRequest._defaults(this);
  }

  PtReassignTrainerRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trainerId = $v.trainerId;
      _effectiveDate = $v.effectiveDate;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtReassignTrainerRequest other) {
    _$v = other as _$PtReassignTrainerRequest;
  }

  @override
  void update(void Function(PtReassignTrainerRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtReassignTrainerRequest build() => _build();

  _$PtReassignTrainerRequest _build() {
    final _$result = _$v ??
        _$PtReassignTrainerRequest._(
          trainerId: BuiltValueNullFieldError.checkNotNull(
              trainerId, r'PtReassignTrainerRequest', 'trainerId'),
          effectiveDate: BuiltValueNullFieldError.checkNotNull(
              effectiveDate, r'PtReassignTrainerRequest', 'effectiveDate'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
