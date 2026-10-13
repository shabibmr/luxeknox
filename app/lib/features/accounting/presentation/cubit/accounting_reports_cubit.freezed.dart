// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_reports_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingReportsState {

 LoadStatus get status; AccountingReportType get selectedReportType; DateTime? get fromDate; DateTime? get toDate; TrialBalanceReport? get trialBalance; ProfitAndLossReport? get profitAndLoss; BalanceSheetReport? get balanceSheet; DayBookReport? get dayBook; GstSummaryReport? get gstSummary; Failure? get failure;
/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingReportsStateCopyWith<AccountingReportsState> get copyWith => _$AccountingReportsStateCopyWithImpl<AccountingReportsState>(this as AccountingReportsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingReportsState&&(identical(other.status, status) || other.status == status)&&(identical(other.selectedReportType, selectedReportType) || other.selectedReportType == selectedReportType)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.trialBalance, trialBalance) || other.trialBalance == trialBalance)&&(identical(other.profitAndLoss, profitAndLoss) || other.profitAndLoss == profitAndLoss)&&(identical(other.balanceSheet, balanceSheet) || other.balanceSheet == balanceSheet)&&(identical(other.dayBook, dayBook) || other.dayBook == dayBook)&&(identical(other.gstSummary, gstSummary) || other.gstSummary == gstSummary)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,selectedReportType,fromDate,toDate,trialBalance,profitAndLoss,balanceSheet,dayBook,gstSummary,failure);

