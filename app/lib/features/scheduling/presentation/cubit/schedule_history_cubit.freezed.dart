// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleHistoryState {

 LoadStatus get status; List<ScheduleSession> get items;/// True after a successful fetch, so an empty archive is still data.
 bool get hasLoaded; String? get nextCursor; bool get hasMore; bool get loadingMore; Failure? get failure;
/// Create a copy of ScheduleHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleHistoryStateCopyWith<ScheduleHistoryState> get copyWith => _$ScheduleHistoryStateCopyWithImpl<ScheduleHistoryState>(this as ScheduleHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),hasLoaded,nextCursor,hasMore,loadingMore,failure);

@override
String toString() {
  return 'ScheduleHistoryState(status: $status, items: $items, hasLoaded: $hasLoaded, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ScheduleHistoryStateCopyWith<$Res>  {
  factory $ScheduleHistoryStateCopyWith(ScheduleHistoryState value, $Res Function(ScheduleHistoryState) _then) = _$ScheduleHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<ScheduleSession> items, bool hasLoaded, String? nextCursor, bool hasMore, bool loadingMore, Failure? failure
});




}
/// @nodoc
class _$ScheduleHistoryStateCopyWithImpl<$Res>
    implements $ScheduleHistoryStateCopyWith<$Res> {
  _$ScheduleHistoryStateCopyWithImpl(this._self, this._then);

  final ScheduleHistoryState _self;
  final $Res Function(ScheduleHistoryState) _then;

/// Create a copy of ScheduleHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleHistoryState].
extension ScheduleHistoryStatePatterns on ScheduleHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<ScheduleSession> items,  bool hasLoaded,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<ScheduleSession> items,  bool hasLoaded,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ScheduleHistoryState():
return $default(_that.status,_that.items,_that.hasLoaded,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<ScheduleSession> items,  bool hasLoaded,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleHistoryState implements ScheduleHistoryState {
  const _ScheduleHistoryState({this.status = LoadStatus.initial, final  List<ScheduleSession> items = const <ScheduleSession>[], this.hasLoaded = false, this.nextCursor, this.hasMore = false, this.loadingMore = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<ScheduleSession> _items;
@override@JsonKey() List<ScheduleSession> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// True after a successful fetch, so an empty archive is still data.
@override@JsonKey() final  bool hasLoaded;
@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;

/// Create a copy of ScheduleHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleHistoryStateCopyWith<_ScheduleHistoryState> get copyWith => __$ScheduleHistoryStateCopyWithImpl<_ScheduleHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),hasLoaded,nextCursor,hasMore,loadingMore,failure);

@override
String toString() {
  return 'ScheduleHistoryState(status: $status, items: $items, hasLoaded: $hasLoaded, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ScheduleHistoryStateCopyWith<$Res> implements $ScheduleHistoryStateCopyWith<$Res> {
  factory _$ScheduleHistoryStateCopyWith(_ScheduleHistoryState value, $Res Function(_ScheduleHistoryState) _then) = __$ScheduleHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<ScheduleSession> items, bool hasLoaded, String? nextCursor, bool hasMore, bool loadingMore, Failure? failure
});




}
/// @nodoc
class __$ScheduleHistoryStateCopyWithImpl<$Res>
    implements _$ScheduleHistoryStateCopyWith<$Res> {
  __$ScheduleHistoryStateCopyWithImpl(this._self, this._then);

  final _ScheduleHistoryState _self;
  final $Res Function(_ScheduleHistoryState) _then;

/// Create a copy of ScheduleHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_ScheduleHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
