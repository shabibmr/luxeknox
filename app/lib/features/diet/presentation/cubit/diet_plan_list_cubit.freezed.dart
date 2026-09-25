// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DietPlanListState {

 LoadStatus get status; List<DietPlan> get items; DietPlanListFilter get filter; Failure? get failure;
/// Create a copy of DietPlanListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietPlanListStateCopyWith<DietPlanListState> get copyWith => _$DietPlanListStateCopyWithImpl<DietPlanListState>(this as DietPlanListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietPlanListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),filter,failure);

@override
String toString() {
  return 'DietPlanListState(status: $status, items: $items, filter: $filter, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DietPlanListStateCopyWith<$Res>  {
  factory $DietPlanListStateCopyWith(DietPlanListState value, $Res Function(DietPlanListState) _then) = _$DietPlanListStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<DietPlan> items, DietPlanListFilter filter, Failure? failure
});




}
/// @nodoc
class _$DietPlanListStateCopyWithImpl<$Res>
    implements $DietPlanListStateCopyWith<$Res> {
  _$DietPlanListStateCopyWithImpl(this._self, this._then);

  final DietPlanListState _self;
  final $Res Function(DietPlanListState) _then;

/// Create a copy of DietPlanListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DietPlan>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DietPlanListFilter,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DietPlanListState].
extension DietPlanListStatePatterns on DietPlanListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietPlanListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietPlanListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietPlanListState value)  $default,){
final _that = this;
switch (_that) {
case _DietPlanListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietPlanListState value)?  $default,){
final _that = this;
switch (_that) {
case _DietPlanListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<DietPlan> items,  DietPlanListFilter filter,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietPlanListState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<DietPlan> items,  DietPlanListFilter filter,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DietPlanListState():
return $default(_that.status,_that.items,_that.filter,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<DietPlan> items,  DietPlanListFilter filter,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DietPlanListState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DietPlanListState implements DietPlanListState {
  const _DietPlanListState({this.status = LoadStatus.initial, final  List<DietPlan> items = const <DietPlan>[], this.filter = DietPlanListFilter.all, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<DietPlan> _items;
@override@JsonKey() List<DietPlan> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  DietPlanListFilter filter;
@override final  Failure? failure;

/// Create a copy of DietPlanListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietPlanListStateCopyWith<_DietPlanListState> get copyWith => __$DietPlanListStateCopyWithImpl<_DietPlanListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietPlanListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),filter,failure);

@override
String toString() {
  return 'DietPlanListState(status: $status, items: $items, filter: $filter, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DietPlanListStateCopyWith<$Res> implements $DietPlanListStateCopyWith<$Res> {
  factory _$DietPlanListStateCopyWith(_DietPlanListState value, $Res Function(_DietPlanListState) _then) = __$DietPlanListStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<DietPlan> items, DietPlanListFilter filter, Failure? failure
});




}
/// @nodoc
class __$DietPlanListStateCopyWithImpl<$Res>
    implements _$DietPlanListStateCopyWith<$Res> {
  __$DietPlanListStateCopyWithImpl(this._self, this._then);

  final _DietPlanListState _self;
  final $Res Function(_DietPlanListState) _then;

/// Create a copy of DietPlanListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? failure = freezed,}) {
  return _then(_DietPlanListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DietPlan>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DietPlanListFilter,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
