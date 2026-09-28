// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready_jobs.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReadyJobs extends ReadyJobs {
  @override
  final int? failureCount;
  @override
  final int? retryCount;
  @override
  final DateTime? lastSuccessAt;

  factory _$ReadyJobs([void Function(ReadyJobsBuilder)? updates]) =>
      (ReadyJobsBuilder()..update(updates))._build();

  _$ReadyJobs._({this.failureCount, this.retryCount, this.lastSuccessAt})
      : super._();
  @override
  ReadyJobs rebuild(void Function(ReadyJobsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadyJobsBuilder toBuilder() => ReadyJobsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadyJobs &&
        failureCount == other.failureCount &&
        retryCount == other.retryCount &&
        lastSuccessAt == other.lastSuccessAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, failureCount.hashCode);
    _$hash = $jc(_$hash, retryCount.hashCode);
    _$hash = $jc(_$hash, lastSuccessAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadyJobs')
          ..add('failureCount', failureCount)
          ..add('retryCount', retryCount)
          ..add('lastSuccessAt', lastSuccessAt))
        .toString();
  }
}

class ReadyJobsBuilder implements Builder<ReadyJobs, ReadyJobsBuilder> {
  _$ReadyJobs? _$v;

  int? _failureCount;
  int? get failureCount => _$this._failureCount;
  set failureCount(int? failureCount) => _$this._failureCount = failureCount;

  int? _retryCount;
  int? get retryCount => _$this._retryCount;
  set retryCount(int? retryCount) => _$this._retryCount = retryCount;

  DateTime? _lastSuccessAt;
  DateTime? get lastSuccessAt => _$this._lastSuccessAt;
  set lastSuccessAt(DateTime? lastSuccessAt) =>
      _$this._lastSuccessAt = lastSuccessAt;

  ReadyJobsBuilder() {
    ReadyJobs._defaults(this);
  }

  ReadyJobsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _failureCount = $v.failureCount;
      _retryCount = $v.retryCount;
      _lastSuccessAt = $v.lastSuccessAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadyJobs other) {
    _$v = other as _$ReadyJobs;
  }

  @override
  void update(void Function(ReadyJobsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadyJobs build() => _build();

  _$ReadyJobs _build() {
    final _$result = _$v ??
        _$ReadyJobs._(
          failureCount: failureCount,
          retryCount: retryCount,
          lastSuccessAt: lastSuccessAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
