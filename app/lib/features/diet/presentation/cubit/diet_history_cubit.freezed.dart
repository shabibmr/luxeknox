// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DietHistoryState {

 LoadStatus get status; List<DietLog> get logs; DietDateRange get selectedRange; num? get averageAdherenceScore; num? get averageCaloriesConsumed; int? get averageWaterIntakeMl; int get totalLoggedDays; Failure? get failure;
/// Create a copy of DietHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietHistoryStateCopyWith<DietHistoryState> get copyWith => _$DietHistoryStateCopyWithImpl<DietHistoryState>(this as DietHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.logs, logs)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange)&&(identical(other.averageAdherenceScore, averageAdherenceScore) || other.averageAdherenceScore == averageAdherenceScore)&&(identical(other.averageCaloriesConsumed, averageCaloriesConsumed) || other.averageCaloriesConsumed == averageCaloriesConsumed)&&(identical(other.averageWaterIntakeMl, averageWaterIntakeMl) || other.averageWaterIntakeMl == averageWaterIntakeMl)&&(identical(other.totalLoggedDays, totalLoggedDays) || other.totalLoggedDays == totalLoggedDays)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(logs),selectedRange,averageAdherenceScore,averageCaloriesConsumed,averageWaterIntakeMl,totalLoggedDays,failure);

