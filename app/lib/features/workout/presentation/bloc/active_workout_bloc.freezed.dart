// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_workout_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveWorkoutState {

 LoadStatus get status; WorkoutSession? get session; List<WorkoutSessionSet> get loggedSets; WorkoutPlan? get plan; String? get selectedExerciseId; String? get initialPlanId;/// Non-failure text such as a missing member id. API errors use [failure].
 String? get message; Failure? get failure; bool get logging; bool get completed; int? get loggedSetCount;
/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveWorkoutStateCopyWith<ActiveWorkoutState> get copyWith => _$ActiveWorkoutStateCopyWithImpl<ActiveWorkoutState>(this as ActiveWorkoutState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveWorkoutState&&(identical(other.status, status) || other.status == status)&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.loggedSets, loggedSets)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.selectedExerciseId, selectedExerciseId) || other.selectedExerciseId == selectedExerciseId)&&(identical(other.initialPlanId, initialPlanId) || other.initialPlanId == initialPlanId)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.logging, logging) || other.logging == logging)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.loggedSetCount, loggedSetCount) || other.loggedSetCount == loggedSetCount));
}


@override
int get hashCode => Object.hash(runtimeType,status,session,const DeepCollectionEquality().hash(loggedSets),plan,selectedExerciseId,initialPlanId,message,failure,logging,completed,loggedSetCount);

@override
String toString() {
  return 'ActiveWorkoutState(status: $status, session: $session, loggedSets: $loggedSets, plan: $plan, selectedExerciseId: $selectedExerciseId, initialPlanId: $initialPlanId, message: $message, failure: $failure, logging: $logging, completed: $completed, loggedSetCount: $loggedSetCount)';
}


}

/// @nodoc
abstract mixin class $ActiveWorkoutStateCopyWith<$Res>  {
  factory $ActiveWorkoutStateCopyWith(ActiveWorkoutState value, $Res Function(ActiveWorkoutState) _then) = _$ActiveWorkoutStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, WorkoutSession? session, List<WorkoutSessionSet> loggedSets, WorkoutPlan? plan, String? selectedExerciseId, String? initialPlanId, String? message, Failure? failure, bool logging, bool completed, int? loggedSetCount
});




}
/// @nodoc
class _$ActiveWorkoutStateCopyWithImpl<$Res>
    implements $ActiveWorkoutStateCopyWith<$Res> {
  _$ActiveWorkoutStateCopyWithImpl(this._self, this._then);

  final ActiveWorkoutState _self;
  final $Res Function(ActiveWorkoutState) _then;

/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? session = freezed,Object? loggedSets = null,Object? plan = freezed,Object? selectedExerciseId = freezed,Object? initialPlanId = freezed,Object? message = freezed,Object? failure = freezed,Object? logging = null,Object? completed = null,Object? loggedSetCount = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as WorkoutSession?,loggedSets: null == loggedSets ? _self.loggedSets : loggedSets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSessionSet>,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,selectedExerciseId: freezed == selectedExerciseId ? _self.selectedExerciseId : selectedExerciseId // ignore: cast_nullable_to_non_nullable
as String?,initialPlanId: freezed == initialPlanId ? _self.initialPlanId : initialPlanId // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,logging: null == logging ? _self.logging : logging // ignore: cast_nullable_to_non_nullable
as bool,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,loggedSetCount: freezed == loggedSetCount ? _self.loggedSetCount : loggedSetCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveWorkoutState].
extension ActiveWorkoutStatePatterns on ActiveWorkoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveWorkoutState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveWorkoutState value)  $default,){
final _that = this;
switch (_that) {
case _ActiveWorkoutState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveWorkoutState value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  WorkoutSession? session,  List<WorkoutSessionSet> loggedSets,  WorkoutPlan? plan,  String? selectedExerciseId,  String? initialPlanId,  String? message,  Failure? failure,  bool logging,  bool completed,  int? loggedSetCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
return $default(_that.status,_that.session,_that.loggedSets,_that.plan,_that.selectedExerciseId,_that.initialPlanId,_that.message,_that.failure,_that.logging,_that.completed,_that.loggedSetCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  WorkoutSession? session,  List<WorkoutSessionSet> loggedSets,  WorkoutPlan? plan,  String? selectedExerciseId,  String? initialPlanId,  String? message,  Failure? failure,  bool logging,  bool completed,  int? loggedSetCount)  $default,) {final _that = this;
switch (_that) {
case _ActiveWorkoutState():
return $default(_that.status,_that.session,_that.loggedSets,_that.plan,_that.selectedExerciseId,_that.initialPlanId,_that.message,_that.failure,_that.logging,_that.completed,_that.loggedSetCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  WorkoutSession? session,  List<WorkoutSessionSet> loggedSets,  WorkoutPlan? plan,  String? selectedExerciseId,  String? initialPlanId,  String? message,  Failure? failure,  bool logging,  bool completed,  int? loggedSetCount)?  $default,) {final _that = this;
switch (_that) {
case _ActiveWorkoutState() when $default != null:
return $default(_that.status,_that.session,_that.loggedSets,_that.plan,_that.selectedExerciseId,_that.initialPlanId,_that.message,_that.failure,_that.logging,_that.completed,_that.loggedSetCount);case _:
  return null;

}
}

}

/// @nodoc


class _ActiveWorkoutState extends ActiveWorkoutState {
  const _ActiveWorkoutState({this.status = LoadStatus.initial, this.session, final  List<WorkoutSessionSet> loggedSets = const <WorkoutSessionSet>[], this.plan, this.selectedExerciseId, this.initialPlanId, this.message, this.failure, this.logging = false, this.completed = false, this.loggedSetCount}): _loggedSets = loggedSets,super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  WorkoutSession? session;
 final  List<WorkoutSessionSet> _loggedSets;
@override@JsonKey() List<WorkoutSessionSet> get loggedSets {
  if (_loggedSets is EqualUnmodifiableListView) return _loggedSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loggedSets);
}

@override final  WorkoutPlan? plan;
@override final  String? selectedExerciseId;
@override final  String? initialPlanId;
/// Non-failure text such as a missing member id. API errors use [failure].
@override final  String? message;
@override final  Failure? failure;
@override@JsonKey() final  bool logging;
@override@JsonKey() final  bool completed;
@override final  int? loggedSetCount;

/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveWorkoutStateCopyWith<_ActiveWorkoutState> get copyWith => __$ActiveWorkoutStateCopyWithImpl<_ActiveWorkoutState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveWorkoutState&&(identical(other.status, status) || other.status == status)&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._loggedSets, _loggedSets)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.selectedExerciseId, selectedExerciseId) || other.selectedExerciseId == selectedExerciseId)&&(identical(other.initialPlanId, initialPlanId) || other.initialPlanId == initialPlanId)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.logging, logging) || other.logging == logging)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.loggedSetCount, loggedSetCount) || other.loggedSetCount == loggedSetCount));
}


