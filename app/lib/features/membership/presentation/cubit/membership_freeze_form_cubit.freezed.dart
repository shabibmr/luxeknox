// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_freeze_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipFreezeFormState {

 LoadStatus get status; Membership? get membership; DateTime? get startDate; DateTime? get endDate; String get reason; Failure? get failure; bool get isSubmitting; bool get success; String? get validationError;
/// Create a copy of MembershipFreezeFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipFreezeFormStateCopyWith<MembershipFreezeFormState> get copyWith => _$MembershipFreezeFormStateCopyWithImpl<MembershipFreezeFormState>(this as MembershipFreezeFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipFreezeFormState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.success, success) || other.success == success)&&(identical(other.validationError, validationError) || other.validationError == validationError));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,startDate,endDate,reason,failure,isSubmitting,success,validationError);

@override
String toString() {
  return 'MembershipFreezeFormState(status: $status, membership: $membership, startDate: $startDate, endDate: $endDate, reason: $reason, failure: $failure, isSubmitting: $isSubmitting, success: $success, validationError: $validationError)';
}


}

/// @nodoc
abstract mixin class $MembershipFreezeFormStateCopyWith<$Res>  {
  factory $MembershipFreezeFormStateCopyWith(MembershipFreezeFormState value, $Res Function(MembershipFreezeFormState) _then) = _$MembershipFreezeFormStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Membership? membership, DateTime? startDate, DateTime? endDate, String reason, Failure? failure, bool isSubmitting, bool success, String? validationError
});




}
/// @nodoc
class _$MembershipFreezeFormStateCopyWithImpl<$Res>
    implements $MembershipFreezeFormStateCopyWith<$Res> {
  _$MembershipFreezeFormStateCopyWithImpl(this._self, this._then);

  final MembershipFreezeFormState _self;
  final $Res Function(MembershipFreezeFormState) _then;

/// Create a copy of MembershipFreezeFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? membership = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? reason = null,Object? failure = freezed,Object? isSubmitting = null,Object? success = null,Object? validationError = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,validationError: freezed == validationError ? _self.validationError : validationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipFreezeFormState].
extension MembershipFreezeFormStatePatterns on MembershipFreezeFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipFreezeFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipFreezeFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipFreezeFormState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipFreezeFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipFreezeFormState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipFreezeFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  DateTime? startDate,  DateTime? endDate,  String reason,  Failure? failure,  bool isSubmitting,  bool success,  String? validationError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipFreezeFormState() when $default != null:
return $default(_that.status,_that.membership,_that.startDate,_that.endDate,_that.reason,_that.failure,_that.isSubmitting,_that.success,_that.validationError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  DateTime? startDate,  DateTime? endDate,  String reason,  Failure? failure,  bool isSubmitting,  bool success,  String? validationError)  $default,) {final _that = this;
switch (_that) {
case _MembershipFreezeFormState():
return $default(_that.status,_that.membership,_that.startDate,_that.endDate,_that.reason,_that.failure,_that.isSubmitting,_that.success,_that.validationError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Membership? membership,  DateTime? startDate,  DateTime? endDate,  String reason,  Failure? failure,  bool isSubmitting,  bool success,  String? validationError)?  $default,) {final _that = this;
switch (_that) {
case _MembershipFreezeFormState() when $default != null:
return $default(_that.status,_that.membership,_that.startDate,_that.endDate,_that.reason,_that.failure,_that.isSubmitting,_that.success,_that.validationError);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipFreezeFormState implements MembershipFreezeFormState {
  const _MembershipFreezeFormState({this.status = LoadStatus.initial, this.membership, this.startDate, this.endDate, this.reason = '', this.failure, this.isSubmitting = false, this.success = false, this.validationError});
  

@override@JsonKey() final  LoadStatus status;
@override final  Membership? membership;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override@JsonKey() final  String reason;
@override final  Failure? failure;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool success;
@override final  String? validationError;

/// Create a copy of MembershipFreezeFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipFreezeFormStateCopyWith<_MembershipFreezeFormState> get copyWith => __$MembershipFreezeFormStateCopyWithImpl<_MembershipFreezeFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipFreezeFormState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.success, success) || other.success == success)&&(identical(other.validationError, validationError) || other.validationError == validationError));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,startDate,endDate,reason,failure,isSubmitting,success,validationError);

@override
String toString() {
  return 'MembershipFreezeFormState(status: $status, membership: $membership, startDate: $startDate, endDate: $endDate, reason: $reason, failure: $failure, isSubmitting: $isSubmitting, success: $success, validationError: $validationError)';
}


}

/// @nodoc
abstract mixin class _$MembershipFreezeFormStateCopyWith<$Res> implements $MembershipFreezeFormStateCopyWith<$Res> {
  factory _$MembershipFreezeFormStateCopyWith(_MembershipFreezeFormState value, $Res Function(_MembershipFreezeFormState) _then) = __$MembershipFreezeFormStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Membership? membership, DateTime? startDate, DateTime? endDate, String reason, Failure? failure, bool isSubmitting, bool success, String? validationError
});




}
/// @nodoc
class __$MembershipFreezeFormStateCopyWithImpl<$Res>
    implements _$MembershipFreezeFormStateCopyWith<$Res> {
  __$MembershipFreezeFormStateCopyWithImpl(this._self, this._then);

  final _MembershipFreezeFormState _self;
  final $Res Function(_MembershipFreezeFormState) _then;

/// Create a copy of MembershipFreezeFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? membership = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? reason = null,Object? failure = freezed,Object? isSubmitting = null,Object? success = null,Object? validationError = freezed,}) {
  return _then(_MembershipFreezeFormState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,validationError: freezed == validationError ? _self.validationError : validationError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
