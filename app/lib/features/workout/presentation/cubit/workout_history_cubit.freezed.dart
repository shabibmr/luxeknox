// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutHistoryState {

 LoadStatus get status; List<WorkoutSession> get items; List<WorkoutPersonalRecord> get personalRecords;/// True after a successful fetch, so an empty history is still data.
 bool get hasLoaded; num get totalVolumeKg; String? get nextCursor; bool get hasMore; bool get loadingMore; Failure? get failure;
/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutHistoryStateCopyWith<WorkoutHistoryState> get copyWith => _$WorkoutHistoryStateCopyWithImpl<WorkoutHistoryState>(this as WorkoutHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.personalRecords, personalRecords)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.totalVolumeKg, totalVolumeKg) || other.totalVolumeKg == totalVolumeKg)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(personalRecords),hasLoaded,totalVolumeKg,nextCursor,hasMore,loadingMore,failure);

@override
String toString() {
  return 'WorkoutHistoryState(status: $status, items: $items, personalRecords: $personalRecords, hasLoaded: $hasLoaded, totalVolumeKg: $totalVolumeKg, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $WorkoutHistoryStateCopyWith<$Res>  {
  factory $WorkoutHistoryStateCopyWith(WorkoutHistoryState value, $Res Function(WorkoutHistoryState) _then) = _$WorkoutHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<WorkoutSession> items, List<WorkoutPersonalRecord> personalRecords, bool hasLoaded, num totalVolumeKg, String? nextCursor, bool hasMore, bool loadingMore, Failure? failure
});




}
/// @nodoc
class _$WorkoutHistoryStateCopyWithImpl<$Res>
    implements $WorkoutHistoryStateCopyWith<$Res> {
  _$WorkoutHistoryStateCopyWithImpl(this._self, this._then);

  final WorkoutHistoryState _self;
  final $Res Function(WorkoutHistoryState) _then;

/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? personalRecords = null,Object? hasLoaded = null,Object? totalVolumeKg = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkoutSession>,personalRecords: null == personalRecords ? _self.personalRecords : personalRecords // ignore: cast_nullable_to_non_nullable
as List<WorkoutPersonalRecord>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,totalVolumeKg: null == totalVolumeKg ? _self.totalVolumeKg : totalVolumeKg // ignore: cast_nullable_to_non_nullable
as num,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutHistoryState].
extension WorkoutHistoryStatePatterns on WorkoutHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<WorkoutSession> items,  List<WorkoutPersonalRecord> personalRecords,  bool hasLoaded,  num totalVolumeKg,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.personalRecords,_that.hasLoaded,_that.totalVolumeKg,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<WorkoutSession> items,  List<WorkoutPersonalRecord> personalRecords,  bool hasLoaded,  num totalVolumeKg,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _WorkoutHistoryState():
return $default(_that.status,_that.items,_that.personalRecords,_that.hasLoaded,_that.totalVolumeKg,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<WorkoutSession> items,  List<WorkoutPersonalRecord> personalRecords,  bool hasLoaded,  num totalVolumeKg,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.personalRecords,_that.hasLoaded,_that.totalVolumeKg,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutHistoryState implements WorkoutHistoryState {
  const _WorkoutHistoryState({this.status = LoadStatus.initial, final  List<WorkoutSession> items = const <WorkoutSession>[], final  List<WorkoutPersonalRecord> personalRecords = const <WorkoutPersonalRecord>[], this.hasLoaded = false, this.totalVolumeKg = 0, this.nextCursor, this.hasMore = false, this.loadingMore = false, this.failure}): _items = items,_personalRecords = personalRecords;
  

@override@JsonKey() final  LoadStatus status;
 final  List<WorkoutSession> _items;
@override@JsonKey() List<WorkoutSession> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<WorkoutPersonalRecord> _personalRecords;
@override@JsonKey() List<WorkoutPersonalRecord> get personalRecords {
  if (_personalRecords is EqualUnmodifiableListView) return _personalRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personalRecords);
}

/// True after a successful fetch, so an empty history is still data.
@override@JsonKey() final  bool hasLoaded;
@override@JsonKey() final  num totalVolumeKg;
@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;

/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutHistoryStateCopyWith<_WorkoutHistoryState> get copyWith => __$WorkoutHistoryStateCopyWithImpl<_WorkoutHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._personalRecords, _personalRecords)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.totalVolumeKg, totalVolumeKg) || other.totalVolumeKg == totalVolumeKg)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_personalRecords),hasLoaded,totalVolumeKg,nextCursor,hasMore,loadingMore,failure);

@override
String toString() {
  return 'WorkoutHistoryState(status: $status, items: $items, personalRecords: $personalRecords, hasLoaded: $hasLoaded, totalVolumeKg: $totalVolumeKg, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WorkoutHistoryStateCopyWith<$Res> implements $WorkoutHistoryStateCopyWith<$Res> {
  factory _$WorkoutHistoryStateCopyWith(_WorkoutHistoryState value, $Res Function(_WorkoutHistoryState) _then) = __$WorkoutHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<WorkoutSession> items, List<WorkoutPersonalRecord> personalRecords, bool hasLoaded, num totalVolumeKg, String? nextCursor, bool hasMore, bool loadingMore, Failure? failure
});




}
/// @nodoc
class __$WorkoutHistoryStateCopyWithImpl<$Res>
    implements _$WorkoutHistoryStateCopyWith<$Res> {
  __$WorkoutHistoryStateCopyWithImpl(this._self, this._then);

  final _WorkoutHistoryState _self;
  final $Res Function(_WorkoutHistoryState) _then;

/// Create a copy of WorkoutHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? personalRecords = null,Object? hasLoaded = null,Object? totalVolumeKg = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_WorkoutHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WorkoutSession>,personalRecords: null == personalRecords ? _self._personalRecords : personalRecords // ignore: cast_nullable_to_non_nullable
as List<WorkoutPersonalRecord>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,totalVolumeKg: null == totalVolumeKg ? _self.totalVolumeKg : totalVolumeKg // ignore: cast_nullable_to_non_nullable
as num,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
