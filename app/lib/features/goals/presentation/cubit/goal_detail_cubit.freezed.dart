// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalDetailState {

 LoadStatus get status; MemberGoal? get goal; List<ProgressNote> get coachNotes; LoadStatus get notesStatus; bool get submitting; Failure? get failure;
/// Create a copy of GoalDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalDetailStateCopyWith<GoalDetailState> get copyWith => _$GoalDetailStateCopyWithImpl<GoalDetailState>(this as GoalDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.coachNotes, coachNotes)&&(identical(other.notesStatus, notesStatus) || other.notesStatus == notesStatus)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,goal,const DeepCollectionEquality().hash(coachNotes),notesStatus,submitting,failure);

@override
String toString() {
  return 'GoalDetailState(status: $status, goal: $goal, coachNotes: $coachNotes, notesStatus: $notesStatus, submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $GoalDetailStateCopyWith<$Res>  {
  factory $GoalDetailStateCopyWith(GoalDetailState value, $Res Function(GoalDetailState) _then) = _$GoalDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, MemberGoal? goal, List<ProgressNote> coachNotes, LoadStatus notesStatus, bool submitting, Failure? failure
});




}
/// @nodoc
class _$GoalDetailStateCopyWithImpl<$Res>
    implements $GoalDetailStateCopyWith<$Res> {
  _$GoalDetailStateCopyWithImpl(this._self, this._then);

  final GoalDetailState _self;
  final $Res Function(GoalDetailState) _then;

/// Create a copy of GoalDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? goal = freezed,Object? coachNotes = null,Object? notesStatus = null,Object? submitting = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as MemberGoal?,coachNotes: null == coachNotes ? _self.coachNotes : coachNotes // ignore: cast_nullable_to_non_nullable
as List<ProgressNote>,notesStatus: null == notesStatus ? _self.notesStatus : notesStatus // ignore: cast_nullable_to_non_nullable
as LoadStatus,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalDetailState].
extension GoalDetailStatePatterns on GoalDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalDetailState value)  $default,){
final _that = this;
switch (_that) {
case _GoalDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _GoalDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  MemberGoal? goal,  List<ProgressNote> coachNotes,  LoadStatus notesStatus,  bool submitting,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalDetailState() when $default != null:
return $default(_that.status,_that.goal,_that.coachNotes,_that.notesStatus,_that.submitting,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  MemberGoal? goal,  List<ProgressNote> coachNotes,  LoadStatus notesStatus,  bool submitting,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _GoalDetailState():
return $default(_that.status,_that.goal,_that.coachNotes,_that.notesStatus,_that.submitting,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  MemberGoal? goal,  List<ProgressNote> coachNotes,  LoadStatus notesStatus,  bool submitting,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _GoalDetailState() when $default != null:
return $default(_that.status,_that.goal,_that.coachNotes,_that.notesStatus,_that.submitting,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _GoalDetailState implements GoalDetailState {
  const _GoalDetailState({this.status = LoadStatus.initial, this.goal, final  List<ProgressNote> coachNotes = const <ProgressNote>[], this.notesStatus = LoadStatus.initial, this.submitting = false, this.failure}): _coachNotes = coachNotes;
  

@override@JsonKey() final  LoadStatus status;
@override final  MemberGoal? goal;
 final  List<ProgressNote> _coachNotes;
@override@JsonKey() List<ProgressNote> get coachNotes {
  if (_coachNotes is EqualUnmodifiableListView) return _coachNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coachNotes);
}

@override@JsonKey() final  LoadStatus notesStatus;
@override@JsonKey() final  bool submitting;
@override final  Failure? failure;

/// Create a copy of GoalDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalDetailStateCopyWith<_GoalDetailState> get copyWith => __$GoalDetailStateCopyWithImpl<_GoalDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other._coachNotes, _coachNotes)&&(identical(other.notesStatus, notesStatus) || other.notesStatus == notesStatus)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,goal,const DeepCollectionEquality().hash(_coachNotes),notesStatus,submitting,failure);

@override
String toString() {
  return 'GoalDetailState(status: $status, goal: $goal, coachNotes: $coachNotes, notesStatus: $notesStatus, submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$GoalDetailStateCopyWith<$Res> implements $GoalDetailStateCopyWith<$Res> {
  factory _$GoalDetailStateCopyWith(_GoalDetailState value, $Res Function(_GoalDetailState) _then) = __$GoalDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, MemberGoal? goal, List<ProgressNote> coachNotes, LoadStatus notesStatus, bool submitting, Failure? failure
});




}
/// @nodoc
class __$GoalDetailStateCopyWithImpl<$Res>
    implements _$GoalDetailStateCopyWith<$Res> {
  __$GoalDetailStateCopyWithImpl(this._self, this._then);

  final _GoalDetailState _self;
  final $Res Function(_GoalDetailState) _then;

/// Create a copy of GoalDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? goal = freezed,Object? coachNotes = null,Object? notesStatus = null,Object? submitting = null,Object? failure = freezed,}) {
  return _then(_GoalDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as MemberGoal?,coachNotes: null == coachNotes ? _self._coachNotes : coachNotes // ignore: cast_nullable_to_non_nullable
as List<ProgressNote>,notesStatus: null == notesStatus ? _self.notesStatus : notesStatus // ignore: cast_nullable_to_non_nullable
as LoadStatus,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
