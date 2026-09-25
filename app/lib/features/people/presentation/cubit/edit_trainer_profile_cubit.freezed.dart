// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_trainer_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditTrainerProfileState {

 LoadStatus get status; TrainerProfile? get profile; String? get message; Failure? get failure;
/// Create a copy of EditTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditTrainerProfileStateCopyWith<EditTrainerProfileState> get copyWith => _$EditTrainerProfileStateCopyWithImpl<EditTrainerProfileState>(this as EditTrainerProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditTrainerProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,message,failure);

@override
String toString() {
  return 'EditTrainerProfileState(status: $status, profile: $profile, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EditTrainerProfileStateCopyWith<$Res>  {
  factory $EditTrainerProfileStateCopyWith(EditTrainerProfileState value, $Res Function(EditTrainerProfileState) _then) = _$EditTrainerProfileStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, TrainerProfile? profile, String? message, Failure? failure
});




}
/// @nodoc
class _$EditTrainerProfileStateCopyWithImpl<$Res>
    implements $EditTrainerProfileStateCopyWith<$Res> {
  _$EditTrainerProfileStateCopyWithImpl(this._self, this._then);

  final EditTrainerProfileState _self;
  final $Res Function(EditTrainerProfileState) _then;

/// Create a copy of EditTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profile = freezed,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as TrainerProfile?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditTrainerProfileState].
extension EditTrainerProfileStatePatterns on EditTrainerProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditTrainerProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditTrainerProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditTrainerProfileState value)  $default,){
final _that = this;
switch (_that) {
case _EditTrainerProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditTrainerProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _EditTrainerProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  TrainerProfile? profile,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditTrainerProfileState() when $default != null:
return $default(_that.status,_that.profile,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  TrainerProfile? profile,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EditTrainerProfileState():
return $default(_that.status,_that.profile,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  TrainerProfile? profile,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EditTrainerProfileState() when $default != null:
return $default(_that.status,_that.profile,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EditTrainerProfileState implements EditTrainerProfileState {
  const _EditTrainerProfileState({this.status = LoadStatus.initial, this.profile, this.message, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  TrainerProfile? profile;
@override final  String? message;
@override final  Failure? failure;

/// Create a copy of EditTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditTrainerProfileStateCopyWith<_EditTrainerProfileState> get copyWith => __$EditTrainerProfileStateCopyWithImpl<_EditTrainerProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditTrainerProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,message,failure);

@override
String toString() {
  return 'EditTrainerProfileState(status: $status, profile: $profile, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EditTrainerProfileStateCopyWith<$Res> implements $EditTrainerProfileStateCopyWith<$Res> {
  factory _$EditTrainerProfileStateCopyWith(_EditTrainerProfileState value, $Res Function(_EditTrainerProfileState) _then) = __$EditTrainerProfileStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, TrainerProfile? profile, String? message, Failure? failure
});




}
/// @nodoc
class __$EditTrainerProfileStateCopyWithImpl<$Res>
    implements _$EditTrainerProfileStateCopyWith<$Res> {
  __$EditTrainerProfileStateCopyWithImpl(this._self, this._then);

  final _EditTrainerProfileState _self;
  final $Res Function(_EditTrainerProfileState) _then;

/// Create a copy of EditTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profile = freezed,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_EditTrainerProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as TrainerProfile?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
