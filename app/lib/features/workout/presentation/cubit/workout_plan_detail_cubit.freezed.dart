// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutPlanDetailState {

 LoadStatus get status; WorkoutPlan? get plan;/// Set after a successful template assign; UI navigates then clears.
 WorkoutPlan? get assignedPlan; bool get actionInFlight; Failure? get failure;
/// Create a copy of WorkoutPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutPlanDetailStateCopyWith<WorkoutPlanDetailState> get copyWith => _$WorkoutPlanDetailStateCopyWithImpl<WorkoutPlanDetailState>(this as WorkoutPlanDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutPlanDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.assignedPlan, assignedPlan) || other.assignedPlan == assignedPlan)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,plan,assignedPlan,actionInFlight,failure);

@override
String toString() {
  return 'WorkoutPlanDetailState(status: $status, plan: $plan, assignedPlan: $assignedPlan, actionInFlight: $actionInFlight, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $WorkoutPlanDetailStateCopyWith<$Res>  {
  factory $WorkoutPlanDetailStateCopyWith(WorkoutPlanDetailState value, $Res Function(WorkoutPlanDetailState) _then) = _$WorkoutPlanDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, WorkoutPlan? plan, WorkoutPlan? assignedPlan, bool actionInFlight, Failure? failure
});




}
/// @nodoc
class _$WorkoutPlanDetailStateCopyWithImpl<$Res>
    implements $WorkoutPlanDetailStateCopyWith<$Res> {
  _$WorkoutPlanDetailStateCopyWithImpl(this._self, this._then);

  final WorkoutPlanDetailState _self;
  final $Res Function(WorkoutPlanDetailState) _then;

/// Create a copy of WorkoutPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? plan = freezed,Object? assignedPlan = freezed,Object? actionInFlight = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,assignedPlan: freezed == assignedPlan ? _self.assignedPlan : assignedPlan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutPlanDetailState].
extension WorkoutPlanDetailStatePatterns on WorkoutPlanDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutPlanDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutPlanDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutPlanDetailState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutPlanDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  WorkoutPlan? plan,  WorkoutPlan? assignedPlan,  bool actionInFlight,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutPlanDetailState() when $default != null:
return $default(_that.status,_that.plan,_that.assignedPlan,_that.actionInFlight,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  WorkoutPlan? plan,  WorkoutPlan? assignedPlan,  bool actionInFlight,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanDetailState():
return $default(_that.status,_that.plan,_that.assignedPlan,_that.actionInFlight,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  WorkoutPlan? plan,  WorkoutPlan? assignedPlan,  bool actionInFlight,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanDetailState() when $default != null:
return $default(_that.status,_that.plan,_that.assignedPlan,_that.actionInFlight,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutPlanDetailState implements WorkoutPlanDetailState {
  const _WorkoutPlanDetailState({this.status = LoadStatus.initial, this.plan, this.assignedPlan, this.actionInFlight = false, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  WorkoutPlan? plan;
/// Set after a successful template assign; UI navigates then clears.
@override final  WorkoutPlan? assignedPlan;
@override@JsonKey() final  bool actionInFlight;
@override final  Failure? failure;

/// Create a copy of WorkoutPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutPlanDetailStateCopyWith<_WorkoutPlanDetailState> get copyWith => __$WorkoutPlanDetailStateCopyWithImpl<_WorkoutPlanDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutPlanDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.assignedPlan, assignedPlan) || other.assignedPlan == assignedPlan)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,plan,assignedPlan,actionInFlight,failure);

@override
String toString() {
  return 'WorkoutPlanDetailState(status: $status, plan: $plan, assignedPlan: $assignedPlan, actionInFlight: $actionInFlight, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WorkoutPlanDetailStateCopyWith<$Res> implements $WorkoutPlanDetailStateCopyWith<$Res> {
  factory _$WorkoutPlanDetailStateCopyWith(_WorkoutPlanDetailState value, $Res Function(_WorkoutPlanDetailState) _then) = __$WorkoutPlanDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, WorkoutPlan? plan, WorkoutPlan? assignedPlan, bool actionInFlight, Failure? failure
});




}
/// @nodoc
class __$WorkoutPlanDetailStateCopyWithImpl<$Res>
    implements _$WorkoutPlanDetailStateCopyWith<$Res> {
  __$WorkoutPlanDetailStateCopyWithImpl(this._self, this._then);

  final _WorkoutPlanDetailState _self;
  final $Res Function(_WorkoutPlanDetailState) _then;

/// Create a copy of WorkoutPlanDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? plan = freezed,Object? assignedPlan = freezed,Object? actionInFlight = null,Object? failure = freezed,}) {
  return _then(_WorkoutPlanDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,assignedPlan: freezed == assignedPlan ? _self.assignedPlan : assignedPlan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
