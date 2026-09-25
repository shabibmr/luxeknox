// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_picker_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodPickerState {

 LoadStatus get status; List<Food> get items; Failure? get failure;
/// Create a copy of FoodPickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodPickerStateCopyWith<FoodPickerState> get copyWith => _$FoodPickerStateCopyWithImpl<FoodPickerState>(this as FoodPickerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodPickerState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),failure);

@override
String toString() {
  return 'FoodPickerState(status: $status, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FoodPickerStateCopyWith<$Res>  {
  factory $FoodPickerStateCopyWith(FoodPickerState value, $Res Function(FoodPickerState) _then) = _$FoodPickerStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<Food> items, Failure? failure
});




}
/// @nodoc
class _$FoodPickerStateCopyWithImpl<$Res>
    implements $FoodPickerStateCopyWith<$Res> {
  _$FoodPickerStateCopyWithImpl(this._self, this._then);

  final FoodPickerState _self;
  final $Res Function(FoodPickerState) _then;

/// Create a copy of FoodPickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Food>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodPickerState].
extension FoodPickerStatePatterns on FoodPickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodPickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodPickerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodPickerState value)  $default,){
final _that = this;
switch (_that) {
case _FoodPickerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodPickerState value)?  $default,){
final _that = this;
switch (_that) {
case _FoodPickerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<Food> items,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodPickerState() when $default != null:
return $default(_that.status,_that.items,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<Food> items,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _FoodPickerState():
return $default(_that.status,_that.items,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<Food> items,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FoodPickerState() when $default != null:
return $default(_that.status,_that.items,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FoodPickerState implements FoodPickerState {
  const _FoodPickerState({this.status = LoadStatus.initial, final  List<Food> items = const <Food>[], this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<Food> _items;
@override@JsonKey() List<Food> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Failure? failure;

/// Create a copy of FoodPickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodPickerStateCopyWith<_FoodPickerState> get copyWith => __$FoodPickerStateCopyWithImpl<_FoodPickerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodPickerState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),failure);

@override
String toString() {
  return 'FoodPickerState(status: $status, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FoodPickerStateCopyWith<$Res> implements $FoodPickerStateCopyWith<$Res> {
  factory _$FoodPickerStateCopyWith(_FoodPickerState value, $Res Function(_FoodPickerState) _then) = __$FoodPickerStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<Food> items, Failure? failure
});




}
/// @nodoc
class __$FoodPickerStateCopyWithImpl<$Res>
    implements _$FoodPickerStateCopyWith<$Res> {
  __$FoodPickerStateCopyWithImpl(this._self, this._then);

  final _FoodPickerState _self;
  final $Res Function(_FoodPickerState) _then;

/// Create a copy of FoodPickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_FoodPickerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Food>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
