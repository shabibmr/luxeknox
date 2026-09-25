// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_trainer_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyTrainerProfileState {

 LoadStatus get status; TrainerSummary? get trainer; Failure? get failure;
/// Create a copy of MyTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTrainerProfileStateCopyWith<MyTrainerProfileState> get copyWith => _$MyTrainerProfileStateCopyWithImpl<MyTrainerProfileState>(this as MyTrainerProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTrainerProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.trainer, trainer) || other.trainer == trainer)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,trainer,failure);

@override
String toString() {
  return 'MyTrainerProfileState(status: $status, trainer: $trainer, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MyTrainerProfileStateCopyWith<$Res>  {
  factory $MyTrainerProfileStateCopyWith(MyTrainerProfileState value, $Res Function(MyTrainerProfileState) _then) = _$MyTrainerProfileStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, TrainerSummary? trainer, Failure? failure
});




}
/// @nodoc
class _$MyTrainerProfileStateCopyWithImpl<$Res>
    implements $MyTrainerProfileStateCopyWith<$Res> {
  _$MyTrainerProfileStateCopyWithImpl(this._self, this._then);

  final MyTrainerProfileState _self;
  final $Res Function(MyTrainerProfileState) _then;

/// Create a copy of MyTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? trainer = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,trainer: freezed == trainer ? _self.trainer : trainer // ignore: cast_nullable_to_non_nullable
as TrainerSummary?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyTrainerProfileState].
extension MyTrainerProfileStatePatterns on MyTrainerProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyTrainerProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyTrainerProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyTrainerProfileState value)  $default,){
final _that = this;
switch (_that) {
case _MyTrainerProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyTrainerProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _MyTrainerProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  TrainerSummary? trainer,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyTrainerProfileState() when $default != null:
return $default(_that.status,_that.trainer,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  TrainerSummary? trainer,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MyTrainerProfileState():
return $default(_that.status,_that.trainer,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  TrainerSummary? trainer,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MyTrainerProfileState() when $default != null:
return $default(_that.status,_that.trainer,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MyTrainerProfileState implements MyTrainerProfileState {
  const _MyTrainerProfileState({this.status = LoadStatus.initial, this.trainer, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  TrainerSummary? trainer;
@override final  Failure? failure;

/// Create a copy of MyTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyTrainerProfileStateCopyWith<_MyTrainerProfileState> get copyWith => __$MyTrainerProfileStateCopyWithImpl<_MyTrainerProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyTrainerProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.trainer, trainer) || other.trainer == trainer)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,trainer,failure);

@override
String toString() {
  return 'MyTrainerProfileState(status: $status, trainer: $trainer, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MyTrainerProfileStateCopyWith<$Res> implements $MyTrainerProfileStateCopyWith<$Res> {
  factory _$MyTrainerProfileStateCopyWith(_MyTrainerProfileState value, $Res Function(_MyTrainerProfileState) _then) = __$MyTrainerProfileStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, TrainerSummary? trainer, Failure? failure
});




}
/// @nodoc
class __$MyTrainerProfileStateCopyWithImpl<$Res>
    implements _$MyTrainerProfileStateCopyWith<$Res> {
  __$MyTrainerProfileStateCopyWithImpl(this._self, this._then);

  final _MyTrainerProfileState _self;
  final $Res Function(_MyTrainerProfileState) _then;

/// Create a copy of MyTrainerProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? trainer = freezed,Object? failure = freezed,}) {
  return _then(_MyTrainerProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,trainer: freezed == trainer ? _self.trainer : trainer // ignore: cast_nullable_to_non_nullable
as TrainerSummary?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
