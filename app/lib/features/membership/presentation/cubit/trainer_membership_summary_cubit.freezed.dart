// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trainer_membership_summary_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrainerMembershipSummaryState {

 LoadStatus get status; Membership? get membership; Failure? get failure;
/// Create a copy of TrainerMembershipSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainerMembershipSummaryStateCopyWith<TrainerMembershipSummaryState> get copyWith => _$TrainerMembershipSummaryStateCopyWithImpl<TrainerMembershipSummaryState>(this as TrainerMembershipSummaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainerMembershipSummaryState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,failure);

@override
String toString() {
  return 'TrainerMembershipSummaryState(status: $status, membership: $membership, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TrainerMembershipSummaryStateCopyWith<$Res>  {
  factory $TrainerMembershipSummaryStateCopyWith(TrainerMembershipSummaryState value, $Res Function(TrainerMembershipSummaryState) _then) = _$TrainerMembershipSummaryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Membership? membership, Failure? failure
});




}
/// @nodoc
class _$TrainerMembershipSummaryStateCopyWithImpl<$Res>
    implements $TrainerMembershipSummaryStateCopyWith<$Res> {
  _$TrainerMembershipSummaryStateCopyWithImpl(this._self, this._then);

  final TrainerMembershipSummaryState _self;
  final $Res Function(TrainerMembershipSummaryState) _then;

/// Create a copy of TrainerMembershipSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? membership = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainerMembershipSummaryState].
extension TrainerMembershipSummaryStatePatterns on TrainerMembershipSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainerMembershipSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainerMembershipSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainerMembershipSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _TrainerMembershipSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainerMembershipSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _TrainerMembershipSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainerMembershipSummaryState() when $default != null:
return $default(_that.status,_that.membership,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _TrainerMembershipSummaryState():
return $default(_that.status,_that.membership,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Membership? membership,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _TrainerMembershipSummaryState() when $default != null:
return $default(_that.status,_that.membership,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _TrainerMembershipSummaryState implements TrainerMembershipSummaryState {
  const _TrainerMembershipSummaryState({this.status = LoadStatus.initial, this.membership, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  Membership? membership;
@override final  Failure? failure;

/// Create a copy of TrainerMembershipSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainerMembershipSummaryStateCopyWith<_TrainerMembershipSummaryState> get copyWith => __$TrainerMembershipSummaryStateCopyWithImpl<_TrainerMembershipSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainerMembershipSummaryState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,failure);

@override
String toString() {
  return 'TrainerMembershipSummaryState(status: $status, membership: $membership, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$TrainerMembershipSummaryStateCopyWith<$Res> implements $TrainerMembershipSummaryStateCopyWith<$Res> {
  factory _$TrainerMembershipSummaryStateCopyWith(_TrainerMembershipSummaryState value, $Res Function(_TrainerMembershipSummaryState) _then) = __$TrainerMembershipSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Membership? membership, Failure? failure
});




}
/// @nodoc
class __$TrainerMembershipSummaryStateCopyWithImpl<$Res>
    implements _$TrainerMembershipSummaryStateCopyWith<$Res> {
  __$TrainerMembershipSummaryStateCopyWithImpl(this._self, this._then);

  final _TrainerMembershipSummaryState _self;
  final $Res Function(_TrainerMembershipSummaryState) _then;

/// Create a copy of TrainerMembershipSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? membership = freezed,Object? failure = freezed,}) {
  return _then(_TrainerMembershipSummaryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
