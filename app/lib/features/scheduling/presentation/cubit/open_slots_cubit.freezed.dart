// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_slots_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenSlotsState {

 LoadStatus get status; bool get hasLoaded; TrainerSummary? get trainer; bool get missingTrainer; List<BookableOpenSlot> get slots; DateTime? get selectedDay; List<DateTime> get days; Failure? get failure;/// Set when a book attempt hit 409 so the UI can show a stale-slot message.
 bool get staleSlot;
/// Create a copy of OpenSlotsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenSlotsStateCopyWith<OpenSlotsState> get copyWith => _$OpenSlotsStateCopyWithImpl<OpenSlotsState>(this as OpenSlotsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenSlotsState&&(identical(other.status, status) || other.status == status)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.trainer, trainer) || other.trainer == trainer)&&(identical(other.missingTrainer, missingTrainer) || other.missingTrainer == missingTrainer)&&const DeepCollectionEquality().equals(other.slots, slots)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.staleSlot, staleSlot) || other.staleSlot == staleSlot));
}


@override
int get hashCode => Object.hash(runtimeType,status,hasLoaded,trainer,missingTrainer,const DeepCollectionEquality().hash(slots),selectedDay,const DeepCollectionEquality().hash(days),failure,staleSlot);

@override
String toString() {
  return 'OpenSlotsState(status: $status, hasLoaded: $hasLoaded, trainer: $trainer, missingTrainer: $missingTrainer, slots: $slots, selectedDay: $selectedDay, days: $days, failure: $failure, staleSlot: $staleSlot)';
}


}

/// @nodoc
abstract mixin class $OpenSlotsStateCopyWith<$Res>  {
  factory $OpenSlotsStateCopyWith(OpenSlotsState value, $Res Function(OpenSlotsState) _then) = _$OpenSlotsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, bool hasLoaded, TrainerSummary? trainer, bool missingTrainer, List<BookableOpenSlot> slots, DateTime? selectedDay, List<DateTime> days, Failure? failure, bool staleSlot
});




}
/// @nodoc
class _$OpenSlotsStateCopyWithImpl<$Res>
    implements $OpenSlotsStateCopyWith<$Res> {
  _$OpenSlotsStateCopyWithImpl(this._self, this._then);

  final OpenSlotsState _self;
  final $Res Function(OpenSlotsState) _then;

/// Create a copy of OpenSlotsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? hasLoaded = null,Object? trainer = freezed,Object? missingTrainer = null,Object? slots = null,Object? selectedDay = freezed,Object? days = null,Object? failure = freezed,Object? staleSlot = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,trainer: freezed == trainer ? _self.trainer : trainer // ignore: cast_nullable_to_non_nullable
as TrainerSummary?,missingTrainer: null == missingTrainer ? _self.missingTrainer : missingTrainer // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<BookableOpenSlot>,selectedDay: freezed == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as DateTime?,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DateTime>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,staleSlot: null == staleSlot ? _self.staleSlot : staleSlot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenSlotsState].
extension OpenSlotsStatePatterns on OpenSlotsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenSlotsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenSlotsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenSlotsState value)  $default,){
final _that = this;
switch (_that) {
case _OpenSlotsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenSlotsState value)?  $default,){
final _that = this;
switch (_that) {
case _OpenSlotsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  bool hasLoaded,  TrainerSummary? trainer,  bool missingTrainer,  List<BookableOpenSlot> slots,  DateTime? selectedDay,  List<DateTime> days,  Failure? failure,  bool staleSlot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenSlotsState() when $default != null:
return $default(_that.status,_that.hasLoaded,_that.trainer,_that.missingTrainer,_that.slots,_that.selectedDay,_that.days,_that.failure,_that.staleSlot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  bool hasLoaded,  TrainerSummary? trainer,  bool missingTrainer,  List<BookableOpenSlot> slots,  DateTime? selectedDay,  List<DateTime> days,  Failure? failure,  bool staleSlot)  $default,) {final _that = this;
switch (_that) {
case _OpenSlotsState():
return $default(_that.status,_that.hasLoaded,_that.trainer,_that.missingTrainer,_that.slots,_that.selectedDay,_that.days,_that.failure,_that.staleSlot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  bool hasLoaded,  TrainerSummary? trainer,  bool missingTrainer,  List<BookableOpenSlot> slots,  DateTime? selectedDay,  List<DateTime> days,  Failure? failure,  bool staleSlot)?  $default,) {final _that = this;
switch (_that) {
case _OpenSlotsState() when $default != null:
return $default(_that.status,_that.hasLoaded,_that.trainer,_that.missingTrainer,_that.slots,_that.selectedDay,_that.days,_that.failure,_that.staleSlot);case _:
  return null;

}
}

}

/// @nodoc


class _OpenSlotsState implements OpenSlotsState {
  const _OpenSlotsState({this.status = LoadStatus.initial, this.hasLoaded = false, this.trainer, this.missingTrainer = false, final  List<BookableOpenSlot> slots = const <BookableOpenSlot>[], this.selectedDay, final  List<DateTime> days = const <DateTime>[], this.failure, this.staleSlot = false}): _slots = slots,_days = days;
  

@override@JsonKey() final  LoadStatus status;
@override@JsonKey() final  bool hasLoaded;
@override final  TrainerSummary? trainer;
@override@JsonKey() final  bool missingTrainer;
 final  List<BookableOpenSlot> _slots;
@override@JsonKey() List<BookableOpenSlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

@override final  DateTime? selectedDay;
 final  List<DateTime> _days;
@override@JsonKey() List<DateTime> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

@override final  Failure? failure;
/// Set when a book attempt hit 409 so the UI can show a stale-slot message.
@override@JsonKey() final  bool staleSlot;

/// Create a copy of OpenSlotsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenSlotsStateCopyWith<_OpenSlotsState> get copyWith => __$OpenSlotsStateCopyWithImpl<_OpenSlotsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenSlotsState&&(identical(other.status, status) || other.status == status)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.trainer, trainer) || other.trainer == trainer)&&(identical(other.missingTrainer, missingTrainer) || other.missingTrainer == missingTrainer)&&const DeepCollectionEquality().equals(other._slots, _slots)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.staleSlot, staleSlot) || other.staleSlot == staleSlot));
}


@override
int get hashCode => Object.hash(runtimeType,status,hasLoaded,trainer,missingTrainer,const DeepCollectionEquality().hash(_slots),selectedDay,const DeepCollectionEquality().hash(_days),failure,staleSlot);

@override
String toString() {
  return 'OpenSlotsState(status: $status, hasLoaded: $hasLoaded, trainer: $trainer, missingTrainer: $missingTrainer, slots: $slots, selectedDay: $selectedDay, days: $days, failure: $failure, staleSlot: $staleSlot)';
}


}

