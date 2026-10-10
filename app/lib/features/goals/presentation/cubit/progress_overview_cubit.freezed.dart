// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_overview_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressOverviewState {

 LoadStatus get status; MetricChartData? get weightData; List<MetricChartData> get bodyCompositionData; List<MetricChartData> get circumferenceData; List<AppChartPoint> get weeklyAttendance; double? get bmi; bool get heightMissing; Failure? get failure;
/// Create a copy of ProgressOverviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressOverviewStateCopyWith<ProgressOverviewState> get copyWith => _$ProgressOverviewStateCopyWithImpl<ProgressOverviewState>(this as ProgressOverviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressOverviewState&&(identical(other.status, status) || other.status == status)&&(identical(other.weightData, weightData) || other.weightData == weightData)&&const DeepCollectionEquality().equals(other.bodyCompositionData, bodyCompositionData)&&const DeepCollectionEquality().equals(other.circumferenceData, circumferenceData)&&const DeepCollectionEquality().equals(other.weeklyAttendance, weeklyAttendance)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.heightMissing, heightMissing) || other.heightMissing == heightMissing)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,weightData,const DeepCollectionEquality().hash(bodyCompositionData),const DeepCollectionEquality().hash(circumferenceData),const DeepCollectionEquality().hash(weeklyAttendance),bmi,heightMissing,failure);

