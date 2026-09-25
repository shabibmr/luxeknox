// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_info_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthInfoState {

 LoadStatus get status; HealthInfo? get info; String? get message; Failure? get failure;
/// Create a copy of HealthInfoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthInfoStateCopyWith<HealthInfoState> get copyWith => _$HealthInfoStateCopyWithImpl<HealthInfoState>(this as HealthInfoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthInfoState&&(identical(other.status, status) || other.status == status)&&(identical(other.info, info) || other.info == info)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,info,message,failure);

@override
String toString() {
  return 'HealthInfoState(status: $status, info: $info, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HealthInfoStateCopyWith<$Res>  {
  factory $HealthInfoStateCopyWith(HealthInfoState value, $Res Function(HealthInfoState) _then) = _$HealthInfoStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, HealthInfo? info, String? message, Failure? failure
});




}
/// @nodoc
class _$HealthInfoStateCopyWithImpl<$Res>
    implements $HealthInfoStateCopyWith<$Res> {
  _$HealthInfoStateCopyWithImpl(this._self, this._then);

  final HealthInfoState _self;
  final $Res Function(HealthInfoState) _then;

/// Create a copy of HealthInfoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? info = freezed,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as HealthInfo?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthInfoState].
extension HealthInfoStatePatterns on HealthInfoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthInfoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthInfoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthInfoState value)  $default,){
final _that = this;
switch (_that) {
case _HealthInfoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthInfoState value)?  $default,){
final _that = this;
switch (_that) {
case _HealthInfoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  HealthInfo? info,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthInfoState() when $default != null:
return $default(_that.status,_that.info,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  HealthInfo? info,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _HealthInfoState():
return $default(_that.status,_that.info,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  HealthInfo? info,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _HealthInfoState() when $default != null:
return $default(_that.status,_that.info,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _HealthInfoState implements HealthInfoState {
  const _HealthInfoState({this.status = LoadStatus.initial, this.info, this.message, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  HealthInfo? info;
@override final  String? message;
@override final  Failure? failure;

/// Create a copy of HealthInfoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthInfoStateCopyWith<_HealthInfoState> get copyWith => __$HealthInfoStateCopyWithImpl<_HealthInfoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthInfoState&&(identical(other.status, status) || other.status == status)&&(identical(other.info, info) || other.info == info)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,info,message,failure);

@override
String toString() {
  return 'HealthInfoState(status: $status, info: $info, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$HealthInfoStateCopyWith<$Res> implements $HealthInfoStateCopyWith<$Res> {
  factory _$HealthInfoStateCopyWith(_HealthInfoState value, $Res Function(_HealthInfoState) _then) = __$HealthInfoStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, HealthInfo? info, String? message, Failure? failure
});




}
/// @nodoc
class __$HealthInfoStateCopyWithImpl<$Res>
    implements _$HealthInfoStateCopyWith<$Res> {
  __$HealthInfoStateCopyWithImpl(this._self, this._then);

  final _HealthInfoState _self;
  final $Res Function(_HealthInfoState) _then;

/// Create a copy of HealthInfoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? info = freezed,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_HealthInfoState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as HealthInfo?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
