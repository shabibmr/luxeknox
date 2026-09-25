// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_card_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipCardState {

 LoadStatus get status; Membership? get membership; Failure? get failure; bool get requestingFreeze;
/// Create a copy of MembershipCardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipCardStateCopyWith<MembershipCardState> get copyWith => _$MembershipCardStateCopyWithImpl<MembershipCardState>(this as MembershipCardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipCardState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.requestingFreeze, requestingFreeze) || other.requestingFreeze == requestingFreeze));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,failure,requestingFreeze);

@override
String toString() {
  return 'MembershipCardState(status: $status, membership: $membership, failure: $failure, requestingFreeze: $requestingFreeze)';
}


}

/// @nodoc
abstract mixin class $MembershipCardStateCopyWith<$Res>  {
  factory $MembershipCardStateCopyWith(MembershipCardState value, $Res Function(MembershipCardState) _then) = _$MembershipCardStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Membership? membership, Failure? failure, bool requestingFreeze
});




}
/// @nodoc
class _$MembershipCardStateCopyWithImpl<$Res>
    implements $MembershipCardStateCopyWith<$Res> {
  _$MembershipCardStateCopyWithImpl(this._self, this._then);

  final MembershipCardState _self;
  final $Res Function(MembershipCardState) _then;

/// Create a copy of MembershipCardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? membership = freezed,Object? failure = freezed,Object? requestingFreeze = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,requestingFreeze: null == requestingFreeze ? _self.requestingFreeze : requestingFreeze // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipCardState].
extension MembershipCardStatePatterns on MembershipCardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipCardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipCardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipCardState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipCardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipCardState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipCardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  Failure? failure,  bool requestingFreeze)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipCardState() when $default != null:
return $default(_that.status,_that.membership,_that.failure,_that.requestingFreeze);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  Failure? failure,  bool requestingFreeze)  $default,) {final _that = this;
switch (_that) {
case _MembershipCardState():
return $default(_that.status,_that.membership,_that.failure,_that.requestingFreeze);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Membership? membership,  Failure? failure,  bool requestingFreeze)?  $default,) {final _that = this;
switch (_that) {
case _MembershipCardState() when $default != null:
return $default(_that.status,_that.membership,_that.failure,_that.requestingFreeze);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipCardState implements MembershipCardState {
  const _MembershipCardState({this.status = LoadStatus.initial, this.membership, this.failure, this.requestingFreeze = false});
  

@override@JsonKey() final  LoadStatus status;
@override final  Membership? membership;
@override final  Failure? failure;
@override@JsonKey() final  bool requestingFreeze;

/// Create a copy of MembershipCardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipCardStateCopyWith<_MembershipCardState> get copyWith => __$MembershipCardStateCopyWithImpl<_MembershipCardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipCardState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.requestingFreeze, requestingFreeze) || other.requestingFreeze == requestingFreeze));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,failure,requestingFreeze);

@override
String toString() {
  return 'MembershipCardState(status: $status, membership: $membership, failure: $failure, requestingFreeze: $requestingFreeze)';
}


}

/// @nodoc
abstract mixin class _$MembershipCardStateCopyWith<$Res> implements $MembershipCardStateCopyWith<$Res> {
  factory _$MembershipCardStateCopyWith(_MembershipCardState value, $Res Function(_MembershipCardState) _then) = __$MembershipCardStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Membership? membership, Failure? failure, bool requestingFreeze
});




}
/// @nodoc
class __$MembershipCardStateCopyWithImpl<$Res>
    implements _$MembershipCardStateCopyWith<$Res> {
  __$MembershipCardStateCopyWithImpl(this._self, this._then);

  final _MembershipCardState _self;
  final $Res Function(_MembershipCardState) _then;

/// Create a copy of MembershipCardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? membership = freezed,Object? failure = freezed,Object? requestingFreeze = null,}) {
  return _then(_MembershipCardState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,requestingFreeze: null == requestingFreeze ? _self.requestingFreeze : requestingFreeze // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
