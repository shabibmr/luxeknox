// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facilities_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FacilitiesState {

 LoadStatus get status; List<FacilityInfo> get items;/// True after a successful list, so an empty catalog is still data.
 bool get hasLoaded; bool get creating; Failure? get failure;
/// Create a copy of FacilitiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilitiesStateCopyWith<FacilitiesState> get copyWith => _$FacilitiesStateCopyWithImpl<FacilitiesState>(this as FacilitiesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FacilitiesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.creating, creating) || other.creating == creating)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),hasLoaded,creating,failure);

@override
String toString() {
  return 'FacilitiesState(status: $status, items: $items, hasLoaded: $hasLoaded, creating: $creating, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FacilitiesStateCopyWith<$Res>  {
  factory $FacilitiesStateCopyWith(FacilitiesState value, $Res Function(FacilitiesState) _then) = _$FacilitiesStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<FacilityInfo> items, bool hasLoaded, bool creating, Failure? failure
});




}
/// @nodoc
class _$FacilitiesStateCopyWithImpl<$Res>
    implements $FacilitiesStateCopyWith<$Res> {
  _$FacilitiesStateCopyWithImpl(this._self, this._then);

  final FacilitiesState _self;
  final $Res Function(FacilitiesState) _then;

/// Create a copy of FacilitiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? creating = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FacilityInfo>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [FacilitiesState].
extension FacilitiesStatePatterns on FacilitiesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FacilitiesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FacilitiesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FacilitiesState value)  $default,){
final _that = this;
switch (_that) {
case _FacilitiesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FacilitiesState value)?  $default,){
final _that = this;
switch (_that) {
case _FacilitiesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<FacilityInfo> items,  bool hasLoaded,  bool creating,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FacilitiesState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.creating,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<FacilityInfo> items,  bool hasLoaded,  bool creating,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _FacilitiesState():
return $default(_that.status,_that.items,_that.hasLoaded,_that.creating,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<FacilityInfo> items,  bool hasLoaded,  bool creating,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FacilitiesState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.creating,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FacilitiesState implements FacilitiesState {
  const _FacilitiesState({this.status = LoadStatus.initial, final  List<FacilityInfo> items = const <FacilityInfo>[], this.hasLoaded = false, this.creating = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<FacilityInfo> _items;
@override@JsonKey() List<FacilityInfo> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// True after a successful list, so an empty catalog is still data.
@override@JsonKey() final  bool hasLoaded;
@override@JsonKey() final  bool creating;
@override final  Failure? failure;

/// Create a copy of FacilitiesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilitiesStateCopyWith<_FacilitiesState> get copyWith => __$FacilitiesStateCopyWithImpl<_FacilitiesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FacilitiesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.creating, creating) || other.creating == creating)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),hasLoaded,creating,failure);

@override
String toString() {
  return 'FacilitiesState(status: $status, items: $items, hasLoaded: $hasLoaded, creating: $creating, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FacilitiesStateCopyWith<$Res> implements $FacilitiesStateCopyWith<$Res> {
  factory _$FacilitiesStateCopyWith(_FacilitiesState value, $Res Function(_FacilitiesState) _then) = __$FacilitiesStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<FacilityInfo> items, bool hasLoaded, bool creating, Failure? failure
});




}
/// @nodoc
class __$FacilitiesStateCopyWithImpl<$Res>
    implements _$FacilitiesStateCopyWith<$Res> {
  __$FacilitiesStateCopyWithImpl(this._self, this._then);

  final _FacilitiesState _self;
  final $Res Function(_FacilitiesState) _then;

/// Create a copy of FacilitiesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? creating = null,Object? failure = freezed,}) {
  return _then(_FacilitiesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FacilityInfo>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