@override
String toString() {
  return 'ProgressOverviewState(status: $status, weightData: $weightData, bodyCompositionData: $bodyCompositionData, circumferenceData: $circumferenceData, weeklyAttendance: $weeklyAttendance, bmi: $bmi, heightMissing: $heightMissing, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ProgressOverviewStateCopyWith<$Res>  {
  factory $ProgressOverviewStateCopyWith(ProgressOverviewState value, $Res Function(ProgressOverviewState) _then) = _$ProgressOverviewStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, MetricChartData? weightData, List<MetricChartData> bodyCompositionData, List<MetricChartData> circumferenceData, List<AppChartPoint> weeklyAttendance, double? bmi, bool heightMissing, Failure? failure
});




}
/// @nodoc
class _$ProgressOverviewStateCopyWithImpl<$Res>
    implements $ProgressOverviewStateCopyWith<$Res> {
  _$ProgressOverviewStateCopyWithImpl(this._self, this._then);

  final ProgressOverviewState _self;
  final $Res Function(ProgressOverviewState) _then;

/// Create a copy of ProgressOverviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? weightData = freezed,Object? bodyCompositionData = null,Object? circumferenceData = null,Object? weeklyAttendance = null,Object? bmi = freezed,Object? heightMissing = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,weightData: freezed == weightData ? _self.weightData : weightData // ignore: cast_nullable_to_non_nullable
as MetricChartData?,bodyCompositionData: null == bodyCompositionData ? _self.bodyCompositionData : bodyCompositionData // ignore: cast_nullable_to_non_nullable
as List<MetricChartData>,circumferenceData: null == circumferenceData ? _self.circumferenceData : circumferenceData // ignore: cast_nullable_to_non_nullable
as List<MetricChartData>,weeklyAttendance: null == weeklyAttendance ? _self.weeklyAttendance : weeklyAttendance // ignore: cast_nullable_to_non_nullable
as List<AppChartPoint>,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,heightMissing: null == heightMissing ? _self.heightMissing : heightMissing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressOverviewState].
extension ProgressOverviewStatePatterns on ProgressOverviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressOverviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressOverviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressOverviewState value)  $default,){
final _that = this;
switch (_that) {
case _ProgressOverviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressOverviewState value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressOverviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  MetricChartData? weightData,  List<MetricChartData> bodyCompositionData,  List<MetricChartData> circumferenceData,  List<AppChartPoint> weeklyAttendance,  double? bmi,  bool heightMissing,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressOverviewState() when $default != null:
return $default(_that.status,_that.weightData,_that.bodyCompositionData,_that.circumferenceData,_that.weeklyAttendance,_that.bmi,_that.heightMissing,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  MetricChartData? weightData,  List<MetricChartData> bodyCompositionData,  List<MetricChartData> circumferenceData,  List<AppChartPoint> weeklyAttendance,  double? bmi,  bool heightMissing,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ProgressOverviewState():
return $default(_that.status,_that.weightData,_that.bodyCompositionData,_that.circumferenceData,_that.weeklyAttendance,_that.bmi,_that.heightMissing,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  MetricChartData? weightData,  List<MetricChartData> bodyCompositionData,  List<MetricChartData> circumferenceData,  List<AppChartPoint> weeklyAttendance,  double? bmi,  bool heightMissing,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ProgressOverviewState() when $default != null:
return $default(_that.status,_that.weightData,_that.bodyCompositionData,_that.circumferenceData,_that.weeklyAttendance,_that.bmi,_that.heightMissing,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressOverviewState implements ProgressOverviewState {
  const _ProgressOverviewState({this.status = LoadStatus.initial, this.weightData, final  List<MetricChartData> bodyCompositionData = const <MetricChartData>[], final  List<MetricChartData> circumferenceData = const <MetricChartData>[], final  List<AppChartPoint> weeklyAttendance = const <AppChartPoint>[], this.bmi, this.heightMissing = false, this.failure}): _bodyCompositionData = bodyCompositionData,_circumferenceData = circumferenceData,_weeklyAttendance = weeklyAttendance;
  

@override@JsonKey() final  LoadStatus status;
@override final  MetricChartData? weightData;
 final  List<MetricChartData> _bodyCompositionData;
@override@JsonKey() List<MetricChartData> get bodyCompositionData {
  if (_bodyCompositionData is EqualUnmodifiableListView) return _bodyCompositionData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bodyCompositionData);
}

 final  List<MetricChartData> _circumferenceData;
@override@JsonKey() List<MetricChartData> get circumferenceData {
  if (_circumferenceData is EqualUnmodifiableListView) return _circumferenceData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_circumferenceData);
}

 final  List<AppChartPoint> _weeklyAttendance;
@override@JsonKey() List<AppChartPoint> get weeklyAttendance {
  if (_weeklyAttendance is EqualUnmodifiableListView) return _weeklyAttendance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyAttendance);
}

@override final  double? bmi;
@override@JsonKey() final  bool heightMissing;
@override final  Failure? failure;

/// Create a copy of ProgressOverviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressOverviewStateCopyWith<_ProgressOverviewState> get copyWith => __$ProgressOverviewStateCopyWithImpl<_ProgressOverviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressOverviewState&&(identical(other.status, status) || other.status == status)&&(identical(other.weightData, weightData) || other.weightData == weightData)&&const DeepCollectionEquality().equals(other._bodyCompositionData, _bodyCompositionData)&&const DeepCollectionEquality().equals(other._circumferenceData, _circumferenceData)&&const DeepCollectionEquality().equals(other._weeklyAttendance, _weeklyAttendance)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.heightMissing, heightMissing) || other.heightMissing == heightMissing)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,weightData,const DeepCollectionEquality().hash(_bodyCompositionData),const DeepCollectionEquality().hash(_circumferenceData),const DeepCollectionEquality().hash(_weeklyAttendance),bmi,heightMissing,failure);

@override
String toString() {
  return 'ProgressOverviewState(status: $status, weightData: $weightData, bodyCompositionData: $bodyCompositionData, circumferenceData: $circumferenceData, weeklyAttendance: $weeklyAttendance, bmi: $bmi, heightMissing: $heightMissing, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ProgressOverviewStateCopyWith<$Res> implements $ProgressOverviewStateCopyWith<$Res> {
  factory _$ProgressOverviewStateCopyWith(_ProgressOverviewState value, $Res Function(_ProgressOverviewState) _then) = __$ProgressOverviewStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, MetricChartData? weightData, List<MetricChartData> bodyCompositionData, List<MetricChartData> circumferenceData, List<AppChartPoint> weeklyAttendance, double? bmi, bool heightMissing, Failure? failure
});




}
/// @nodoc
class __$ProgressOverviewStateCopyWithImpl<$Res>
    implements _$ProgressOverviewStateCopyWith<$Res> {
  __$ProgressOverviewStateCopyWithImpl(this._self, this._then);

  final _ProgressOverviewState _self;
  final $Res Function(_ProgressOverviewState) _then;

/// Create a copy of ProgressOverviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? weightData = freezed,Object? bodyCompositionData = null,Object? circumferenceData = null,Object? weeklyAttendance = null,Object? bmi = freezed,Object? heightMissing = null,Object? failure = freezed,}) {
  return _then(_ProgressOverviewState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,weightData: freezed == weightData ? _self.weightData : weightData // ignore: cast_nullable_to_non_nullable
as MetricChartData?,bodyCompositionData: null == bodyCompositionData ? _self._bodyCompositionData : bodyCompositionData // ignore: cast_nullable_to_non_nullable
as List<MetricChartData>,circumferenceData: null == circumferenceData ? _self._circumferenceData : circumferenceData // ignore: cast_nullable_to_non_nullable
as List<MetricChartData>,weeklyAttendance: null == weeklyAttendance ? _self._weeklyAttendance : weeklyAttendance // ignore: cast_nullable_to_non_nullable
as List<AppChartPoint>,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,heightMissing: null == heightMissing ? _self.heightMissing : heightMissing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
