// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_pass_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendancePassState {

 LoadStatus get status; AttendancePass? get pass; AttendanceRecord? get openAttendance; bool get actionInFlight; Failure? get failure; String? get message;
/// Create a copy of AttendancePassState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendancePassStateCopyWith<AttendancePassState> get copyWith => _$AttendancePassStateCopyWithImpl<AttendancePassState>(this as AttendancePassState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendancePassState&&(identical(other.status, status) || other.status == status)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.openAttendance, openAttendance) || other.openAttendance == openAttendance)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,status,pass,openAttendance,actionInFlight,failure,message);

@override
String toString() {
  return 'AttendancePassState(status: $status, pass: $pass, openAttendance: $openAttendance, actionInFlight: $actionInFlight, failure: $failure, message: $message)';
}


}

/// @nodoc
abstract mixin class $AttendancePassStateCopyWith<$Res>  {
  factory $AttendancePassStateCopyWith(AttendancePassState value, $Res Function(AttendancePassState) _then) = _$AttendancePassStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, AttendancePass? pass, AttendanceRecord? openAttendance, bool actionInFlight, Failure? failure, String? message
});




}
/// @nodoc
class _$AttendancePassStateCopyWithImpl<$Res>
    implements $AttendancePassStateCopyWith<$Res> {
  _$AttendancePassStateCopyWithImpl(this._self, this._then);

  final AttendancePassState _self;
  final $Res Function(AttendancePassState) _then;

/// Create a copy of AttendancePassState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? pass = freezed,Object? openAttendance = freezed,Object? actionInFlight = null,Object? failure = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,pass: freezed == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as AttendancePass?,openAttendance: freezed == openAttendance ? _self.openAttendance : openAttendance // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendancePassState].
extension AttendancePassStatePatterns on AttendancePassState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendancePassState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendancePassState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendancePassState value)  $default,){
final _that = this;
switch (_that) {
case _AttendancePassState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendancePassState value)?  $default,){
final _that = this;
switch (_that) {
case _AttendancePassState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  AttendancePass? pass,  AttendanceRecord? openAttendance,  bool actionInFlight,  Failure? failure,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendancePassState() when $default != null:
return $default(_that.status,_that.pass,_that.openAttendance,_that.actionInFlight,_that.failure,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  AttendancePass? pass,  AttendanceRecord? openAttendance,  bool actionInFlight,  Failure? failure,  String? message)  $default,) {final _that = this;
switch (_that) {
case _AttendancePassState():
return $default(_that.status,_that.pass,_that.openAttendance,_that.actionInFlight,_that.failure,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  AttendancePass? pass,  AttendanceRecord? openAttendance,  bool actionInFlight,  Failure? failure,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _AttendancePassState() when $default != null:
return $default(_that.status,_that.pass,_that.openAttendance,_that.actionInFlight,_that.failure,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _AttendancePassState implements AttendancePassState {
  const _AttendancePassState({this.status = LoadStatus.initial, this.pass, this.openAttendance, this.actionInFlight = false, this.failure, this.message});
  

@override@JsonKey() final  LoadStatus status;
@override final  AttendancePass? pass;
@override final  AttendanceRecord? openAttendance;
@override@JsonKey() final  bool actionInFlight;
@override final  Failure? failure;
@override final  String? message;

/// Create a copy of AttendancePassState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendancePassStateCopyWith<_AttendancePassState> get copyWith => __$AttendancePassStateCopyWithImpl<_AttendancePassState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendancePassState&&(identical(other.status, status) || other.status == status)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.openAttendance, openAttendance) || other.openAttendance == openAttendance)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,status,pass,openAttendance,actionInFlight,failure,message);

@override
String toString() {
  return 'AttendancePassState(status: $status, pass: $pass, openAttendance: $openAttendance, actionInFlight: $actionInFlight, failure: $failure, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AttendancePassStateCopyWith<$Res> implements $AttendancePassStateCopyWith<$Res> {
  factory _$AttendancePassStateCopyWith(_AttendancePassState value, $Res Function(_AttendancePassState) _then) = __$AttendancePassStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, AttendancePass? pass, AttendanceRecord? openAttendance, bool actionInFlight, Failure? failure, String? message
});




}
/// @nodoc
class __$AttendancePassStateCopyWithImpl<$Res>
    implements _$AttendancePassStateCopyWith<$Res> {
  __$AttendancePassStateCopyWithImpl(this._self, this._then);

  final _AttendancePassState _self;
  final $Res Function(_AttendancePassState) _then;

/// Create a copy of AttendancePassState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? pass = freezed,Object? openAttendance = freezed,Object? actionInFlight = null,Object? failure = freezed,Object? message = freezed,}) {
  return _then(_AttendancePassState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,pass: freezed == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as AttendancePass?,openAttendance: freezed == openAttendance ? _self.openAttendance : openAttendance // ignore: cast_nullable_to_non_nullable
as AttendanceRecord?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
