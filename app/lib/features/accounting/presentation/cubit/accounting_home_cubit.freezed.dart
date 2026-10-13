// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounting_home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountingHomeState {

 LoadStatus get status; OpenItemsReport? get openAr; OpenItemsReport? get openAp; List<Account> get bankAndCashAccounts; AccountingPeriod? get currentPeriod; Failure? get failure;
/// Create a copy of AccountingHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountingHomeStateCopyWith<AccountingHomeState> get copyWith => _$AccountingHomeStateCopyWithImpl<AccountingHomeState>(this as AccountingHomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountingHomeState&&(identical(other.status, status) || other.status == status)&&(identical(other.openAr, openAr) || other.openAr == openAr)&&(identical(other.openAp, openAp) || other.openAp == openAp)&&const DeepCollectionEquality().equals(other.bankAndCashAccounts, bankAndCashAccounts)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,openAr,openAp,const DeepCollectionEquality().hash(bankAndCashAccounts),currentPeriod,failure);

@override
String toString() {
  return 'AccountingHomeState(status: $status, openAr: $openAr, openAp: $openAp, bankAndCashAccounts: $bankAndCashAccounts, currentPeriod: $currentPeriod, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AccountingHomeStateCopyWith<$Res>  {
  factory $AccountingHomeStateCopyWith(AccountingHomeState value, $Res Function(AccountingHomeState) _then) = _$AccountingHomeStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, OpenItemsReport? openAr, OpenItemsReport? openAp, List<Account> bankAndCashAccounts, AccountingPeriod? currentPeriod, Failure? failure
});




}
/// @nodoc
class _$AccountingHomeStateCopyWithImpl<$Res>
    implements $AccountingHomeStateCopyWith<$Res> {
  _$AccountingHomeStateCopyWithImpl(this._self, this._then);

  final AccountingHomeState _self;
  final $Res Function(AccountingHomeState) _then;

/// Create a copy of AccountingHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? openAr = freezed,Object? openAp = freezed,Object? bankAndCashAccounts = null,Object? currentPeriod = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,openAr: freezed == openAr ? _self.openAr : openAr // ignore: cast_nullable_to_non_nullable
as OpenItemsReport?,openAp: freezed == openAp ? _self.openAp : openAp // ignore: cast_nullable_to_non_nullable
as OpenItemsReport?,bankAndCashAccounts: null == bankAndCashAccounts ? _self.bankAndCashAccounts : bankAndCashAccounts // ignore: cast_nullable_to_non_nullable
as List<Account>,currentPeriod: freezed == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as AccountingPeriod?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountingHomeState].
extension AccountingHomeStatePatterns on AccountingHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountingHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountingHomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountingHomeState value)  $default,){
final _that = this;
switch (_that) {
case _AccountingHomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountingHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountingHomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  OpenItemsReport? openAr,  OpenItemsReport? openAp,  List<Account> bankAndCashAccounts,  AccountingPeriod? currentPeriod,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountingHomeState() when $default != null:
return $default(_that.status,_that.openAr,_that.openAp,_that.bankAndCashAccounts,_that.currentPeriod,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  OpenItemsReport? openAr,  OpenItemsReport? openAp,  List<Account> bankAndCashAccounts,  AccountingPeriod? currentPeriod,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AccountingHomeState():
return $default(_that.status,_that.openAr,_that.openAp,_that.bankAndCashAccounts,_that.currentPeriod,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  OpenItemsReport? openAr,  OpenItemsReport? openAp,  List<Account> bankAndCashAccounts,  AccountingPeriod? currentPeriod,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AccountingHomeState() when $default != null:
return $default(_that.status,_that.openAr,_that.openAp,_that.bankAndCashAccounts,_that.currentPeriod,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AccountingHomeState implements AccountingHomeState {
  const _AccountingHomeState({this.status = LoadStatus.initial, this.openAr, this.openAp, final  List<Account> bankAndCashAccounts = const <Account>[], this.currentPeriod, this.failure}): _bankAndCashAccounts = bankAndCashAccounts;
  

@override@JsonKey() final  LoadStatus status;
@override final  OpenItemsReport? openAr;
@override final  OpenItemsReport? openAp;
 final  List<Account> _bankAndCashAccounts;
@override@JsonKey() List<Account> get bankAndCashAccounts {
  if (_bankAndCashAccounts is EqualUnmodifiableListView) return _bankAndCashAccounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bankAndCashAccounts);
}

@override final  AccountingPeriod? currentPeriod;
@override final  Failure? failure;

/// Create a copy of AccountingHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountingHomeStateCopyWith<_AccountingHomeState> get copyWith => __$AccountingHomeStateCopyWithImpl<_AccountingHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountingHomeState&&(identical(other.status, status) || other.status == status)&&(identical(other.openAr, openAr) || other.openAr == openAr)&&(identical(other.openAp, openAp) || other.openAp == openAp)&&const DeepCollectionEquality().equals(other._bankAndCashAccounts, _bankAndCashAccounts)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,openAr,openAp,const DeepCollectionEquality().hash(_bankAndCashAccounts),currentPeriod,failure);

@override
String toString() {
  return 'AccountingHomeState(status: $status, openAr: $openAr, openAp: $openAp, bankAndCashAccounts: $bankAndCashAccounts, currentPeriod: $currentPeriod, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AccountingHomeStateCopyWith<$Res> implements $AccountingHomeStateCopyWith<$Res> {
  factory _$AccountingHomeStateCopyWith(_AccountingHomeState value, $Res Function(_AccountingHomeState) _then) = __$AccountingHomeStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, OpenItemsReport? openAr, OpenItemsReport? openAp, List<Account> bankAndCashAccounts, AccountingPeriod? currentPeriod, Failure? failure
});




}
/// @nodoc
class __$AccountingHomeStateCopyWithImpl<$Res>
    implements _$AccountingHomeStateCopyWith<$Res> {
  __$AccountingHomeStateCopyWithImpl(this._self, this._then);

  final _AccountingHomeState _self;
  final $Res Function(_AccountingHomeState) _then;

/// Create a copy of AccountingHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? openAr = freezed,Object? openAp = freezed,Object? bankAndCashAccounts = null,Object? currentPeriod = freezed,Object? failure = freezed,}) {
  return _then(_AccountingHomeState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,openAr: freezed == openAr ? _self.openAr : openAr // ignore: cast_nullable_to_non_nullable
as OpenItemsReport?,openAp: freezed == openAp ? _self.openAp : openAp // ignore: cast_nullable_to_non_nullable
as OpenItemsReport?,bankAndCashAccounts: null == bankAndCashAccounts ? _self._bankAndCashAccounts : bankAndCashAccounts // ignore: cast_nullable_to_non_nullable
as List<Account>,currentPeriod: freezed == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as AccountingPeriod?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
