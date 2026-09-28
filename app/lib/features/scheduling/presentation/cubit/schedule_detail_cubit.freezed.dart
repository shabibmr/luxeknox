// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleDetailState {

 LoadStatus get status; ScheduleSession? get session; bool get actionInFlight;/// Success / action copy. API errors use [failure] (and optionally [message]
/// for move-booking cap / rollback copy).
 String? get message; Failure? get failure;/// Staff reschedule hit a stale `rowVersion` (409); session was reloaded.
 bool get isConflict;/// Set after a successful move so the UI can navigate to the new session.
 String? get movedToScheduleId;
/// Create a copy of ScheduleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDetailStateCopyWith<ScheduleDetailState> get copyWith => _$ScheduleDetailStateCopyWithImpl<ScheduleDetailState>(this as ScheduleDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.session, session) || other.session == session)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isConflict, isConflict) || other.isConflict == isConflict)&&(identical(other.movedToScheduleId, movedToScheduleId) || other.movedToScheduleId == movedToScheduleId));
}


@override
int get hashCode => Object.hash(runtimeType,status,session,actionInFlight,message,failure,isConflict,movedToScheduleId);

@override
String toString() {
  return 'ScheduleDetailState(status: $status, session: $session, actionInFlight: $actionInFlight, message: $message, failure: $failure, isConflict: $isConflict, movedToScheduleId: $movedToScheduleId)';
}


}

/// @nodoc
abstract mixin class $ScheduleDetailStateCopyWith<$Res>  {
  factory $ScheduleDetailStateCopyWith(ScheduleDetailState value, $Res Function(ScheduleDetailState) _then) = _$ScheduleDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, ScheduleSession? session, bool actionInFlight, String? message, Failure? failure, bool isConflict, String? movedToScheduleId
});




}
/// @nodoc
class _$ScheduleDetailStateCopyWithImpl<$Res>
    implements $ScheduleDetailStateCopyWith<$Res> {
  _$ScheduleDetailStateCopyWithImpl(this._self, this._then);

  final ScheduleDetailState _self;
  final $Res Function(ScheduleDetailState) _then;

/// Create a copy of ScheduleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? session = freezed,Object? actionInFlight = null,Object? message = freezed,Object? failure = freezed,Object? isConflict = null,Object? movedToScheduleId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ScheduleSession?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isConflict: null == isConflict ? _self.isConflict : isConflict // ignore: cast_nullable_to_non_nullable
as bool,movedToScheduleId: freezed == movedToScheduleId ? _self.movedToScheduleId : movedToScheduleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDetailState].
extension ScheduleDetailStatePatterns on ScheduleDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  ScheduleSession? session,  bool actionInFlight,  String? message,  Failure? failure,  bool isConflict,  String? movedToScheduleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDetailState() when $default != null:
return $default(_that.status,_that.session,_that.actionInFlight,_that.message,_that.failure,_that.isConflict,_that.movedToScheduleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  ScheduleSession? session,  bool actionInFlight,  String? message,  Failure? failure,  bool isConflict,  String? movedToScheduleId)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailState():
return $default(_that.status,_that.session,_that.actionInFlight,_that.message,_that.failure,_that.isConflict,_that.movedToScheduleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  ScheduleSession? session,  bool actionInFlight,  String? message,  Failure? failure,  bool isConflict,  String? movedToScheduleId)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailState() when $default != null:
return $default(_that.status,_that.session,_that.actionInFlight,_that.message,_that.failure,_that.isConflict,_that.movedToScheduleId);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleDetailState implements ScheduleDetailState {
  const _ScheduleDetailState({this.status = LoadStatus.initial, this.session, this.actionInFlight = false, this.message, this.failure, this.isConflict = false, this.movedToScheduleId});
  

@override@JsonKey() final  LoadStatus status;
@override final  ScheduleSession? session;
@override@JsonKey() final  bool actionInFlight;
/// Success / action copy. API errors use [failure] (and optionally [message]
/// for move-booking cap / rollback copy).
@override final  String? message;
@override final  Failure? failure;
/// Staff reschedule hit a stale `rowVersion` (409); session was reloaded.
@override@JsonKey() final  bool isConflict;
/// Set after a successful move so the UI can navigate to the new session.
@override final  String? movedToScheduleId;

/// Create a copy of ScheduleDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDetailStateCopyWith<_ScheduleDetailState> get copyWith => __$ScheduleDetailStateCopyWithImpl<_ScheduleDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.session, session) || other.session == session)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isConflict, isConflict) || other.isConflict == isConflict)&&(identical(other.movedToScheduleId, movedToScheduleId) || other.movedToScheduleId == movedToScheduleId));
}


@override
int get hashCode => Object.hash(runtimeType,status,session,actionInFlight,message,failure,isConflict,movedToScheduleId);

@override
String toString() {
  return 'ScheduleDetailState(status: $status, session: $session, actionInFlight: $actionInFlight, message: $message, failure: $failure, isConflict: $isConflict, movedToScheduleId: $movedToScheduleId)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDetailStateCopyWith<$Res> implements $ScheduleDetailStateCopyWith<$Res> {
  factory _$ScheduleDetailStateCopyWith(_ScheduleDetailState value, $Res Function(_ScheduleDetailState) _then) = __$ScheduleDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, ScheduleSession? session, bool actionInFlight, String? message, Failure? failure, bool isConflict, String? movedToScheduleId
});




}
/// @nodoc
class __$ScheduleDetailStateCopyWithImpl<$Res>
    implements _$ScheduleDetailStateCopyWith<$Res> {
  __$ScheduleDetailStateCopyWithImpl(this._self, this._then);

  final _ScheduleDetailState _self;
  final $Res Function(_ScheduleDetailState) _then;

/// Create a copy of ScheduleDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? session = freezed,Object? actionInFlight = null,Object? message = freezed,Object? failure = freezed,Object? isConflict = null,Object? movedToScheduleId = freezed,}) {
  return _then(_ScheduleDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ScheduleSession?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isConflict: null == isConflict ? _self.isConflict : isConflict // ignore: cast_nullable_to_non_nullable
as bool,movedToScheduleId: freezed == movedToScheduleId ? _self.movedToScheduleId : movedToScheduleId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
