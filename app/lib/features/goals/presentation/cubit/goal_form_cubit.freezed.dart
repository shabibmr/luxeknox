// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalFormState {

 LoadStatus get status; List<GoalMetric> get metrics; MemberGoal? get existing; bool get submitting; Failure? get failure; MemberGoal? get savedGoal;
/// Create a copy of GoalFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalFormStateCopyWith<GoalFormState> get copyWith => _$GoalFormStateCopyWithImpl<GoalFormState>(this as GoalFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalFormState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.metrics, metrics)&&(identical(other.existing, existing) || other.existing == existing)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.savedGoal, savedGoal) || other.savedGoal == savedGoal));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(metrics),existing,submitting,failure,savedGoal);

@override
String toString() {
  return 'GoalFormState(status: $status, metrics: $metrics, existing: $existing, submitting: $submitting, failure: $failure, savedGoal: $savedGoal)';
}


}

/// @nodoc
abstract mixin class $GoalFormStateCopyWith<$Res>  {
  factory $GoalFormStateCopyWith(GoalFormState value, $Res Function(GoalFormState) _then) = _$GoalFormStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<GoalMetric> metrics, MemberGoal? existing, bool submitting, Failure? failure, MemberGoal? savedGoal
});




}
/// @nodoc
class _$GoalFormStateCopyWithImpl<$Res>
    implements $GoalFormStateCopyWith<$Res> {
  _$GoalFormStateCopyWithImpl(this._self, this._then);

  final GoalFormState _self;
  final $Res Function(GoalFormState) _then;

/// Create a copy of GoalFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? metrics = null,Object? existing = freezed,Object? submitting = null,Object? failure = freezed,Object? savedGoal = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<GoalMetric>,existing: freezed == existing ? _self.existing : existing // ignore: cast_nullable_to_non_nullable
as MemberGoal?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,savedGoal: freezed == savedGoal ? _self.savedGoal : savedGoal // ignore: cast_nullable_to_non_nullable
as MemberGoal?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalFormState].
extension GoalFormStatePatterns on GoalFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalFormState value)  $default,){
final _that = this;
switch (_that) {
case _GoalFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalFormState value)?  $default,){
final _that = this;
switch (_that) {
case _GoalFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<GoalMetric> metrics,  MemberGoal? existing,  bool submitting,  Failure? failure,  MemberGoal? savedGoal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalFormState() when $default != null:
return $default(_that.status,_that.metrics,_that.existing,_that.submitting,_that.failure,_that.savedGoal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<GoalMetric> metrics,  MemberGoal? existing,  bool submitting,  Failure? failure,  MemberGoal? savedGoal)  $default,) {final _that = this;
switch (_that) {
case _GoalFormState():
return $default(_that.status,_that.metrics,_that.existing,_that.submitting,_that.failure,_that.savedGoal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<GoalMetric> metrics,  MemberGoal? existing,  bool submitting,  Failure? failure,  MemberGoal? savedGoal)?  $default,) {final _that = this;
switch (_that) {
case _GoalFormState() when $default != null:
return $default(_that.status,_that.metrics,_that.existing,_that.submitting,_that.failure,_that.savedGoal);case _:
  return null;

}
}

}

/// @nodoc


class _GoalFormState implements GoalFormState {
  const _GoalFormState({this.status = LoadStatus.initial, final  List<GoalMetric> metrics = const <GoalMetric>[], this.existing, this.submitting = false, this.failure, this.savedGoal}): _metrics = metrics;
  

@override@JsonKey() final  LoadStatus status;
 final  List<GoalMetric> _metrics;
@override@JsonKey() List<GoalMetric> get metrics {
  if (_metrics is EqualUnmodifiableListView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_metrics);
}

@override final  MemberGoal? existing;
@override@JsonKey() final  bool submitting;
@override final  Failure? failure;
@override final  MemberGoal? savedGoal;

/// Create a copy of GoalFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalFormStateCopyWith<_GoalFormState> get copyWith => __$GoalFormStateCopyWithImpl<_GoalFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalFormState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._metrics, _metrics)&&(identical(other.existing, existing) || other.existing == existing)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.savedGoal, savedGoal) || other.savedGoal == savedGoal));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_metrics),existing,submitting,failure,savedGoal);

@override
String toString() {
  return 'GoalFormState(status: $status, metrics: $metrics, existing: $existing, submitting: $submitting, failure: $failure, savedGoal: $savedGoal)';
}


}

/// @nodoc
abstract mixin class _$GoalFormStateCopyWith<$Res> implements $GoalFormStateCopyWith<$Res> {
  factory _$GoalFormStateCopyWith(_GoalFormState value, $Res Function(_GoalFormState) _then) = __$GoalFormStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<GoalMetric> metrics, MemberGoal? existing, bool submitting, Failure? failure, MemberGoal? savedGoal
});




}
/// @nodoc
class __$GoalFormStateCopyWithImpl<$Res>
    implements _$GoalFormStateCopyWith<$Res> {
  __$GoalFormStateCopyWithImpl(this._self, this._then);

  final _GoalFormState _self;
  final $Res Function(_GoalFormState) _then;

/// Create a copy of GoalFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? metrics = null,Object? existing = freezed,Object? submitting = null,Object? failure = freezed,Object? savedGoal = freezed,}) {
  return _then(_GoalFormState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<GoalMetric>,existing: freezed == existing ? _self.existing : existing // ignore: cast_nullable_to_non_nullable
as MemberGoal?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,savedGoal: freezed == savedGoal ? _self.savedGoal : savedGoal // ignore: cast_nullable_to_non_nullable
as MemberGoal?,
  ));
}


}

// dart format on
