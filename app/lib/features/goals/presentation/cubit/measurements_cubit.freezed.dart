// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurements_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasurementsState {

 LoadStatus get status; List<MeasurementSession> get sessions; List<GoalMetric> get metrics; bool get submitting; bool get hasMore; String? get nextCursor; Failure? get failure;
/// Create a copy of MeasurementsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementsStateCopyWith<MeasurementsState> get copyWith => _$MeasurementsStateCopyWithImpl<MeasurementsState>(this as MeasurementsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.sessions, sessions)&&const DeepCollectionEquality().equals(other.metrics, metrics)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(sessions),const DeepCollectionEquality().hash(metrics),submitting,hasMore,nextCursor,failure);

@override
String toString() {
  return 'MeasurementsState(status: $status, sessions: $sessions, metrics: $metrics, submitting: $submitting, hasMore: $hasMore, nextCursor: $nextCursor, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MeasurementsStateCopyWith<$Res>  {
  factory $MeasurementsStateCopyWith(MeasurementsState value, $Res Function(MeasurementsState) _then) = _$MeasurementsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MeasurementSession> sessions, List<GoalMetric> metrics, bool submitting, bool hasMore, String? nextCursor, Failure? failure
});




}
/// @nodoc
class _$MeasurementsStateCopyWithImpl<$Res>
    implements $MeasurementsStateCopyWith<$Res> {
  _$MeasurementsStateCopyWithImpl(this._self, this._then);

  final MeasurementsState _self;
  final $Res Function(MeasurementsState) _then;

/// Create a copy of MeasurementsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? sessions = null,Object? metrics = null,Object? submitting = null,Object? hasMore = null,Object? nextCursor = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<MeasurementSession>,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<GoalMetric>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurementsState].
extension MeasurementsStatePatterns on MeasurementsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementsState value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementsState value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MeasurementSession> sessions,  List<GoalMetric> metrics,  bool submitting,  bool hasMore,  String? nextCursor,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementsState() when $default != null:
return $default(_that.status,_that.sessions,_that.metrics,_that.submitting,_that.hasMore,_that.nextCursor,_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MeasurementSession> sessions,  List<GoalMetric> metrics,  bool submitting,  bool hasMore,  String? nextCursor,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MeasurementsState():
return $default(_that.status,_that.sessions,_that.metrics,_that.submitting,_that.hasMore,_that.nextCursor,_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MeasurementSession> sessions,  List<GoalMetric> metrics,  bool submitting,  bool hasMore,  String? nextCursor,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementsState() when $default != null:
return $default(_that.status,_that.sessions,_that.metrics,_that.submitting,_that.hasMore,_that.nextCursor,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MeasurementsState implements MeasurementsState {
  const _MeasurementsState({this.status = LoadStatus.initial, final  List<MeasurementSession> sessions = const <MeasurementSession>[], final  List<GoalMetric> metrics = const <GoalMetric>[], this.submitting = false, this.hasMore = false, this.nextCursor, this.failure}): _sessions = sessions,_metrics = metrics;
  

@override@JsonKey() final  LoadStatus status;
 final  List<MeasurementSession> _sessions;
@override@JsonKey() List<MeasurementSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

 final  List<GoalMetric> _metrics;
@override@JsonKey() List<GoalMetric> get metrics {
  if (_metrics is EqualUnmodifiableListView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_metrics);
}

@override@JsonKey() final  bool submitting;
@override@JsonKey() final  bool hasMore;
@override final  String? nextCursor;
@override final  Failure? failure;

/// Create a copy of MeasurementsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementsStateCopyWith<_MeasurementsState> get copyWith => __$MeasurementsStateCopyWithImpl<_MeasurementsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&const DeepCollectionEquality().equals(other._metrics, _metrics)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_sessions),const DeepCollectionEquality().hash(_metrics),submitting,hasMore,nextCursor,failure);

@override
String toString() {
  return 'MeasurementsState(status: $status, sessions: $sessions, metrics: $metrics, submitting: $submitting, hasMore: $hasMore, nextCursor: $nextCursor, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MeasurementsStateCopyWith<$Res> implements $MeasurementsStateCopyWith<$Res> {
  factory _$MeasurementsStateCopyWith(_MeasurementsState value, $Res Function(_MeasurementsState) _then) = __$MeasurementsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MeasurementSession> sessions, List<GoalMetric> metrics, bool submitting, bool hasMore, String? nextCursor, Failure? failure
});




}
/// @nodoc
class __$MeasurementsStateCopyWithImpl<$Res>
    implements _$MeasurementsStateCopyWith<$Res> {
  __$MeasurementsStateCopyWithImpl(this._self, this._then);

  final _MeasurementsState _self;
  final $Res Function(_MeasurementsState) _then;

/// Create a copy of MeasurementsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? sessions = null,Object? metrics = null,Object? submitting = null,Object? hasMore = null,Object? nextCursor = freezed,Object? failure = freezed,}) {
  return _then(_MeasurementsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<MeasurementSession>,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<GoalMetric>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
