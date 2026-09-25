// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_alerts_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SystemAlertsState {

 LoadStatus get status; List<SystemAlert> get items; bool get hasMore; String? get nextCursor; bool get loadingMore; Failure? get failure;
/// Create a copy of SystemAlertsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemAlertsStateCopyWith<SystemAlertsState> get copyWith => _$SystemAlertsStateCopyWithImpl<SystemAlertsState>(this as SystemAlertsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemAlertsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),hasMore,nextCursor,loadingMore,failure);

@override
String toString() {
  return 'SystemAlertsState(status: $status, items: $items, hasMore: $hasMore, nextCursor: $nextCursor, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SystemAlertsStateCopyWith<$Res>  {
  factory $SystemAlertsStateCopyWith(SystemAlertsState value, $Res Function(SystemAlertsState) _then) = _$SystemAlertsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<SystemAlert> items, bool hasMore, String? nextCursor, bool loadingMore, Failure? failure
});




}
/// @nodoc
class _$SystemAlertsStateCopyWithImpl<$Res>
    implements $SystemAlertsStateCopyWith<$Res> {
  _$SystemAlertsStateCopyWithImpl(this._self, this._then);

  final SystemAlertsState _self;
  final $Res Function(SystemAlertsState) _then;

/// Create a copy of SystemAlertsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? hasMore = null,Object? nextCursor = freezed,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SystemAlert>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemAlertsState].
extension SystemAlertsStatePatterns on SystemAlertsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemAlertsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemAlertsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemAlertsState value)  $default,){
final _that = this;
switch (_that) {
case _SystemAlertsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemAlertsState value)?  $default,){
final _that = this;
switch (_that) {
case _SystemAlertsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<SystemAlert> items,  bool hasMore,  String? nextCursor,  bool loadingMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemAlertsState() when $default != null:
return $default(_that.status,_that.items,_that.hasMore,_that.nextCursor,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<SystemAlert> items,  bool hasMore,  String? nextCursor,  bool loadingMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SystemAlertsState():
return $default(_that.status,_that.items,_that.hasMore,_that.nextCursor,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<SystemAlert> items,  bool hasMore,  String? nextCursor,  bool loadingMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SystemAlertsState() when $default != null:
return $default(_that.status,_that.items,_that.hasMore,_that.nextCursor,_that.loadingMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SystemAlertsState implements SystemAlertsState {
  const _SystemAlertsState({this.status = LoadStatus.initial, final  List<SystemAlert> items = const <SystemAlert>[], this.hasMore = false, this.nextCursor, this.loadingMore = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<SystemAlert> _items;
@override@JsonKey() List<SystemAlert> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool hasMore;
@override final  String? nextCursor;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;

/// Create a copy of SystemAlertsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemAlertsStateCopyWith<_SystemAlertsState> get copyWith => __$SystemAlertsStateCopyWithImpl<_SystemAlertsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemAlertsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),hasMore,nextCursor,loadingMore,failure);

@override
String toString() {
  return 'SystemAlertsState(status: $status, items: $items, hasMore: $hasMore, nextCursor: $nextCursor, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SystemAlertsStateCopyWith<$Res> implements $SystemAlertsStateCopyWith<$Res> {
  factory _$SystemAlertsStateCopyWith(_SystemAlertsState value, $Res Function(_SystemAlertsState) _then) = __$SystemAlertsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<SystemAlert> items, bool hasMore, String? nextCursor, bool loadingMore, Failure? failure
});




}
/// @nodoc
class __$SystemAlertsStateCopyWithImpl<$Res>
    implements _$SystemAlertsStateCopyWith<$Res> {
  __$SystemAlertsStateCopyWithImpl(this._self, this._then);

  final _SystemAlertsState _self;
  final $Res Function(_SystemAlertsState) _then;

/// Create a copy of SystemAlertsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? hasMore = null,Object? nextCursor = freezed,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_SystemAlertsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SystemAlert>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