@override
String toString() {
  return 'AccountingReportsState(status: $status, selectedReportType: $selectedReportType, fromDate: $fromDate, toDate: $toDate, trialBalance: $trialBalance, profitAndLoss: $profitAndLoss, balanceSheet: $balanceSheet, dayBook: $dayBook, gstSummary: $gstSummary, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AccountingReportsStateCopyWith<$Res>  {
  factory $AccountingReportsStateCopyWith(AccountingReportsState value, $Res Function(AccountingReportsState) _then) = _$AccountingReportsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, AccountingReportType selectedReportType, DateTime? fromDate, DateTime? toDate, TrialBalanceReport? trialBalance, ProfitAndLossReport? profitAndLoss, BalanceSheetReport? balanceSheet, DayBookReport? dayBook, GstSummaryReport? gstSummary, Failure? failure
});




}
/// @nodoc
class _$AccountingReportsStateCopyWithImpl<$Res>
    implements $AccountingReportsStateCopyWith<$Res> {
  _$AccountingReportsStateCopyWithImpl(this._self, this._then);

  final AccountingReportsState _self;
  final $Res Function(AccountingReportsState) _then;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? selectedReportType = null,Object? fromDate = freezed,Object? toDate = freezed,Object? trialBalance = freezed,Object? profitAndLoss = freezed,Object? balanceSheet = freezed,Object? dayBook = freezed,Object? gstSummary = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,selectedReportType: null == selectedReportType ? _self.selectedReportType : selectedReportType // ignore: cast_nullable_to_non_nullable
as AccountingReportType,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,trialBalance: freezed == trialBalance ? _self.trialBalance : trialBalance // ignore: cast_nullable_to_non_nullable
as TrialBalanceReport?,profitAndLoss: freezed == profitAndLoss ? _self.profitAndLoss : profitAndLoss // ignore: cast_nullable_to_non_nullable
as ProfitAndLossReport?,balanceSheet: freezed == balanceSheet ? _self.balanceSheet : balanceSheet // ignore: cast_nullable_to_non_nullable
as BalanceSheetReport?,dayBook: freezed == dayBook ? _self.dayBook : dayBook // ignore: cast_nullable_to_non_nullable
as DayBookReport?,gstSummary: freezed == gstSummary ? _self.gstSummary : gstSummary // ignore: cast_nullable_to_non_nullable
as GstSummaryReport?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingReportsState].
extension AccountingReportsStatePatterns on AccountingReportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingReportsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingReportsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingReportsState value)  $default,){
final _that = this;
switch (_that) {
case _AccountingReportsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingReportsState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingReportsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  AccountingReportType selectedReportType,  DateTime? fromDate,  DateTime? toDate,  TrialBalanceReport? trialBalance,  ProfitAndLossReport? profitAndLoss,  BalanceSheetReport? balanceSheet,  DayBookReport? dayBook,  GstSummaryReport? gstSummary,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingReportsState() when $default != null:
return $default(_that.status,_that.selectedReportType,_that.fromDate,_that.toDate,_that.trialBalance,_that.profitAndLoss,_that.balanceSheet,_that.dayBook,_that.gstSummary,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  AccountingReportType selectedReportType,  DateTime? fromDate,  DateTime? toDate,  TrialBalanceReport? trialBalance,  ProfitAndLossReport? profitAndLoss,  BalanceSheetReport? balanceSheet,  DayBookReport? dayBook,  GstSummaryReport? gstSummary,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AccountingReportsState():
return $default(_that.status,_that.selectedReportType,_that.fromDate,_that.toDate,_that.trialBalance,_that.profitAndLoss,_that.balanceSheet,_that.dayBook,_that.gstSummary,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  AccountingReportType selectedReportType,  DateTime? fromDate,  DateTime? toDate,  TrialBalanceReport? trialBalance,  ProfitAndLossReport? profitAndLoss,  BalanceSheetReport? balanceSheet,  DayBookReport? dayBook,  GstSummaryReport? gstSummary,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AccountingReportsState() when $default != null:
return $default(_that.status,_that.selectedReportType,_that.fromDate,_that.toDate,_that.trialBalance,_that.profitAndLoss,_that.balanceSheet,_that.dayBook,_that.gstSummary,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingReportsState implements AccountingReportsState {
  const _AccountingReportsState({this.status = LoadStatus.initial, this.selectedReportType = AccountingReportType.trialBalance, this.fromDate, this.toDate, this.trialBalance, this.profitAndLoss, this.balanceSheet, this.dayBook, this.gstSummary, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override@JsonKey() final  AccountingReportType selectedReportType;
@override final  DateTime? fromDate;
@override final  DateTime? toDate;
@override final  TrialBalanceReport? trialBalance;
@override final  ProfitAndLossReport? profitAndLoss;
@override final  BalanceSheetReport? balanceSheet;
@override final  DayBookReport? dayBook;
@override final  GstSummaryReport? gstSummary;
@override final  Failure? failure;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingReportsStateCopyWith<_AccountingReportsState> get copyWith => __$AccountingReportsStateCopyWithImpl<_AccountingReportsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingReportsState&&(identical(other.status, status) || other.status == status)&&(identical(other.selectedReportType, selectedReportType) || other.selectedReportType == selectedReportType)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.trialBalance, trialBalance) || other.trialBalance == trialBalance)&&(identical(other.profitAndLoss, profitAndLoss) || other.profitAndLoss == profitAndLoss)&&(identical(other.balanceSheet, balanceSheet) || other.balanceSheet == balanceSheet)&&(identical(other.dayBook, dayBook) || other.dayBook == dayBook)&&(identical(other.gstSummary, gstSummary) || other.gstSummary == gstSummary)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,selectedReportType,fromDate,toDate,trialBalance,profitAndLoss,balanceSheet,dayBook,gstSummary,failure);

@override
String toString() {
  return 'AccountingReportsState(status: $status, selectedReportType: $selectedReportType, fromDate: $fromDate, toDate: $toDate, trialBalance: $trialBalance, profitAndLoss: $profitAndLoss, balanceSheet: $balanceSheet, dayBook: $dayBook, gstSummary: $gstSummary, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AccountingReportsStateCopyWith<$Res> implements $AccountingReportsStateCopyWith<$Res> {
  factory _$AccountingReportsStateCopyWith(_AccountingReportsState value, $Res Function(_AccountingReportsState) _then) = __$AccountingReportsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, AccountingReportType selectedReportType, DateTime? fromDate, DateTime? toDate, TrialBalanceReport? trialBalance, ProfitAndLossReport? profitAndLoss, BalanceSheetReport? balanceSheet, DayBookReport? dayBook, GstSummaryReport? gstSummary, Failure? failure
});




}
/// @nodoc
class __$AccountingReportsStateCopyWithImpl<$Res>
    implements _$AccountingReportsStateCopyWith<$Res> {
  __$AccountingReportsStateCopyWithImpl(this._self, this._then);

  final _AccountingReportsState _self;
  final $Res Function(_AccountingReportsState) _then;

/// Create a copy of AccountingReportsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? selectedReportType = null,Object? fromDate = freezed,Object? toDate = freezed,Object? trialBalance = freezed,Object? profitAndLoss = freezed,Object? balanceSheet = freezed,Object? dayBook = freezed,Object? gstSummary = freezed,Object? failure = freezed,}) {
  return _then(_AccountingReportsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,selectedReportType: null == selectedReportType ? _self.selectedReportType : selectedReportType // ignore: cast_nullable_to_non_nullable
as AccountingReportType,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,trialBalance: freezed == trialBalance ? _self.trialBalance : trialBalance // ignore: cast_nullable_to_non_nullable
as TrialBalanceReport?,profitAndLoss: freezed == profitAndLoss ? _self.profitAndLoss : profitAndLoss // ignore: cast_nullable_to_non_nullable
as ProfitAndLossReport?,balanceSheet: freezed == balanceSheet ? _self.balanceSheet : balanceSheet // ignore: cast_nullable_to_non_nullable
as BalanceSheetReport?,dayBook: freezed == dayBook ? _self.dayBook : dayBook // ignore: cast_nullable_to_non_nullable
as DayBookReport?,gstSummary: freezed == gstSummary ? _self.gstSummary : gstSummary // ignore: cast_nullable_to_non_nullable
as GstSummaryReport?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
