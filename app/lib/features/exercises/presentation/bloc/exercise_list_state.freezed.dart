// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseListState {

 LoadStatus get status; List<Exercise> get items; ExerciseFilter get filter; String? get cursor; bool get hasMore; Failure? get failure;
/// Create a copy of ExerciseListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseListStateCopyWith<ExerciseListState> get copyWith => _$ExerciseListStateCopyWithImpl<ExerciseListState>(this as ExerciseListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),filter,cursor,hasMore,failure);

@override
String toString() {
  return 'ExerciseListState(status: $status, items: $items, filter: $filter, cursor: $cursor, hasMore: $hasMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExerciseListStateCopyWith<$Res>  {
  factory $ExerciseListStateCopyWith(ExerciseListState value, $Res Function(ExerciseListState) _then) = _$ExerciseListStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<Exercise> items, ExerciseFilter filter, String? cursor, bool hasMore, Failure? failure
});




}
/// @nodoc
class _$ExerciseListStateCopyWithImpl<$Res>
    implements $ExerciseListStateCopyWith<$Res> {
  _$ExerciseListStateCopyWithImpl(this._self, this._then);

  final ExerciseListState _self;
  final $Res Function(ExerciseListState) _then;

/// Create a copy of ExerciseListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? cursor = freezed,Object? hasMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Exercise>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ExerciseFilter,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseListState].
extension ExerciseListStatePatterns on ExerciseListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseListState value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseListState value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<Exercise> items,  ExerciseFilter filter,  String? cursor,  bool hasMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseListState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<Exercise> items,  ExerciseFilter filter,  String? cursor,  bool hasMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ExerciseListState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<Exercise> items,  ExerciseFilter filter,  String? cursor,  bool hasMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseListState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.cursor,_that.hasMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseListState implements ExerciseListState {
  const _ExerciseListState({this.status = LoadStatus.initial, final  List<Exercise> items = const <Exercise>[], this.filter = const ExerciseFilter(), this.cursor, this.hasMore = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<Exercise> _items;
@override@JsonKey() List<Exercise> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  ExerciseFilter filter;
@override final  String? cursor;
@override@JsonKey() final  bool hasMore;
@override final  Failure? failure;

/// Create a copy of ExerciseListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseListStateCopyWith<_ExerciseListState> get copyWith => __$ExerciseListStateCopyWithImpl<_ExerciseListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),filter,cursor,hasMore,failure);

@override
String toString() {
  return 'ExerciseListState(status: $status, items: $items, filter: $filter, cursor: $cursor, hasMore: $hasMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ExerciseListStateCopyWith<$Res> implements $ExerciseListStateCopyWith<$Res> {
  factory _$ExerciseListStateCopyWith(_ExerciseListState value, $Res Function(_ExerciseListState) _then) = __$ExerciseListStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<Exercise> items, ExerciseFilter filter, String? cursor, bool hasMore, Failure? failure
});




}
/// @nodoc
class __$ExerciseListStateCopyWithImpl<$Res>
    implements _$ExerciseListStateCopyWith<$Res> {
  __$ExerciseListStateCopyWithImpl(this._self, this._then);

  final _ExerciseListState _self;
  final $Res Function(_ExerciseListState) _then;

/// Create a copy of ExerciseListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? cursor = freezed,Object? hasMore = null,Object? failure = freezed,}) {
  return _then(_ExerciseListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Exercise>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ExerciseFilter,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
