// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_schedule_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookScheduleState {

 LoadStatus get status; Failure? get failure; ScheduleParticipantEntry? get participant; String? get scheduleId;
/// Create a copy of BookScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookScheduleStateCopyWith<BookScheduleState> get copyWith => _$BookScheduleStateCopyWithImpl<BookScheduleState>(this as BookScheduleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookScheduleState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure,participant,scheduleId);

@override
String toString() {
  return 'BookScheduleState(status: $status, failure: $failure, participant: $participant, scheduleId: $scheduleId)';
}


}

/// @nodoc
abstract mixin class $BookScheduleStateCopyWith<$Res>  {
  factory $BookScheduleStateCopyWith(BookScheduleState value, $Res Function(BookScheduleState) _then) = _$BookScheduleStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Failure? failure, ScheduleParticipantEntry? participant, String? scheduleId
});




}
/// @nodoc
class _$BookScheduleStateCopyWithImpl<$Res>
    implements $BookScheduleStateCopyWith<$Res> {
  _$BookScheduleStateCopyWithImpl(this._self, this._then);

  final BookScheduleState _self;
  final $Res Function(BookScheduleState) _then;

/// Create a copy of BookScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failure = freezed,Object? participant = freezed,Object? scheduleId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,participant: freezed == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as ScheduleParticipantEntry?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookScheduleState].
extension BookScheduleStatePatterns on BookScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookScheduleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookScheduleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookScheduleState value)  $default,){
final _that = this;
switch (_that) {
case _BookScheduleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookScheduleState value)?  $default,){
final _that = this;
switch (_that) {
case _BookScheduleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure,  ScheduleParticipantEntry? participant,  String? scheduleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookScheduleState() when $default != null:
return $default(_that.status,_that.failure,_that.participant,_that.scheduleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure,  ScheduleParticipantEntry? participant,  String? scheduleId)  $default,) {final _that = this;
switch (_that) {
case _BookScheduleState():
return $default(_that.status,_that.failure,_that.participant,_that.scheduleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Failure? failure,  ScheduleParticipantEntry? participant,  String? scheduleId)?  $default,) {final _that = this;
switch (_that) {
case _BookScheduleState() when $default != null:
return $default(_that.status,_that.failure,_that.participant,_that.scheduleId);case _:
  return null;

}
}

}

/// @nodoc


class _BookScheduleState implements BookScheduleState {
  const _BookScheduleState({this.status = LoadStatus.initial, this.failure, this.participant, this.scheduleId});
  

@override@JsonKey() final  LoadStatus status;
@override final  Failure? failure;
@override final  ScheduleParticipantEntry? participant;
@override final  String? scheduleId;

/// Create a copy of BookScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookScheduleStateCopyWith<_BookScheduleState> get copyWith => __$BookScheduleStateCopyWithImpl<_BookScheduleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookScheduleState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure,participant,scheduleId);

@override
String toString() {
  return 'BookScheduleState(status: $status, failure: $failure, participant: $participant, scheduleId: $scheduleId)';
}


}

/// @nodoc
abstract mixin class _$BookScheduleStateCopyWith<$Res> implements $BookScheduleStateCopyWith<$Res> {
  factory _$BookScheduleStateCopyWith(_BookScheduleState value, $Res Function(_BookScheduleState) _then) = __$BookScheduleStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Failure? failure, ScheduleParticipantEntry? participant, String? scheduleId
});




}
/// @nodoc
class __$BookScheduleStateCopyWithImpl<$Res>
    implements _$BookScheduleStateCopyWith<$Res> {
  __$BookScheduleStateCopyWithImpl(this._self, this._then);

  final _BookScheduleState _self;
  final $Res Function(_BookScheduleState) _then;

/// Create a copy of BookScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failure = freezed,Object? participant = freezed,Object? scheduleId = freezed,}) {
  return _then(_BookScheduleState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,participant: freezed == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as ScheduleParticipantEntry?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
