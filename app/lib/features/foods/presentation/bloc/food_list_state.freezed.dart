// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodListState {

 LoadStatus get status; List<Food> get items; FoodFilter get filter; String? get cursor; bool get hasMore; Failure? get failure;
/// Create a copy of FoodListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodListStateCopyWith<FoodListState> get copyWith => _$FoodListStateCopyWithImpl<FoodListState>(this as FoodListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),filter,cursor,hasMore,failure);

@override
String toString() {
  return 'FoodListState(status: $status, items: $items, filter: $filter, cursor: $cursor, hasMore: $hasMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FoodListStateCopyWith<$Res>  {
  factory $FoodListStateCopyWith(FoodListState value, $Res Function(FoodListState) _then) = _$FoodListStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<Food> items, FoodFilter filter, String? cursor, bool hasMore, Failure? failure
});




}
/// @nodoc
class _$FoodListStateCopyWithImpl<$Res>
    implements $FoodListStateCopyWith<$Res> {
  _$FoodListStateCopyWithImpl(this._self, this._then);

  final FoodListState _self;
  final $Res Function(FoodListState) _then;

/// Create a copy of FoodListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? cursor = freezed,Object? hasMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Food>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as FoodFilter,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodListState].
extension FoodListStatePatterns on FoodListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodListState value)  $default,){
final _that = this;
switch (_that) {
case _FoodListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodListState value)?  $default,){
final _that = this;
switch (_that) {
case _FoodListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<Food> items,  FoodFilter filter,  String? cursor,  bool hasMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodListState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.cursor,_that.hasMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<Food> items,  FoodFilter filter,  String? cursor,  bool hasMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _FoodListState():
return $default(_that.status,_that.items,_that.filter,_that.cursor,_that.hasMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<Food> items,  FoodFilter filter,  String? cursor,  bool hasMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FoodListState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.cursor,_that.hasMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FoodListState implements FoodListState {
  const _FoodListState({this.status = LoadStatus.initial, final  List<Food> items = const <Food>[], this.filter = const FoodFilter(), this.cursor, this.hasMore = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<Food> _items;
@override@JsonKey() List<Food> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  FoodFilter filter;
@override final  String? cursor;
@override@JsonKey() final  bool hasMore;
@override final  Failure? failure;

/// Create a copy of FoodListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodListStateCopyWith<_FoodListState> get copyWith => __$FoodListStateCopyWithImpl<_FoodListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),filter,cursor,hasMore,failure);

@override
String toString() {
  return 'FoodListState(status: $status, items: $items, filter: $filter, cursor: $cursor, hasMore: $hasMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FoodListStateCopyWith<$Res> implements $FoodListStateCopyWith<$Res> {
  factory _$FoodListStateCopyWith(_FoodListState value, $Res Function(_FoodListState) _then) = __$FoodListStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<Food> items, FoodFilter filter, String? cursor, bool hasMore, Failure? failure
});




}
/// @nodoc
class __$FoodListStateCopyWithImpl<$Res>
    implements _$FoodListStateCopyWith<$Res> {
  __$FoodListStateCopyWithImpl(this._self, this._then);

  final _FoodListState _self;
  final $Res Function(_FoodListState) _then;

/// Create a copy of FoodListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? cursor = freezed,Object? hasMore = null,Object? failure = freezed,}) {
  return _then(_FoodListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Food>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as FoodFilter,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
