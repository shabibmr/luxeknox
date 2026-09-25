// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_calendar_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleCalendarState {

 LoadStatus get status; List<ScheduleSession> get items;/// True after a successful fetch, so an empty range is still data.
 bool get hasLoaded; DateTime? get from; DateTime? get to; Failure? get failure;
/// Create a copy of ScheduleCalendarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCalendarStateCopyWith<ScheduleCalendarState> get copyWith => _$ScheduleCalendarStateCopyWithImpl<ScheduleCalendarState>(this as ScheduleCalendarState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleCalendarState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),hasLoaded,from,to,failure);

@override
String toString() {
  return 'ScheduleCalendarState(status: $status, items: $items, hasLoaded: $hasLoaded, from: $from, to: $to, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ScheduleCalendarStateCopyWith<$Res>  {
  factory $ScheduleCalendarStateCopyWith(ScheduleCalendarState value, $Res Function(ScheduleCalendarState) _then) = _$ScheduleCalendarStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<ScheduleSession> items, bool hasLoaded, DateTime? from, DateTime? to, Failure? failure
});




}
/// @nodoc
class _$ScheduleCalendarStateCopyWithImpl<$Res>
    implements $ScheduleCalendarStateCopyWith<$Res> {
  _$ScheduleCalendarStateCopyWithImpl(this._self, this._then);

  final ScheduleCalendarState _self;
  final $Res Function(ScheduleCalendarState) _then;

/// Create a copy of ScheduleCalendarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? from = freezed,Object? to = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleCalendarState].
extension ScheduleCalendarStatePatterns on ScheduleCalendarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleCalendarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleCalendarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleCalendarState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleCalendarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleCalendarState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleCalendarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<ScheduleSession> items,  bool hasLoaded,  DateTime? from,  DateTime? to,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleCalendarState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.from,_that.to,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<ScheduleSession> items,  bool hasLoaded,  DateTime? from,  DateTime? to,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ScheduleCalendarState():
return $default(_that.status,_that.items,_that.hasLoaded,_that.from,_that.to,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<ScheduleSession> items,  bool hasLoaded,  DateTime? from,  DateTime? to,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleCalendarState() when $default != null:
return $default(_that.status,_that.items,_that.hasLoaded,_that.from,_that.to,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleCalendarState implements ScheduleCalendarState {
  const _ScheduleCalendarState({this.status = LoadStatus.initial, final  List<ScheduleSession> items = const <ScheduleSession>[], this.hasLoaded = false, this.from, this.to, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<ScheduleSession> _items;
@override@JsonKey() List<ScheduleSession> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// True after a successful fetch, so an empty range is still data.
@override@JsonKey() final  bool hasLoaded;
@override final  DateTime? from;
@override final  DateTime? to;
@override final  Failure? failure;

/// Create a copy of ScheduleCalendarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCalendarStateCopyWith<_ScheduleCalendarState> get copyWith => __$ScheduleCalendarStateCopyWithImpl<_ScheduleCalendarState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleCalendarState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),hasLoaded,from,to,failure);

@override
String toString() {
  return 'ScheduleCalendarState(status: $status, items: $items, hasLoaded: $hasLoaded, from: $from, to: $to, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCalendarStateCopyWith<$Res> implements $ScheduleCalendarStateCopyWith<$Res> {
  factory _$ScheduleCalendarStateCopyWith(_ScheduleCalendarState value, $Res Function(_ScheduleCalendarState) _then) = __$ScheduleCalendarStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<ScheduleSession> items, bool hasLoaded, DateTime? from, DateTime? to, Failure? failure
});




}
/// @nodoc
class __$ScheduleCalendarStateCopyWithImpl<$Res>
    implements _$ScheduleCalendarStateCopyWith<$Res> {
  __$ScheduleCalendarStateCopyWithImpl(this._self, this._then);

  final _ScheduleCalendarState _self;
  final $Res Function(_ScheduleCalendarState) _then;

/// Create a copy of ScheduleCalendarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? hasLoaded = null,Object? from = freezed,Object? to = freezed,Object? failure = freezed,}) {
  return _then(_ScheduleCalendarState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
