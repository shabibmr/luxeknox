// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_agenda_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardAgendaState {

 LoadStatus get status; List<ScheduleSession> get todayItems; List<ScheduleSession> get upcomingItems;/// True after a successful fetch, so an empty agenda is still data.
 bool get hasLoaded; UserType? get role; Failure? get failure;
/// Create a copy of DashboardAgendaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAgendaStateCopyWith<DashboardAgendaState> get copyWith => _$DashboardAgendaStateCopyWithImpl<DashboardAgendaState>(this as DashboardAgendaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAgendaState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.todayItems, todayItems)&&const DeepCollectionEquality().equals(other.upcomingItems, upcomingItems)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.role, role) || other.role == role)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(todayItems),const DeepCollectionEquality().hash(upcomingItems),hasLoaded,role,failure);

@override
String toString() {
  return 'DashboardAgendaState(status: $status, todayItems: $todayItems, upcomingItems: $upcomingItems, hasLoaded: $hasLoaded, role: $role, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DashboardAgendaStateCopyWith<$Res>  {
  factory $DashboardAgendaStateCopyWith(DashboardAgendaState value, $Res Function(DashboardAgendaState) _then) = _$DashboardAgendaStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<ScheduleSession> todayItems, List<ScheduleSession> upcomingItems, bool hasLoaded, UserType? role, Failure? failure
});




}
/// @nodoc
class _$DashboardAgendaStateCopyWithImpl<$Res>
    implements $DashboardAgendaStateCopyWith<$Res> {
  _$DashboardAgendaStateCopyWithImpl(this._self, this._then);

  final DashboardAgendaState _self;
  final $Res Function(DashboardAgendaState) _then;

/// Create a copy of DashboardAgendaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? todayItems = null,Object? upcomingItems = null,Object? hasLoaded = null,Object? role = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,todayItems: null == todayItems ? _self.todayItems : todayItems // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,upcomingItems: null == upcomingItems ? _self.upcomingItems : upcomingItems // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserType?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardAgendaState].
extension DashboardAgendaStatePatterns on DashboardAgendaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAgendaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAgendaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAgendaState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAgendaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAgendaState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAgendaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<ScheduleSession> todayItems,  List<ScheduleSession> upcomingItems,  bool hasLoaded,  UserType? role,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardAgendaState() when $default != null:
return $default(_that.status,_that.todayItems,_that.upcomingItems,_that.hasLoaded,_that.role,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<ScheduleSession> todayItems,  List<ScheduleSession> upcomingItems,  bool hasLoaded,  UserType? role,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DashboardAgendaState():
return $default(_that.status,_that.todayItems,_that.upcomingItems,_that.hasLoaded,_that.role,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<ScheduleSession> todayItems,  List<ScheduleSession> upcomingItems,  bool hasLoaded,  UserType? role,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DashboardAgendaState() when $default != null:
return $default(_that.status,_that.todayItems,_that.upcomingItems,_that.hasLoaded,_that.role,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardAgendaState implements DashboardAgendaState {
  const _DashboardAgendaState({this.status = LoadStatus.initial, final  List<ScheduleSession> todayItems = const <ScheduleSession>[], final  List<ScheduleSession> upcomingItems = const <ScheduleSession>[], this.hasLoaded = false, this.role, this.failure}): _todayItems = todayItems,_upcomingItems = upcomingItems;
  

@override@JsonKey() final  LoadStatus status;
 final  List<ScheduleSession> _todayItems;
@override@JsonKey() List<ScheduleSession> get todayItems {
  if (_todayItems is EqualUnmodifiableListView) return _todayItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todayItems);
}

 final  List<ScheduleSession> _upcomingItems;
@override@JsonKey() List<ScheduleSession> get upcomingItems {
  if (_upcomingItems is EqualUnmodifiableListView) return _upcomingItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcomingItems);
}

/// True after a successful fetch, so an empty agenda is still data.
@override@JsonKey() final  bool hasLoaded;
@override final  UserType? role;
@override final  Failure? failure;

/// Create a copy of DashboardAgendaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAgendaStateCopyWith<_DashboardAgendaState> get copyWith => __$DashboardAgendaStateCopyWithImpl<_DashboardAgendaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAgendaState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._todayItems, _todayItems)&&const DeepCollectionEquality().equals(other._upcomingItems, _upcomingItems)&&(identical(other.hasLoaded, hasLoaded) || other.hasLoaded == hasLoaded)&&(identical(other.role, role) || other.role == role)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_todayItems),const DeepCollectionEquality().hash(_upcomingItems),hasLoaded,role,failure);

@override
String toString() {
  return 'DashboardAgendaState(status: $status, todayItems: $todayItems, upcomingItems: $upcomingItems, hasLoaded: $hasLoaded, role: $role, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DashboardAgendaStateCopyWith<$Res> implements $DashboardAgendaStateCopyWith<$Res> {
  factory _$DashboardAgendaStateCopyWith(_DashboardAgendaState value, $Res Function(_DashboardAgendaState) _then) = __$DashboardAgendaStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<ScheduleSession> todayItems, List<ScheduleSession> upcomingItems, bool hasLoaded, UserType? role, Failure? failure
});




}
/// @nodoc
class __$DashboardAgendaStateCopyWithImpl<$Res>
    implements _$DashboardAgendaStateCopyWith<$Res> {
  __$DashboardAgendaStateCopyWithImpl(this._self, this._then);

  final _DashboardAgendaState _self;
  final $Res Function(_DashboardAgendaState) _then;

/// Create a copy of DashboardAgendaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? todayItems = null,Object? upcomingItems = null,Object? hasLoaded = null,Object? role = freezed,Object? failure = freezed,}) {
  return _then(_DashboardAgendaState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,todayItems: null == todayItems ? _self._todayItems : todayItems // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,upcomingItems: null == upcomingItems ? _self._upcomingItems : upcomingItems // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,hasLoaded: null == hasLoaded ? _self.hasLoaded : hasLoaded // ignore: cast_nullable_to_non_nullable
as bool,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserType?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
