// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_meal_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DietMealDetailState {

 LoadStatus get status; DietPlanMeal? get meal; Failure? get failure;
/// Create a copy of DietMealDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietMealDetailStateCopyWith<DietMealDetailState> get copyWith => _$DietMealDetailStateCopyWithImpl<DietMealDetailState>(this as DietMealDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietMealDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,meal,failure);

@override
String toString() {
  return 'DietMealDetailState(status: $status, meal: $meal, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DietMealDetailStateCopyWith<$Res>  {
  factory $DietMealDetailStateCopyWith(DietMealDetailState value, $Res Function(DietMealDetailState) _then) = _$DietMealDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, DietPlanMeal? meal, Failure? failure
});




}
/// @nodoc
class _$DietMealDetailStateCopyWithImpl<$Res>
    implements $DietMealDetailStateCopyWith<$Res> {
  _$DietMealDetailStateCopyWithImpl(this._self, this._then);

  final DietMealDetailState _self;
  final $Res Function(DietMealDetailState) _then;

/// Create a copy of DietMealDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? meal = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,meal: freezed == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as DietPlanMeal?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DietMealDetailState].
extension DietMealDetailStatePatterns on DietMealDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietMealDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietMealDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietMealDetailState value)  $default,){
final _that = this;
switch (_that) {
case _DietMealDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietMealDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _DietMealDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  DietPlanMeal? meal,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietMealDetailState() when $default != null:
return $default(_that.status,_that.meal,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  DietPlanMeal? meal,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DietMealDetailState():
return $default(_that.status,_that.meal,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  DietPlanMeal? meal,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DietMealDetailState() when $default != null:
return $default(_that.status,_that.meal,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DietMealDetailState implements DietMealDetailState {
  const _DietMealDetailState({this.status = LoadStatus.initial, this.meal, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  DietPlanMeal? meal;
@override final  Failure? failure;

/// Create a copy of DietMealDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietMealDetailStateCopyWith<_DietMealDetailState> get copyWith => __$DietMealDetailStateCopyWithImpl<_DietMealDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietMealDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,meal,failure);

@override
String toString() {
  return 'DietMealDetailState(status: $status, meal: $meal, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DietMealDetailStateCopyWith<$Res> implements $DietMealDetailStateCopyWith<$Res> {
  factory _$DietMealDetailStateCopyWith(_DietMealDetailState value, $Res Function(_DietMealDetailState) _then) = __$DietMealDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, DietPlanMeal? meal, Failure? failure
});




}
/// @nodoc
class __$DietMealDetailStateCopyWithImpl<$Res>
    implements _$DietMealDetailStateCopyWith<$Res> {
  __$DietMealDetailStateCopyWithImpl(this._self, this._then);

  final _DietMealDetailState _self;
  final $Res Function(_DietMealDetailState) _then;

/// Create a copy of DietMealDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? meal = freezed,Object? failure = freezed,}) {
  return _then(_DietMealDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,meal: freezed == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as DietPlanMeal?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
