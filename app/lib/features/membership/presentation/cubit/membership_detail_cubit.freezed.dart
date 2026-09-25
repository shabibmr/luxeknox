// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipDetailState {

 LoadStatus get status; Membership? get membership; Failure? get failure; bool get actionInFlight;
/// Create a copy of MembershipDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipDetailStateCopyWith<MembershipDetailState> get copyWith => _$MembershipDetailStateCopyWithImpl<MembershipDetailState>(this as MembershipDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,failure,actionInFlight);

@override
String toString() {
  return 'MembershipDetailState(status: $status, membership: $membership, failure: $failure, actionInFlight: $actionInFlight)';
}


}

/// @nodoc
abstract mixin class $MembershipDetailStateCopyWith<$Res>  {
  factory $MembershipDetailStateCopyWith(MembershipDetailState value, $Res Function(MembershipDetailState) _then) = _$MembershipDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Membership? membership, Failure? failure, bool actionInFlight
});




}
/// @nodoc
class _$MembershipDetailStateCopyWithImpl<$Res>
    implements $MembershipDetailStateCopyWith<$Res> {
  _$MembershipDetailStateCopyWithImpl(this._self, this._then);

  final MembershipDetailState _self;
  final $Res Function(MembershipDetailState) _then;

/// Create a copy of MembershipDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? membership = freezed,Object? failure = freezed,Object? actionInFlight = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipDetailState].
extension MembershipDetailStatePatterns on MembershipDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipDetailState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  Failure? failure,  bool actionInFlight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipDetailState() when $default != null:
return $default(_that.status,_that.membership,_that.failure,_that.actionInFlight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  Failure? failure,  bool actionInFlight)  $default,) {final _that = this;
switch (_that) {
case _MembershipDetailState():
return $default(_that.status,_that.membership,_that.failure,_that.actionInFlight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Membership? membership,  Failure? failure,  bool actionInFlight)?  $default,) {final _that = this;
switch (_that) {
case _MembershipDetailState() when $default != null:
return $default(_that.status,_that.membership,_that.failure,_that.actionInFlight);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipDetailState implements MembershipDetailState {
  const _MembershipDetailState({this.status = LoadStatus.initial, this.membership, this.failure, this.actionInFlight = false});
  

@override@JsonKey() final  LoadStatus status;
@override final  Membership? membership;
@override final  Failure? failure;
@override@JsonKey() final  bool actionInFlight;

/// Create a copy of MembershipDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipDetailStateCopyWith<_MembershipDetailState> get copyWith => __$MembershipDetailStateCopyWithImpl<_MembershipDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.actionInFlight, actionInFlight) || other.actionInFlight == actionInFlight));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,failure,actionInFlight);

@override
String toString() {
  return 'MembershipDetailState(status: $status, membership: $membership, failure: $failure, actionInFlight: $actionInFlight)';
}


}

/// @nodoc
abstract mixin class _$MembershipDetailStateCopyWith<$Res> implements $MembershipDetailStateCopyWith<$Res> {
  factory _$MembershipDetailStateCopyWith(_MembershipDetailState value, $Res Function(_MembershipDetailState) _then) = __$MembershipDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Membership? membership, Failure? failure, bool actionInFlight
});




}
/// @nodoc
class __$MembershipDetailStateCopyWithImpl<$Res>
    implements _$MembershipDetailStateCopyWith<$Res> {
  __$MembershipDetailStateCopyWithImpl(this._self, this._then);

  final _MembershipDetailState _self;
  final $Res Function(_MembershipDetailState) _then;

/// Create a copy of MembershipDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? membership = freezed,Object? failure = freezed,Object? actionInFlight = null,}) {
  return _then(_MembershipDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,actionInFlight: null == actionInFlight ? _self.actionInFlight : actionInFlight // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
