// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan_versions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutPlanVersionsState {

 LoadStatus get status; List<WorkoutPlanVersion> get versions;/// True after a successful fetch, so an empty history is still data.
 bool get hasLoaded; String? get expandedId; Failure? get failure;
/// Create a copy of WorkoutPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutPlanVersionsStateCopyWith<WorkoutPlanVersionsState> get copyWith => _$WorkoutPlanVersionsStateCopyWithImpl<WorkoutPlanVersionsState>(this as WorkoutPlanVersionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutPlanVersionsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.expandedId, expandedId) || other.expandedId == expandedId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(versions),hasLoaded,expandedId,failure);

@override
String toString() {
  return 'WorkoutPlanVersionsState(status: $status, versions: $versions, hasLoaded: $hasLoaded, expandedId: $expandedId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $WorkoutPlanVersionsStateCopyWith<$Res>  {
  factory $WorkoutPlanVersionsStateCopyWith(WorkoutPlanVersionsState value, $Res Function(WorkoutPlanVersionsState) _then) = _$WorkoutPlanVersionsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<WorkoutPlanVersion> versions, bool hasLoaded, String? expandedId, Failure? failure
});




}
/// @nodoc
class _$WorkoutPlanVersionsStateCopyWithImpl<$Res>
    implements $WorkoutPlanVersionsStateCopyWith<$Res> {
  _$WorkoutPlanVersionsStateCopyWithImpl(this._self, this._then);

  final WorkoutPlanVersionsState _self;
  final $Res Function(WorkoutPlanVersionsState) _then;

/// Create a copy of WorkoutPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? versions = null,Object? hasLoaded = null,Object? expandedId = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<WorkoutPlanVersion>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,expandedId: freezed == expandedId ? _self.expandedId : expandedId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutPlanVersionsState].
extension WorkoutPlanVersionsStatePatterns on WorkoutPlanVersionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutPlanVersionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutPlanVersionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutPlanVersionsState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanVersionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutPlanVersionsState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanVersionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<WorkoutPlanVersion> versions,  bool hasLoaded,  String? expandedId,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutPlanVersionsState() when $default != null:
return $default(_that.status,_that.versions,_that.hasLoaded,_that.expandedId,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<WorkoutPlanVersion> versions,  bool hasLoaded,  String? expandedId,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanVersionsState():
return $default(_that.status,_that.versions,_that.hasLoaded,_that.expandedId,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<WorkoutPlanVersion> versions,  bool hasLoaded,  String? expandedId,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanVersionsState() when $default != null:
return $default(_that.status,_that.versions,_that.hasLoaded,_that.expandedId,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutPlanVersionsState implements WorkoutPlanVersionsState {
  const _WorkoutPlanVersionsState({this.status = LoadStatus.initial, final  List<WorkoutPlanVersion> versions = const <WorkoutPlanVersion>[], this.hasLoaded = false, this.expandedId, this.failure}): _versions = versions;
  

@override@JsonKey() final  LoadStatus status;
 final  List<WorkoutPlanVersion> _versions;
@override@JsonKey() List<WorkoutPlanVersion> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}

/// True after a successful fetch, so an empty history is still data.
@override@JsonKey() final  bool hasLoaded;
@override final  String? expandedId;
@override final  Failure? failure;

/// Create a copy of WorkoutPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutPlanVersionsStateCopyWith<_WorkoutPlanVersionsState> get copyWith => __$WorkoutPlanVersionsStateCopyWithImpl<_WorkoutPlanVersionsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutPlanVersionsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._versions, _versions)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.expandedId, expandedId) || other.expandedId == expandedId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_versions),hasLoaded,expandedId,failure);

@override
String toString() {
  return 'WorkoutPlanVersionsState(status: $status, versions: $versions, hasLoaded: $hasLoaded, expandedId: $expandedId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WorkoutPlanVersionsStateCopyWith<$Res> implements $WorkoutPlanVersionsStateCopyWith<$Res> {
  factory _$WorkoutPlanVersionsStateCopyWith(_WorkoutPlanVersionsState value, $Res Function(_WorkoutPlanVersionsState) _then) = __$WorkoutPlanVersionsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<WorkoutPlanVersion> versions, bool hasLoaded, String? expandedId, Failure? failure
});




}
/// @nodoc
class __$WorkoutPlanVersionsStateCopyWithImpl<$Res>
    implements _$WorkoutPlanVersionsStateCopyWith<$Res> {
  __$WorkoutPlanVersionsStateCopyWithImpl(this._self, this._then);

  final _WorkoutPlanVersionsState _self;
  final $Res Function(_WorkoutPlanVersionsState) _then;

/// Create a copy of WorkoutPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? versions = null,Object? hasLoaded = null,Object? expandedId = freezed,Object? failure = freezed,}) {
  return _then(_WorkoutPlanVersionsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<WorkoutPlanVersion>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,expandedId: freezed == expandedId ? _self.expandedId : expandedId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
