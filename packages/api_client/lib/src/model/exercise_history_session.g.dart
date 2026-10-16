// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_history_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExerciseHistorySession extends ExerciseHistorySession {
  @override
  final int sessionId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final BuiltList<WorkoutSessionExercise> sets;

  factory _$ExerciseHistorySession(
          [void Function(ExerciseHistorySessionBuilder)? updates]) =>
      (ExerciseHistorySessionBuilder()..update(updates))._build();

  _$ExerciseHistorySession._(
      {required this.sessionId,
      required this.startedAt,
      this.completedAt,
      required this.sets})
      : super._();
  @override
  ExerciseHistorySession rebuild(
          void Function(ExerciseHistorySessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciseHistorySessionBuilder toBuilder() =>
      ExerciseHistorySessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExerciseHistorySession &&
        sessionId == other.sessionId &&
        startedAt == other.startedAt &&
        completedAt == other.completedAt &&
        sets == other.sets;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, sets.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExerciseHistorySession')
          ..add('sessionId', sessionId)
          ..add('startedAt', startedAt)
          ..add('completedAt', completedAt)
          ..add('sets', sets))
        .toString();
  }
}

class ExerciseHistorySessionBuilder
    implements Builder<ExerciseHistorySession, ExerciseHistorySessionBuilder> {
  _$ExerciseHistorySession? _$v;

  int? _sessionId;
  int? get sessionId => _$this._sessionId;
  set sessionId(int? sessionId) => _$this._sessionId = sessionId;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  ListBuilder<WorkoutSessionExercise>? _sets;
  ListBuilder<WorkoutSessionExercise> get sets =>
      _$this._sets ??= ListBuilder<WorkoutSessionExercise>();
  set sets(ListBuilder<WorkoutSessionExercise>? sets) => _$this._sets = sets;

  ExerciseHistorySessionBuilder() {
    ExerciseHistorySession._defaults(this);
  }

  ExerciseHistorySessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionId = $v.sessionId;
      _startedAt = $v.startedAt;
      _completedAt = $v.completedAt;
      _sets = $v.sets.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExerciseHistorySession other) {
    _$v = other as _$ExerciseHistorySession;
  }

  @override
  void update(void Function(ExerciseHistorySessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExerciseHistorySession build() => _build();

  _$ExerciseHistorySession _build() {
    _$ExerciseHistorySession _$result;
    try {
      _$result = _$v ??
          _$ExerciseHistorySession._(
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'ExerciseHistorySession', 'sessionId'),
            startedAt: BuiltValueNullFieldError.checkNotNull(
                startedAt, r'ExerciseHistorySession', 'startedAt'),
            completedAt: completedAt,
            sets: sets.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sets';
        sets.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ExerciseHistorySession', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
