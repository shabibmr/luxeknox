// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_methods_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentMethodsState {

 LoadStatus get status; List<PaymentMethod> get items; bool get creating; Failure? get failure;
/// Create a copy of PaymentMethodsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodsStateCopyWith<PaymentMethodsState> get copyWith => _$PaymentMethodsStateCopyWithImpl<PaymentMethodsState>(this as PaymentMethodsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.creating, creating) || other.creating == creating)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),creating,failure);

@override
String toString() {
  return 'PaymentMethodsState(status: $status, items: $items, creating: $creating, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodsStateCopyWith<$Res>  {
  factory $PaymentMethodsStateCopyWith(PaymentMethodsState value, $Res Function(PaymentMethodsState) _then) = _$PaymentMethodsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<PaymentMethod> items, bool creating, Failure? failure
});




}
/// @nodoc
class _$PaymentMethodsStateCopyWithImpl<$Res>
    implements $PaymentMethodsStateCopyWith<$Res> {
  _$PaymentMethodsStateCopyWithImpl(this._self, this._then);

  final PaymentMethodsState _self;
  final $Res Function(PaymentMethodsState) _then;

/// Create a copy of PaymentMethodsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? creating = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodsState].
extension PaymentMethodsStatePatterns on PaymentMethodsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodsState value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodsState value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<PaymentMethod> items,  bool creating,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodsState() when $default != null:
return $default(_that.status,_that.items,_that.creating,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<PaymentMethod> items,  bool creating,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodsState():
return $default(_that.status,_that.items,_that.creating,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<PaymentMethod> items,  bool creating,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodsState() when $default != null:
return $default(_that.status,_that.items,_that.creating,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentMethodsState implements PaymentMethodsState {
  const _PaymentMethodsState({this.status = LoadStatus.initial, final  List<PaymentMethod> items = const <PaymentMethod>[], this.creating = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<PaymentMethod> _items;
@override@JsonKey() List<PaymentMethod> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool creating;
@override final  Failure? failure;

/// Create a copy of PaymentMethodsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodsStateCopyWith<_PaymentMethodsState> get copyWith => __$PaymentMethodsStateCopyWithImpl<_PaymentMethodsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.creating, creating) || other.creating == creating)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),creating,failure);

@override
String toString() {
  return 'PaymentMethodsState(status: $status, items: $items, creating: $creating, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodsStateCopyWith<$Res> implements $PaymentMethodsStateCopyWith<$Res> {
  factory _$PaymentMethodsStateCopyWith(_PaymentMethodsState value, $Res Function(_PaymentMethodsState) _then) = __$PaymentMethodsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<PaymentMethod> items, bool creating, Failure? failure
});




}
/// @nodoc
class __$PaymentMethodsStateCopyWithImpl<$Res>
    implements _$PaymentMethodsStateCopyWith<$Res> {
  __$PaymentMethodsStateCopyWithImpl(this._self, this._then);

  final _PaymentMethodsState _self;
  final $Res Function(_PaymentMethodsState) _then;

/// Create a copy of PaymentMethodsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? creating = null,Object? failure = freezed,}) {
  return _then(_PaymentMethodsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
