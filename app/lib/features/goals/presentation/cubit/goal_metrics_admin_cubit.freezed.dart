// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_metrics_admin_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalMetricsAdminState {

 LoadStatus get status; List<GoalMetric> get items; bool get submitting; Failure? get failure;
/// Create a copy of GoalMetricsAdminState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalMetricsAdminStateCopyWith<GoalMetricsAdminState> get copyWith => _$GoalMetricsAdminStateCopyWithImpl<GoalMetricsAdminState>(this as GoalMetricsAdminState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalMetricsAdminState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),submitting,failure);

@override
String toString() {
  return 'GoalMetricsAdminState(status: $status, items: $items, submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $GoalMetricsAdminStateCopyWith<$Res>  {
  factory $GoalMetricsAdminStateCopyWith(GoalMetricsAdminState value, $Res Function(GoalMetricsAdminState) _then) = _$GoalMetricsAdminStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<GoalMetric> items, bool submitting, Failure? failure
});




}
/// @nodoc
class _$GoalMetricsAdminStateCopyWithImpl<$Res>
    implements $GoalMetricsAdminStateCopyWith<$Res> {
  _$GoalMetricsAdminStateCopyWithImpl(this._self, this._then);

  final GoalMetricsAdminState _self;
  final $Res Function(GoalMetricsAdminState) _then;

/// Create a copy of GoalMetricsAdminState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? submitting = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<GoalMetric>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalMetricsAdminState].
extension GoalMetricsAdminStatePatterns on GoalMetricsAdminState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalMetricsAdminState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalMetricsAdminState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalMetricsAdminState value)  $default,){
final _that = this;
switch (_that) {
case _GoalMetricsAdminState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalMetricsAdminState value)?  $default,){
final _that = this;
switch (_that) {
case _GoalMetricsAdminState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<GoalMetric> items,  bool submitting,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalMetricsAdminState() when $default != null:
return $default(_that.status,_that.items,_that.submitting,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<GoalMetric> items,  bool submitting,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _GoalMetricsAdminState():
return $default(_that.status,_that.items,_that.submitting,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<GoalMetric> items,  bool submitting,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _GoalMetricsAdminState() when $default != null:
return $default(_that.status,_that.items,_that.submitting,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _GoalMetricsAdminState implements GoalMetricsAdminState {
  const _GoalMetricsAdminState({this.status = LoadStatus.initial, final  List<GoalMetric> items = const <GoalMetric>[], this.submitting = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<GoalMetric> _items;
@override@JsonKey() List<GoalMetric> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool submitting;
@override final  Failure? failure;

/// Create a copy of GoalMetricsAdminState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalMetricsAdminStateCopyWith<_GoalMetricsAdminState> get copyWith => __$GoalMetricsAdminStateCopyWithImpl<_GoalMetricsAdminState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalMetricsAdminState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),submitting,failure);

@override
String toString() {
  return 'GoalMetricsAdminState(status: $status, items: $items, submitting: $submitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$GoalMetricsAdminStateCopyWith<$Res> implements $GoalMetricsAdminStateCopyWith<$Res> {
  factory _$GoalMetricsAdminStateCopyWith(_GoalMetricsAdminState value, $Res Function(_GoalMetricsAdminState) _then) = __$GoalMetricsAdminStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<GoalMetric> items, bool submitting, Failure? failure
});




}
/// @nodoc
class __$GoalMetricsAdminStateCopyWithImpl<$Res>
    implements _$GoalMetricsAdminStateCopyWith<$Res> {
  __$GoalMetricsAdminStateCopyWithImpl(this._self, this._then);

  final _GoalMetricsAdminState _self;
  final $Res Function(_GoalMetricsAdminState) _then;

/// Create a copy of GoalMetricsAdminState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? submitting = null,Object? failure = freezed,}) {
  return _then(_GoalMetricsAdminState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<GoalMetric>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