@override
int get hashCode => Object.hash(runtimeType,status,session,const DeepCollectionEquality().hash(_loggedSets),plan,selectedExerciseId,initialPlanId,message,failure,logging,completed,loggedSetCount);

@override
String toString() {
  return 'ActiveWorkoutState(status: $status, session: $session, loggedSets: $loggedSets, plan: $plan, selectedExerciseId: $selectedExerciseId, initialPlanId: $initialPlanId, message: $message, failure: $failure, logging: $logging, completed: $completed, loggedSetCount: $loggedSetCount)';
}


}

/// @nodoc
abstract mixin class _$ActiveWorkoutStateCopyWith<$Res> implements $ActiveWorkoutStateCopyWith<$Res> {
  factory _$ActiveWorkoutStateCopyWith(_ActiveWorkoutState value, $Res Function(_ActiveWorkoutState) _then) = __$ActiveWorkoutStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, WorkoutSession? session, List<WorkoutSessionSet> loggedSets, WorkoutPlan? plan, String? selectedExerciseId, String? initialPlanId, String? message, Failure? failure, bool logging, bool completed, int? loggedSetCount
});




}
/// @nodoc
class __$ActiveWorkoutStateCopyWithImpl<$Res>
    implements _$ActiveWorkoutStateCopyWith<$Res> {
  __$ActiveWorkoutStateCopyWithImpl(this._self, this._then);

  final _ActiveWorkoutState _self;
  final $Res Function(_ActiveWorkoutState) _then;

/// Create a copy of ActiveWorkoutState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? session = freezed,Object? loggedSets = null,Object? plan = freezed,Object? selectedExerciseId = freezed,Object? initialPlanId = freezed,Object? message = freezed,Object? failure = freezed,Object? logging = null,Object? completed = null,Object? loggedSetCount = freezed,}) {
  return _then(_ActiveWorkoutState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as WorkoutSession?,loggedSets: null == loggedSets ? _self._loggedSets : loggedSets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSessionSet>,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,selectedExerciseId: freezed == selectedExerciseId ? _self.selectedExerciseId : selectedExerciseId // ignore: cast_nullable_to_non_nullable
as String?,initialPlanId: freezed == initialPlanId ? _self.initialPlanId : initialPlanId // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,logging: null == logging ? _self.logging : logging // ignore: cast_nullable_to_non_nullable
as bool,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,loggedSetCount: freezed == loggedSetCount ? _self.loggedSetCount : loggedSetCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
