// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_ledger_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentsLedgerState {

 LoadStatus get status; PaymentsLedgerFilter get filter; List<Payment> get items; Failure? get failure;
/// Create a copy of PaymentsLedgerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsLedgerStateCopyWith<PaymentsLedgerState> get copyWith => _$PaymentsLedgerStateCopyWithImpl<PaymentsLedgerState>(this as PaymentsLedgerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsLedgerState&&(identical(other.status, status) || other.status == status)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,filter,const DeepCollectionEquality().hash(items),failure);

@override
String toString() {
  return 'PaymentsLedgerState(status: $status, filter: $filter, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PaymentsLedgerStateCopyWith<$Res>  {
  factory $PaymentsLedgerStateCopyWith(PaymentsLedgerState value, $Res Function(PaymentsLedgerState) _then) = _$PaymentsLedgerStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, PaymentsLedgerFilter filter, List<Payment> items, Failure? failure
});




}
/// @nodoc
class _$PaymentsLedgerStateCopyWithImpl<$Res>
    implements $PaymentsLedgerStateCopyWith<$Res> {
  _$PaymentsLedgerStateCopyWithImpl(this._self, this._then);

  final PaymentsLedgerState _self;
  final $Res Function(PaymentsLedgerState) _then;

/// Create a copy of PaymentsLedgerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? filter = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as PaymentsLedgerFilter,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Payment>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentsLedgerState].
extension PaymentsLedgerStatePatterns on PaymentsLedgerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentsLedgerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentsLedgerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentsLedgerState value)  $default,){
final _that = this;
switch (_that) {
case _PaymentsLedgerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentsLedgerState value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentsLedgerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  PaymentsLedgerFilter filter,  List<Payment> items,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentsLedgerState() when $default != null:
return $default(_that.status,_that.filter,_that.items,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  PaymentsLedgerFilter filter,  List<Payment> items,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PaymentsLedgerState():
return $default(_that.status,_that.filter,_that.items,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  PaymentsLedgerFilter filter,  List<Payment> items,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PaymentsLedgerState() when $default != null:
return $default(_that.status,_that.filter,_that.items,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentsLedgerState implements PaymentsLedgerState {
  const _PaymentsLedgerState({this.status = LoadStatus.initial, this.filter = PaymentsLedgerFilter.all, final  List<Payment> items = const <Payment>[], this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
@override@JsonKey() final  PaymentsLedgerFilter filter;
 final  List<Payment> _items;
@override@JsonKey() List<Payment> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Failure? failure;

/// Create a copy of PaymentsLedgerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentsLedgerStateCopyWith<_PaymentsLedgerState> get copyWith => __$PaymentsLedgerStateCopyWithImpl<_PaymentsLedgerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentsLedgerState&&(identical(other.status, status) || other.status == status)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,filter,const DeepCollectionEquality().hash(_items),failure);

@override
String toString() {
  return 'PaymentsLedgerState(status: $status, filter: $filter, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PaymentsLedgerStateCopyWith<$Res> implements $PaymentsLedgerStateCopyWith<$Res> {
  factory _$PaymentsLedgerStateCopyWith(_PaymentsLedgerState value, $Res Function(_PaymentsLedgerState) _then) = __$PaymentsLedgerStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, PaymentsLedgerFilter filter, List<Payment> items, Failure? failure
});




}
/// @nodoc
class __$PaymentsLedgerStateCopyWithImpl<$Res>
    implements _$PaymentsLedgerStateCopyWith<$Res> {
  __$PaymentsLedgerStateCopyWithImpl(this._self, this._then);

  final _PaymentsLedgerState _self;
  final $Res Function(_PaymentsLedgerState) _then;

/// Create a copy of PaymentsLedgerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? filter = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_PaymentsLedgerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as PaymentsLedgerFilter,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Payment>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
