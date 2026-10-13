// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_periods_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingPeriodsState {

 LoadStatus get status; List<FiscalYear> get fiscalYears; List<AccountingPeriod> get periods; String? get selectedFiscalYearId; bool get isActionInProgress; Failure? get failure;
/// Create a copy of AccountingPeriodsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingPeriodsStateCopyWith<AccountingPeriodsState> get copyWith => _$AccountingPeriodsStateCopyWithImpl<AccountingPeriodsState>(this as AccountingPeriodsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingPeriodsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.fiscalYears, fiscalYears)&&const DeepCollectionEquality().equals(other.periods, periods)&&(identical(other.selectedFiscalYearId, selectedFiscalYearId) || other.selectedFiscalYearId == selectedFiscalYearId)&&(identical(other.isActionInProgress, isActionInProgress) || other.isActionInProgress == isActionInProgress)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(fiscalYears),const DeepCollectionEquality().hash(periods),selectedFiscalYearId,isActionInProgress,failure);

@override
String toString() {
  return 'AccountingPeriodsState(status: $status, fiscalYears: $fiscalYears, periods: $periods, selectedFiscalYearId: $selectedFiscalYearId, isActionInProgress: $isActionInProgress, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AccountingPeriodsStateCopyWith<$Res>  {
  factory $AccountingPeriodsStateCopyWith(AccountingPeriodsState value, $Res Function(AccountingPeriodsState) _then) = _$AccountingPeriodsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<FiscalYear> fiscalYears, List<AccountingPeriod> periods, String? selectedFiscalYearId, bool isActionInProgress, Failure? failure
});




}
/// @nodoc
class _$AccountingPeriodsStateCopyWithImpl<$Res>
    implements $AccountingPeriodsStateCopyWith<$Res> {
  _$AccountingPeriodsStateCopyWithImpl(this._self, this._then);

  final AccountingPeriodsState _self;
  final $Res Function(AccountingPeriodsState) _then;

/// Create a copy of AccountingPeriodsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? fiscalYears = null,Object? periods = null,Object? selectedFiscalYearId = freezed,Object? isActionInProgress = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,fiscalYears: null == fiscalYears ? _self.fiscalYears : fiscalYears // ignore: cast_nullable_to_non_nullable
as List<FiscalYear>,periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as List<AccountingPeriod>,selectedFiscalYearId: freezed == selectedFiscalYearId ? _self.selectedFiscalYearId : selectedFiscalYearId // ignore: cast_nullable_to_non_nullable
as String?,isActionInProgress: null == isActionInProgress ? _self.isActionInProgress : isActionInProgress // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingPeriodsState].
extension AccountingPeriodsStatePatterns on AccountingPeriodsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingPeriodsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingPeriodsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingPeriodsState value)  $default,){
final _that = this;
switch (_that) {
case _AccountingPeriodsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingPeriodsState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingPeriodsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<FiscalYear> fiscalYears,  List<AccountingPeriod> periods,  String? selectedFiscalYearId,  bool isActionInProgress,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingPeriodsState() when $default != null:
return $default(_that.status,_that.fiscalYears,_that.periods,_that.selectedFiscalYearId,_that.isActionInProgress,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<FiscalYear> fiscalYears,  List<AccountingPeriod> periods,  String? selectedFiscalYearId,  bool isActionInProgress,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AccountingPeriodsState():
return $default(_that.status,_that.fiscalYears,_that.periods,_that.selectedFiscalYearId,_that.isActionInProgress,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<FiscalYear> fiscalYears,  List<AccountingPeriod> periods,  String? selectedFiscalYearId,  bool isActionInProgress,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AccountingPeriodsState() when $default != null:
return $default(_that.status,_that.fiscalYears,_that.periods,_that.selectedFiscalYearId,_that.isActionInProgress,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingPeriodsState implements AccountingPeriodsState {
  const _AccountingPeriodsState({this.status = LoadStatus.initial, final  List<FiscalYear> fiscalYears = const <FiscalYear>[], final  List<AccountingPeriod> periods = const <AccountingPeriod>[], this.selectedFiscalYearId, this.isActionInProgress = false, this.failure}): _fiscalYears = fiscalYears,_periods = periods;
  

@override@JsonKey() final  LoadStatus status;
 final  List<FiscalYear> _fiscalYears;
@override@JsonKey() List<FiscalYear> get fiscalYears {
  if (_fiscalYears is EqualUnmodifiableListView) return _fiscalYears;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fiscalYears);
}

 final  List<AccountingPeriod> _periods;
@override@JsonKey() List<AccountingPeriod> get periods {
  if (_periods is EqualUnmodifiableListView) return _periods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_periods);
}

@override final  String? selectedFiscalYearId;
@override@JsonKey() final  bool isActionInProgress;
@override final  Failure? failure;

/// Create a copy of AccountingPeriodsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingPeriodsStateCopyWith<_AccountingPeriodsState> get copyWith => __$AccountingPeriodsStateCopyWithImpl<_AccountingPeriodsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingPeriodsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._fiscalYears, _fiscalYears)&&const DeepCollectionEquality().equals(other._periods, _periods)&&(identical(other.selectedFiscalYearId, selectedFiscalYearId) || other.selectedFiscalYearId == selectedFiscalYearId)&&(identical(other.isActionInProgress, isActionInProgress) || other.isActionInProgress == isActionInProgress)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_fiscalYears),const DeepCollectionEquality().hash(_periods),selectedFiscalYearId,isActionInProgress,failure);

@override
String toString() {
  return 'AccountingPeriodsState(status: $status, fiscalYears: $fiscalYears, periods: $periods, selectedFiscalYearId: $selectedFiscalYearId, isActionInProgress: $isActionInProgress, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AccountingPeriodsStateCopyWith<$Res> implements $AccountingPeriodsStateCopyWith<$Res> {
  factory _$AccountingPeriodsStateCopyWith(_AccountingPeriodsState value, $Res Function(_AccountingPeriodsState) _then) = __$AccountingPeriodsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<FiscalYear> fiscalYears, List<AccountingPeriod> periods, String? selectedFiscalYearId, bool isActionInProgress, Failure? failure
});




}
/// @nodoc
class __$AccountingPeriodsStateCopyWithImpl<$Res>
    implements _$AccountingPeriodsStateCopyWith<$Res> {
  __$AccountingPeriodsStateCopyWithImpl(this._self, this._then);

  final _AccountingPeriodsState _self;
  final $Res Function(_AccountingPeriodsState) _then;

/// Create a copy of AccountingPeriodsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? fiscalYears = null,Object? periods = null,Object? selectedFiscalYearId = freezed,Object? isActionInProgress = null,Object? failure = freezed,}) {
  return _then(_AccountingPeriodsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,fiscalYears: null == fiscalYears ? _self._fiscalYears : fiscalYears // ignore: cast_nullable_to_non_nullable
as List<FiscalYear>,periods: null == periods ? _self._periods : periods // ignore: cast_nullable_to_non_nullable
as List<AccountingPeriod>,selectedFiscalYearId: freezed == selectedFiscalYearId ? _self.selectedFiscalYearId : selectedFiscalYearId // ignore: cast_nullable_to_non_nullable
as String?,isActionInProgress: null == isActionInProgress ? _self.isActionInProgress : isActionInProgress // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