/// @nodoc
abstract mixin class _$OpenSlotsStateCopyWith<$Res> implements $OpenSlotsStateCopyWith<$Res> {
  factory _$OpenSlotsStateCopyWith(_OpenSlotsState value, $Res Function(_OpenSlotsState) _then) = __$OpenSlotsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, bool hasLoaded, TrainerSummary? trainer, bool missingTrainer, List<BookableOpenSlot> slots, DateTime? selectedDay, List<DateTime> days, Failure? failure, bool staleSlot
});




}
/// @nodoc
class __$OpenSlotsStateCopyWithImpl<$Res>
    implements _$OpenSlotsStateCopyWith<$Res> {
  __$OpenSlotsStateCopyWithImpl(this._self, this._then);

  final _OpenSlotsState _self;
  final $Res Function(_OpenSlotsState) _then;

/// Create a copy of OpenSlotsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? hasLoaded = null,Object? trainer = freezed,Object? missingTrainer = null,Object? slots = null,Object? selectedDay = freezed,Object? days = null,Object? failure = freezed,Object? staleSlot = null,}) {
  return _then(_OpenSlotsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,trainer: freezed == trainer ? _self.trainer : trainer // ignore: cast_nullable_to_non_nullable
as TrainerSummary?,missingTrainer: null == missingTrainer ? _self.missingTrainer : missingTrainer // ignore: cast_nullable_to_non_nullable
as bool,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<BookableOpenSlot>,selectedDay: freezed == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as DateTime?,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DateTime>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,staleSlot: null == staleSlot ? _self.staleSlot : staleSlot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
