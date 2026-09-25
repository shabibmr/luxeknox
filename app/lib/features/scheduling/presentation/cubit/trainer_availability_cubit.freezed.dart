// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trainer_availability_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrainerAvailabilityState {

 LoadStatus get status; List<TrainerAvailabilitySlot> get slots;/// True after a successful fetch, so an empty week is still data.
 bool get hasLoaded; bool get saving; Failure? get failure;
/// Create a copy of TrainerAvailabilityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainerAvailabilityStateCopyWith<TrainerAvailabilityState> get copyWith => _$TrainerAvailabilityStateCopyWithImpl<TrainerAvailabilityState>(this as TrainerAvailabilityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainerAvailabilityState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.slots, slots)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(slots),hasLoaded,saving,failure);

@override
String toString() {
  return 'TrainerAvailabilityState(status: $status, slots: $slots, hasLoaded: $hasLoaded, saving: $saving, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TrainerAvailabilityStateCopyWith<$Res>  {
  factory $TrainerAvailabilityStateCopyWith(TrainerAvailabilityState value, $Res Function(TrainerAvailabilityState) _then) = _$TrainerAvailabilityStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<TrainerAvailabilitySlot> slots, bool hasLoaded, bool saving, Failure? failure
});




}
/// @nodoc
class _$TrainerAvailabilityStateCopyWithImpl<$Res>
    implements $TrainerAvailabilityStateCopyWith<$Res> {
  _$TrainerAvailabilityStateCopyWithImpl(this._self, this._then);

  final TrainerAvailabilityState _self;
  final $Res Function(TrainerAvailabilityState) _then;

/// Create a copy of TrainerAvailabilityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? slots = null,Object? hasLoaded = null,Object? saving = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<TrainerAvailabilitySlot>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainerAvailabilityState].
extension TrainerAvailabilityStatePatterns on TrainerAvailabilityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainerAvailabilityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainerAvailabilityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainerAvailabilityState value)  $default,){
final _that = this;
switch (_that) {
case _TrainerAvailabilityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainerAvailabilityState value)?  $default,){
final _that = this;
switch (_that) {
case _TrainerAvailabilityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<TrainerAvailabilitySlot> slots,  bool hasLoaded,  bool saving,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainerAvailabilityState() when $default != null:
return $default(_that.status,_that.slots,_that.hasLoaded,_that.saving,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<TrainerAvailabilitySlot> slots,  bool hasLoaded,  bool saving,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _TrainerAvailabilityState():
return $default(_that.status,_that.slots,_that.hasLoaded,_that.saving,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<TrainerAvailabilitySlot> slots,  bool hasLoaded,  bool saving,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _TrainerAvailabilityState() when $default != null:
return $default(_that.status,_that.slots,_that.hasLoaded,_that.saving,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _TrainerAvailabilityState implements TrainerAvailabilityState {
  const _TrainerAvailabilityState({this.status = LoadStatus.initial, final  List<TrainerAvailabilitySlot> slots = const <TrainerAvailabilitySlot>[], this.hasLoaded = false, this.saving = false, this.failure}): _slots = slots;
  

@override@JsonKey() final  LoadStatus status;
 final  List<TrainerAvailabilitySlot> _slots;
@override@JsonKey() List<TrainerAvailabilitySlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

/// True after a successful fetch, so an empty week is still data.
@override@JsonKey() final  bool hasLoaded;
@override@JsonKey() final  bool saving;
@override final  Failure? failure;

/// Create a copy of TrainerAvailabilityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainerAvailabilityStateCopyWith<_TrainerAvailabilityState> get copyWith => __$TrainerAvailabilityStateCopyWithImpl<_TrainerAvailabilityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainerAvailabilityState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._slots, _slots)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_slots),hasLoaded,saving,failure);

@override
String toString() {
  return 'TrainerAvailabilityState(status: $status, slots: $slots, hasLoaded: $hasLoaded, saving: $saving, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$TrainerAvailabilityStateCopyWith<$Res> implements $TrainerAvailabilityStateCopyWith<$Res> {
  factory _$TrainerAvailabilityStateCopyWith(_TrainerAvailabilityState value, $Res Function(_TrainerAvailabilityState) _then) = __$TrainerAvailabilityStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<TrainerAvailabilitySlot> slots, bool hasLoaded, bool saving, Failure? failure
});




}
/// @nodoc
class __$TrainerAvailabilityStateCopyWithImpl<$Res>
    implements _$TrainerAvailabilityStateCopyWith<$Res> {
  __$TrainerAvailabilityStateCopyWithImpl(this._self, this._then);

  final _TrainerAvailabilityState _self;
  final $Res Function(_TrainerAvailabilityState) _then;

/// Create a copy of TrainerAvailabilityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? slots = null,Object? hasLoaded = null,Object? saving = null,Object? failure = freezed,}) {
  return _then(_TrainerAvailabilityState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<TrainerAvailabilitySlot>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