@override
String toString() {
  return 'DietHistoryState(status: $status, logs: $logs, selectedRange: $selectedRange, averageAdherenceScore: $averageAdherenceScore, averageCaloriesConsumed: $averageCaloriesConsumed, averageWaterIntakeMl: $averageWaterIntakeMl, totalLoggedDays: $totalLoggedDays, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DietHistoryStateCopyWith<$Res>  {
  factory $DietHistoryStateCopyWith(DietHistoryState value, $Res Function(DietHistoryState) _then) = _$DietHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<DietLog> logs, DietDateRange selectedRange, num? averageAdherenceScore, num? averageCaloriesConsumed, int? averageWaterIntakeMl, int totalLoggedDays, Failure? failure
});




}
/// @nodoc
class _$DietHistoryStateCopyWithImpl<$Res>
    implements $DietHistoryStateCopyWith<$Res> {
  _$DietHistoryStateCopyWithImpl(this._self, this._then);

  final DietHistoryState _self;
  final $Res Function(DietHistoryState) _then;

/// Create a copy of DietHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? logs = null,Object? selectedRange = null,Object? averageAdherenceScore = freezed,Object? averageCaloriesConsumed = freezed,Object? averageWaterIntakeMl = freezed,Object? totalLoggedDays = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<DietLog>,selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as DietDateRange,averageAdherenceScore: freezed == averageAdherenceScore ? _self.averageAdherenceScore : averageAdherenceScore // ignore: cast_nullable_to_non_nullable
as num?,averageCaloriesConsumed: freezed == averageCaloriesConsumed ? _self.averageCaloriesConsumed : averageCaloriesConsumed // ignore: cast_nullable_to_non_nullable
as num?,averageWaterIntakeMl: freezed == averageWaterIntakeMl ? _self.averageWaterIntakeMl : averageWaterIntakeMl // ignore: cast_nullable_to_non_nullable
as int?,totalLoggedDays: null == totalLoggedDays ? _self.totalLoggedDays : totalLoggedDays // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DietHistoryState].
extension DietHistoryStatePatterns on DietHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _DietHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _DietHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<DietLog> logs,  DietDateRange selectedRange,  num? averageAdherenceScore,  num? averageCaloriesConsumed,  int? averageWaterIntakeMl,  int totalLoggedDays,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietHistoryState() when $default != null:
return $default(_that.status,_that.logs,_that.selectedRange,_that.averageAdherenceScore,_that.averageCaloriesConsumed,_that.averageWaterIntakeMl,_that.totalLoggedDays,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<DietLog> logs,  DietDateRange selectedRange,  num? averageAdherenceScore,  num? averageCaloriesConsumed,  int? averageWaterIntakeMl,  int totalLoggedDays,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DietHistoryState():
return $default(_that.status,_that.logs,_that.selectedRange,_that.averageAdherenceScore,_that.averageCaloriesConsumed,_that.averageWaterIntakeMl,_that.totalLoggedDays,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<DietLog> logs,  DietDateRange selectedRange,  num? averageAdherenceScore,  num? averageCaloriesConsumed,  int? averageWaterIntakeMl,  int totalLoggedDays,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DietHistoryState() when $default != null:
return $default(_that.status,_that.logs,_that.selectedRange,_that.averageAdherenceScore,_that.averageCaloriesConsumed,_that.averageWaterIntakeMl,_that.totalLoggedDays,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DietHistoryState implements DietHistoryState {
  const _DietHistoryState({this.status = LoadStatus.initial, final  List<DietLog> logs = const <DietLog>[], this.selectedRange = DietDateRange.all, this.averageAdherenceScore, this.averageCaloriesConsumed, this.averageWaterIntakeMl, this.totalLoggedDays = 0, this.failure}): _logs = logs;
  

@override@JsonKey() final  LoadStatus status;
 final  List<DietLog> _logs;
@override@JsonKey() List<DietLog> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override@JsonKey() final  DietDateRange selectedRange;
@override final  num? averageAdherenceScore;
@override final  num? averageCaloriesConsumed;
@override final  int? averageWaterIntakeMl;
@override@JsonKey() final  int totalLoggedDays;
@override final  Failure? failure;

/// Create a copy of DietHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietHistoryStateCopyWith<_DietHistoryState> get copyWith => __$DietHistoryStateCopyWithImpl<_DietHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._logs, _logs)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange)&&(identical(other.averageAdherenceScore, averageAdherenceScore) || other.averageAdherenceScore == averageAdherenceScore)&&(identical(other.averageCaloriesConsumed, averageCaloriesConsumed) || other.averageCaloriesConsumed == averageCaloriesConsumed)&&(identical(other.averageWaterIntakeMl, averageWaterIntakeMl) || other.averageWaterIntakeMl == averageWaterIntakeMl)&&(identical(other.totalLoggedDays, totalLoggedDays) || other.totalLoggedDays == totalLoggedDays)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_logs),selectedRange,averageAdherenceScore,averageCaloriesConsumed,averageWaterIntakeMl,totalLoggedDays,failure);

@override
String toString() {
  return 'DietHistoryState(status: $status, logs: $logs, selectedRange: $selectedRange, averageAdherenceScore: $averageAdherenceScore, averageCaloriesConsumed: $averageCaloriesConsumed, averageWaterIntakeMl: $averageWaterIntakeMl, totalLoggedDays: $totalLoggedDays, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DietHistoryStateCopyWith<$Res> implements $DietHistoryStateCopyWith<$Res> {
  factory _$DietHistoryStateCopyWith(_DietHistoryState value, $Res Function(_DietHistoryState) _then) = __$DietHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<DietLog> logs, DietDateRange selectedRange, num? averageAdherenceScore, num? averageCaloriesConsumed, int? averageWaterIntakeMl, int totalLoggedDays, Failure? failure
});




}
/// @nodoc
class __$DietHistoryStateCopyWithImpl<$Res>
    implements _$DietHistoryStateCopyWith<$Res> {
  __$DietHistoryStateCopyWithImpl(this._self, this._then);

  final _DietHistoryState _self;
  final $Res Function(_DietHistoryState) _then;

/// Create a copy of DietHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? logs = null,Object? selectedRange = null,Object? averageAdherenceScore = freezed,Object? averageCaloriesConsumed = freezed,Object? averageWaterIntakeMl = freezed,Object? totalLoggedDays = null,Object? failure = freezed,}) {
  return _then(_DietHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<DietLog>,selectedRange: null == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as DietDateRange,averageAdherenceScore: freezed == averageAdherenceScore ? _self.averageAdherenceScore : averageAdherenceScore // ignore: cast_nullable_to_non_nullable
as num?,averageCaloriesConsumed: freezed == averageCaloriesConsumed ? _self.averageCaloriesConsumed : averageCaloriesConsumed // ignore: cast_nullable_to_non_nullable
as num?,averageWaterIntakeMl: freezed == averageWaterIntakeMl ? _self.averageWaterIntakeMl : averageWaterIntakeMl // ignore: cast_nullable_to_non_nullable
as int?,totalLoggedDays: null == totalLoggedDays ? _self.totalLoggedDays : totalLoggedDays // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
