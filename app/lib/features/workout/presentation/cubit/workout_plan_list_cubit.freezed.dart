// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutPlanListState {

 LoadStatus get status; List<WorkoutPlan> get items;/// True after a successful fetch, so an empty filter result is still data.
 bool get hasLoaded; WorkoutPlanListFilter get filter; Failure? get failure;
/// Create a copy of WorkoutPlanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutPlanListStateCopyWith<WorkoutPlanListState> get copyWith => _$WorkoutPlanListStateCopyWithImpl<WorkoutPlanListState>(this as WorkoutPlanListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutPlanListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),hasLoaded,filter,failure);

@override
String toString() {
  return 'WorkoutPlanListState(status: $status, items: $items, hasLoaded: $hasLoaded, filter: $filter, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $WorkoutPlanListStateCopyWith<$Res>  {
  factory $WorkoutPlanListStateCopyWith(WorkoutPlanListState value, $Res Function(WorkoutPlanListState) _then) = _$WorkoutPlanListStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<WorkoutPlan> items, bool hasLoaded, WorkoutPlanListFilter filter, Failure? failure
});




}
/// @nodoc
class _$WorkoutPlanListStateCopyWithImpl<$Res>
    implements $WorkoutPlanListStateCopyWith<$Res> {
  _$WorkoutPlanListStateCopyWithImpl(this._self, this._then);

  final WorkoutPlanListState _self;
  final $Res Function(WorkoutPlanListState) _then;

/// Create a copy of WorkoutPlanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? filter = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkoutPlan>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as WorkoutPlanListFilter,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutPlanListState].
extension WorkoutPlanListStatePatterns on WorkoutPlanListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutPlanListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutPlanListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutPlanListState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutPlanListState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<WorkoutPlan> items,  bool hasLoaded,  WorkoutPlanListFilter filter,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutPlanListState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.filter,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<WorkoutPlan> items,  bool hasLoaded,  WorkoutPlanListFilter filter,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanListState():
return $default(_that.status,_that.items,_that.hasLoaded,_that.filter,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<WorkoutPlan> items,  bool hasLoaded,  WorkoutPlanListFilter filter,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanListState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.filter,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutPlanListState implements WorkoutPlanListState {
  const _WorkoutPlanListState({this.status = LoadStatus.initial, final  List<WorkoutPlan> items = const <WorkoutPlan>[], this.hasLoaded = false, this.filter = WorkoutPlanListFilter.all, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<WorkoutPlan> _items;
@override@JsonKey() List<WorkoutPlan> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// True after a successful fetch, so an empty filter result is still data.
@override@JsonKey() final  bool hasLoaded;
@override@JsonKey() final  WorkoutPlanListFilter filter;
@override final  Failure? failure;

/// Create a copy of WorkoutPlanListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutPlanListStateCopyWith<_WorkoutPlanListState> get copyWith => __$WorkoutPlanListStateCopyWithImpl<_WorkoutPlanListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutPlanListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),hasLoaded,filter,failure);

@override
String toString() {
  return 'WorkoutPlanListState(status: $status, items: $items, hasLoaded: $hasLoaded, filter: $filter, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WorkoutPlanListStateCopyWith<$Res> implements $WorkoutPlanListStateCopyWith<$Res> {
  factory _$WorkoutPlanListStateCopyWith(_WorkoutPlanListState value, $Res Function(_WorkoutPlanListState) _then) = __$WorkoutPlanListStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<WorkoutPlan> items, bool hasLoaded, WorkoutPlanListFilter filter, Failure? failure
});




}
/// @nodoc
class __$WorkoutPlanListStateCopyWithImpl<$Res>
    implements _$WorkoutPlanListStateCopyWith<$Res> {
  __$WorkoutPlanListStateCopyWithImpl(this._self, this._then);

  final _WorkoutPlanListState _self;
  final $Res Function(_WorkoutPlanListState) _then;

/// Create a copy of WorkoutPlanListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? filter = null,Object? failure = freezed,}) {
  return _then(_WorkoutPlanListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WorkoutPlan>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as WorkoutPlanListFilter,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
