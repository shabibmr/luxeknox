// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan_versions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DietPlanVersionsState {

 LoadStatus get status; List<DietPlanVersion> get versions; String? get expandedId; Failure? get failure;
/// Create a copy of DietPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietPlanVersionsStateCopyWith<DietPlanVersionsState> get copyWith => _$DietPlanVersionsStateCopyWithImpl<DietPlanVersionsState>(this as DietPlanVersionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietPlanVersionsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.versions, versions)&&(identical(other.expandedId, expandedId) || other.expandedId == expandedId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(versions),expandedId,failure);

@override
String toString() {
  return 'DietPlanVersionsState(status: $status, versions: $versions, expandedId: $expandedId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DietPlanVersionsStateCopyWith<$Res>  {
  factory $DietPlanVersionsStateCopyWith(DietPlanVersionsState value, $Res Function(DietPlanVersionsState) _then) = _$DietPlanVersionsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<DietPlanVersion> versions, String? expandedId, Failure? failure
});




}
/// @nodoc
class _$DietPlanVersionsStateCopyWithImpl<$Res>
    implements $DietPlanVersionsStateCopyWith<$Res> {
  _$DietPlanVersionsStateCopyWithImpl(this._self, this._then);

  final DietPlanVersionsState _self;
  final $Res Function(DietPlanVersionsState) _then;

/// Create a copy of DietPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? versions = null,Object? expandedId = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<DietPlanVersion>,expandedId: freezed == expandedId ? _self.expandedId : expandedId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DietPlanVersionsState].
extension DietPlanVersionsStatePatterns on DietPlanVersionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietPlanVersionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietPlanVersionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietPlanVersionsState value)  $default,){
final _that = this;
switch (_that) {
case _DietPlanVersionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietPlanVersionsState value)?  $default,){
final _that = this;
switch (_that) {
case _DietPlanVersionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<DietPlanVersion> versions,  String? expandedId,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietPlanVersionsState() when $default != null:
return $default(_that.status,_that.versions,_that.expandedId,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<DietPlanVersion> versions,  String? expandedId,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DietPlanVersionsState():
return $default(_that.status,_that.versions,_that.expandedId,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<DietPlanVersion> versions,  String? expandedId,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DietPlanVersionsState() when $default != null:
return $default(_that.status,_that.versions,_that.expandedId,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DietPlanVersionsState implements DietPlanVersionsState {
  const _DietPlanVersionsState({this.status = LoadStatus.initial, final  List<DietPlanVersion> versions = const <DietPlanVersion>[], this.expandedId, this.failure}): _versions = versions;
  

@override@JsonKey() final  LoadStatus status;
 final  List<DietPlanVersion> _versions;
@override@JsonKey() List<DietPlanVersion> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}

@override final  String? expandedId;
@override final  Failure? failure;

/// Create a copy of DietPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietPlanVersionsStateCopyWith<_DietPlanVersionsState> get copyWith => __$DietPlanVersionsStateCopyWithImpl<_DietPlanVersionsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietPlanVersionsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._versions, _versions)&&(identical(other.expandedId, expandedId) || other.expandedId == expandedId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_versions),expandedId,failure);

@override
String toString() {
  return 'DietPlanVersionsState(status: $status, versions: $versions, expandedId: $expandedId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DietPlanVersionsStateCopyWith<$Res> implements $DietPlanVersionsStateCopyWith<$Res> {
  factory _$DietPlanVersionsStateCopyWith(_DietPlanVersionsState value, $Res Function(_DietPlanVersionsState) _then) = __$DietPlanVersionsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<DietPlanVersion> versions, String? expandedId, Failure? failure
});




}
/// @nodoc
class __$DietPlanVersionsStateCopyWithImpl<$Res>
    implements _$DietPlanVersionsStateCopyWith<$Res> {
  __$DietPlanVersionsStateCopyWithImpl(this._self, this._then);

  final _DietPlanVersionsState _self;
  final $Res Function(_DietPlanVersionsState) _then;

/// Create a copy of DietPlanVersionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? versions = null,Object? expandedId = freezed,Object? failure = freezed,}) {
  return _then(_DietPlanVersionsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<DietPlanVersion>,expandedId: freezed == expandedId ? _self.expandedId : expandedId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
