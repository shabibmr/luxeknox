// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trainers_directory_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrainersDirectoryState {

 LoadStatus get status; List<TrainerSummary> get items; bool get hasMore; String? get nextCursor; String? get query; bool get loadingMore; Failure? get failure;
/// Create a copy of TrainersDirectoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainersDirectoryStateCopyWith<TrainersDirectoryState> get copyWith => _$TrainersDirectoryStateCopyWithImpl<TrainersDirectoryState>(this as TrainersDirectoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainersDirectoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.query, query) || other.query == query)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),hasMore,nextCursor,query,loadingMore,failure);

@override
String toString() {
  return 'TrainersDirectoryState(status: $status, items: $items, hasMore: $hasMore, nextCursor: $nextCursor, query: $query, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TrainersDirectoryStateCopyWith<$Res>  {
  factory $TrainersDirectoryStateCopyWith(TrainersDirectoryState value, $Res Function(TrainersDirectoryState) _then) = _$TrainersDirectoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<TrainerSummary> items, bool hasMore, String? nextCursor, String? query, bool loadingMore, Failure? failure
});




}
/// @nodoc
class _$TrainersDirectoryStateCopyWithImpl<$Res>
    implements $TrainersDirectoryStateCopyWith<$Res> {
  _$TrainersDirectoryStateCopyWithImpl(this._self, this._then);

  final TrainersDirectoryState _self;
  final $Res Function(TrainersDirectoryState) _then;

/// Create a copy of TrainersDirectoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? hasMore = null,Object? nextCursor = freezed,Object? query = freezed,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TrainerSummary>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainersDirectoryState].
extension TrainersDirectoryStatePatterns on TrainersDirectoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainersDirectoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainersDirectoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainersDirectoryState value)  $default,){
final _that = this;
switch (_that) {
case _TrainersDirectoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainersDirectoryState value)?  $default,){
final _that = this;
switch (_that) {
case _TrainersDirectoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<TrainerSummary> items,  bool hasMore,  String? nextCursor,  String? query,  bool loadingMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainersDirectoryState() when $default != null:
return $default(_that.status,_that.items,_that.hasMore,_that.nextCursor,_that.query,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<TrainerSummary> items,  bool hasMore,  String? nextCursor,  String? query,  bool loadingMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _TrainersDirectoryState():
return $default(_that.status,_that.items,_that.hasMore,_that.nextCursor,_that.query,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<TrainerSummary> items,  bool hasMore,  String? nextCursor,  String? query,  bool loadingMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _TrainersDirectoryState() when $default != null:
return $default(_that.status,_that.items,_that.hasMore,_that.nextCursor,_that.query,_that.loadingMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _TrainersDirectoryState implements TrainersDirectoryState {
  const _TrainersDirectoryState({this.status = LoadStatus.initial, final  List<TrainerSummary> items = const <TrainerSummary>[], this.hasMore = false, this.nextCursor, this.query, this.loadingMore = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<TrainerSummary> _items;
@override@JsonKey() List<TrainerSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool hasMore;
@override final  String? nextCursor;
@override final  String? query;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;

/// Create a copy of TrainersDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainersDirectoryStateCopyWith<_TrainersDirectoryState> get copyWith => __$TrainersDirectoryStateCopyWithImpl<_TrainersDirectoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainersDirectoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.query, query) || other.query == query)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),hasMore,nextCursor,query,loadingMore,failure);

@override
String toString() {
  return 'TrainersDirectoryState(status: $status, items: $items, hasMore: $hasMore, nextCursor: $nextCursor, query: $query, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$TrainersDirectoryStateCopyWith<$Res> implements $TrainersDirectoryStateCopyWith<$Res> {
  factory _$TrainersDirectoryStateCopyWith(_TrainersDirectoryState value, $Res Function(_TrainersDirectoryState) _then) = __$TrainersDirectoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<TrainerSummary> items, bool hasMore, String? nextCursor, String? query, bool loadingMore, Failure? failure
});




}
/// @nodoc
class __$TrainersDirectoryStateCopyWithImpl<$Res>
    implements _$TrainersDirectoryStateCopyWith<$Res> {
  __$TrainersDirectoryStateCopyWithImpl(this._self, this._then);

  final _TrainersDirectoryState _self;
  final $Res Function(_TrainersDirectoryState) _then;

/// Create a copy of TrainersDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? hasMore = null,Object? nextCursor = freezed,Object? query = freezed,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_TrainersDirectoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TrainerSummary>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
