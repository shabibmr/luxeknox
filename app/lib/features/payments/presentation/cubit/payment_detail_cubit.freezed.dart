// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentDetailState {

 LoadStatus get status; Payment? get payment; Failure? get failure;
/// Create a copy of PaymentDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentDetailStateCopyWith<PaymentDetailState> get copyWith => _$PaymentDetailStateCopyWithImpl<PaymentDetailState>(this as PaymentDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,payment,failure);

@override
String toString() {
  return 'PaymentDetailState(status: $status, payment: $payment, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PaymentDetailStateCopyWith<$Res>  {
  factory $PaymentDetailStateCopyWith(PaymentDetailState value, $Res Function(PaymentDetailState) _then) = _$PaymentDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Payment? payment, Failure? failure
});




}
/// @nodoc
class _$PaymentDetailStateCopyWithImpl<$Res>
    implements $PaymentDetailStateCopyWith<$Res> {
  _$PaymentDetailStateCopyWithImpl(this._self, this._then);

  final PaymentDetailState _self;
  final $Res Function(PaymentDetailState) _then;

/// Create a copy of PaymentDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? payment = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Payment?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentDetailState].
extension PaymentDetailStatePatterns on PaymentDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentDetailState value)  $default,){
final _that = this;
switch (_that) {
case _PaymentDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Payment? payment,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentDetailState() when $default != null:
return $default(_that.status,_that.payment,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Payment? payment,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PaymentDetailState():
return $default(_that.status,_that.payment,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Payment? payment,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PaymentDetailState() when $default != null:
return $default(_that.status,_that.payment,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentDetailState implements PaymentDetailState {
  const _PaymentDetailState({this.status = LoadStatus.initial, this.payment, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  Payment? payment;
@override final  Failure? failure;

/// Create a copy of PaymentDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentDetailStateCopyWith<_PaymentDetailState> get copyWith => __$PaymentDetailStateCopyWithImpl<_PaymentDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,payment,failure);

@override
String toString() {
  return 'PaymentDetailState(status: $status, payment: $payment, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PaymentDetailStateCopyWith<$Res> implements $PaymentDetailStateCopyWith<$Res> {
  factory _$PaymentDetailStateCopyWith(_PaymentDetailState value, $Res Function(_PaymentDetailState) _then) = __$PaymentDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Payment? payment, Failure? failure
});




}
/// @nodoc
class __$PaymentDetailStateCopyWithImpl<$Res>
    implements _$PaymentDetailStateCopyWith<$Res> {
  __$PaymentDetailStateCopyWithImpl(this._self, this._then);

  final _PaymentDetailState _self;
  final $Res Function(_PaymentDetailState) _then;

/// Create a copy of PaymentDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? payment = freezed,Object? failure = freezed,}) {
  return _then(_PaymentDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,payment: freezed == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as Payment?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
