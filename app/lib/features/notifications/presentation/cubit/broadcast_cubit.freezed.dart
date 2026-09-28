// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BroadcastState {

 LoadStatus get status; String get title; String get message; BroadcastAudience get audience; String get roleId; bool get submitting; String? get validationError; Failure? get failure; AppNotification? get submitted; List<AppNotification> get history; bool get historyHasMore; int? get historyOffset; Failure? get historyFailure; BroadcastAudience? get lockedAudience;
/// Create a copy of BroadcastState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BroadcastStateCopyWith<BroadcastState> get copyWith => _$BroadcastStateCopyWithImpl<BroadcastState>(this as BroadcastState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BroadcastState&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.validationError, validationError) || other.validationError == validationError)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.historyHasMore, historyHasMore) || other.historyHasMore == historyHasMore)&&(identical(other.historyOffset, historyOffset) || other.historyOffset == historyOffset)&&(identical(other.historyFailure, historyFailure) || other.historyFailure == historyFailure)&&(identical(other.lockedAudience, lockedAudience) || other.lockedAudience == lockedAudience));
}


@override
int get hashCode => Object.hash(runtimeType,status,title,message,audience,roleId,submitting,validationError,failure,submitted,const DeepCollectionEquality().hash(history),historyHasMore,historyOffset,historyFailure,lockedAudience);

@override
String toString() {
  return 'BroadcastState(status: $status, title: $title, message: $message, audience: $audience, roleId: $roleId, submitting: $submitting, validationError: $validationError, failure: $failure, submitted: $submitted, history: $history, historyHasMore: $historyHasMore, historyOffset: $historyOffset, historyFailure: $historyFailure, lockedAudience: $lockedAudience)';
}


}

/// @nodoc
abstract mixin class $BroadcastStateCopyWith<$Res>  {
  factory $BroadcastStateCopyWith(BroadcastState value, $Res Function(BroadcastState) _then) = _$BroadcastStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, String title, String message, BroadcastAudience audience, String roleId, bool submitting, String? validationError, Failure? failure, AppNotification? submitted, List<AppNotification> history, bool historyHasMore, int? historyOffset, Failure? historyFailure, BroadcastAudience? lockedAudience
});




}
/// @nodoc
class _$BroadcastStateCopyWithImpl<$Res>
    implements $BroadcastStateCopyWith<$Res> {
  _$BroadcastStateCopyWithImpl(this._self, this._then);

  final BroadcastState _self;
  final $Res Function(BroadcastState) _then;

/// Create a copy of BroadcastState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? title = null,Object? message = null,Object? audience = null,Object? roleId = null,Object? submitting = null,Object? validationError = freezed,Object? failure = freezed,Object? submitted = freezed,Object? history = null,Object? historyHasMore = null,Object? historyOffset = freezed,Object? historyFailure = freezed,Object? lockedAudience = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as BroadcastAudience,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,validationError: freezed == validationError ? _self.validationError : validationError // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,submitted: freezed == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as AppNotification?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,historyHasMore: null == historyHasMore ? _self.historyHasMore : historyHasMore // ignore: cast_nullable_to_non_nullable
as bool,historyOffset: freezed == historyOffset ? _self.historyOffset : historyOffset // ignore: cast_nullable_to_non_nullable
as int?,historyFailure: freezed == historyFailure ? _self.historyFailure : historyFailure // ignore: cast_nullable_to_non_nullable
as Failure?,lockedAudience: freezed == lockedAudience ? _self.lockedAudience : lockedAudience // ignore: cast_nullable_to_non_nullable
as BroadcastAudience?,
  ));
}

}


/// Adds pattern-matching-related methods to [BroadcastState].
extension BroadcastStatePatterns on BroadcastState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BroadcastState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BroadcastState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BroadcastState value)  $default,){
final _that = this;
switch (_that) {
case _BroadcastState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BroadcastState value)?  $default,){
final _that = this;
switch (_that) {
case _BroadcastState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  String title,  String message,  BroadcastAudience audience,  String roleId,  bool submitting,  String? validationError,  Failure? failure,  AppNotification? submitted,  List<AppNotification> history,  bool historyHasMore,  int? historyOffset,  Failure? historyFailure,  BroadcastAudience? lockedAudience)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BroadcastState() when $default != null:
return $default(_that.status,_that.title,_that.message,_that.audience,_that.roleId,_that.submitting,_that.validationError,_that.failure,_that.submitted,_that.history,_that.historyHasMore,_that.historyOffset,_that.historyFailure,_that.lockedAudience);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  String title,  String message,  BroadcastAudience audience,  String roleId,  bool submitting,  String? validationError,  Failure? failure,  AppNotification? submitted,  List<AppNotification> history,  bool historyHasMore,  int? historyOffset,  Failure? historyFailure,  BroadcastAudience? lockedAudience)  $default,) {final _that = this;
switch (_that) {
case _BroadcastState():
return $default(_that.status,_that.title,_that.message,_that.audience,_that.roleId,_that.submitting,_that.validationError,_that.failure,_that.submitted,_that.history,_that.historyHasMore,_that.historyOffset,_that.historyFailure,_that.lockedAudience);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  String title,  String message,  BroadcastAudience audience,  String roleId,  bool submitting,  String? validationError,  Failure? failure,  AppNotification? submitted,  List<AppNotification> history,  bool historyHasMore,  int? historyOffset,  Failure? historyFailure,  BroadcastAudience? lockedAudience)?  $default,) {final _that = this;
switch (_that) {
case _BroadcastState() when $default != null:
return $default(_that.status,_that.title,_that.message,_that.audience,_that.roleId,_that.submitting,_that.validationError,_that.failure,_that.submitted,_that.history,_that.historyHasMore,_that.historyOffset,_that.historyFailure,_that.lockedAudience);case _:
  return null;

}
}

}

/// @nodoc


class _BroadcastState extends BroadcastState {
  const _BroadcastState({this.status = LoadStatus.initial, this.title = '', this.message = '', this.audience = BroadcastAudience.allMembers, this.roleId = '', this.submitting = false, this.validationError, this.failure, this.submitted, final  List<AppNotification> history = const <AppNotification>[], this.historyHasMore = false, this.historyOffset, this.historyFailure, this.lockedAudience}): _history = history,super._();
  

@override@JsonKey() final  LoadStatus status;
@override@JsonKey() final  String title;
@override@JsonKey() final  String message;
@override@JsonKey() final  BroadcastAudience audience;
@override@JsonKey() final  String roleId;
@override@JsonKey() final  bool submitting;
@override final  String? validationError;
@override final  Failure? failure;
@override final  AppNotification? submitted;
 final  List<AppNotification> _history;
@override@JsonKey() List<AppNotification> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override@JsonKey() final  bool historyHasMore;
@override final  int? historyOffset;
@override final  Failure? historyFailure;
@override final  BroadcastAudience? lockedAudience;

/// Create a copy of BroadcastState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BroadcastStateCopyWith<_BroadcastState> get copyWith => __$BroadcastStateCopyWithImpl<_BroadcastState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BroadcastState&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.audience, audience) || other.audience == audience)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.validationError, validationError) || other.validationError == validationError)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.historyHasMore, historyHasMore) || other.historyHasMore == historyHasMore)&&(identical(other.historyOffset, historyOffset) || other.historyOffset == historyOffset)&&(identical(other.historyFailure, historyFailure) || other.historyFailure == historyFailure)&&(identical(other.lockedAudience, lockedAudience) || other.lockedAudience == lockedAudience));
}


@override
int get hashCode => Object.hash(runtimeType,status,title,message,audience,roleId,submitting,validationError,failure,submitted,const DeepCollectionEquality().hash(_history),historyHasMore,historyOffset,historyFailure,lockedAudience);

@override
String toString() {
  return 'BroadcastState(status: $status, title: $title, message: $message, audience: $audience, roleId: $roleId, submitting: $submitting, validationError: $validationError, failure: $failure, submitted: $submitted, history: $history, historyHasMore: $historyHasMore, historyOffset: $historyOffset, historyFailure: $historyFailure, lockedAudience: $lockedAudience)';
}


}

/// @nodoc
abstract mixin class _$BroadcastStateCopyWith<$Res> implements $BroadcastStateCopyWith<$Res> {
  factory _$BroadcastStateCopyWith(_BroadcastState value, $Res Function(_BroadcastState) _then) = __$BroadcastStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, String title, String message, BroadcastAudience audience, String roleId, bool submitting, String? validationError, Failure? failure, AppNotification? submitted, List<AppNotification> history, bool historyHasMore, int? historyOffset, Failure? historyFailure, BroadcastAudience? lockedAudience
});




}
/// @nodoc
class __$BroadcastStateCopyWithImpl<$Res>
    implements _$BroadcastStateCopyWith<$Res> {
  __$BroadcastStateCopyWithImpl(this._self, this._then);

  final _BroadcastState _self;
  final $Res Function(_BroadcastState) _then;

/// Create a copy of BroadcastState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? title = null,Object? message = null,Object? audience = null,Object? roleId = null,Object? submitting = null,Object? validationError = freezed,Object? failure = freezed,Object? submitted = freezed,Object? history = null,Object? historyHasMore = null,Object? historyOffset = freezed,Object? historyFailure = freezed,Object? lockedAudience = freezed,}) {
  return _then(_BroadcastState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,audience: null == audience ? _self.audience : audience // ignore: cast_nullable_to_non_nullable
as BroadcastAudience,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,validationError: freezed == validationError ? _self.validationError : validationError // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,submitted: freezed == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as AppNotification?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,historyHasMore: null == historyHasMore ? _self.historyHasMore : historyHasMore // ignore: cast_nullable_to_non_nullable
as bool,historyOffset: freezed == historyOffset ? _self.historyOffset : historyOffset // ignore: cast_nullable_to_non_nullable
as int?,historyFailure: freezed == historyFailure ? _self.historyFailure : historyFailure // ignore: cast_nullable_to_non_nullable
as Failure?,lockedAudience: freezed == lockedAudience ? _self.lockedAudience : lockedAudience // ignore: cast_nullable_to_non_nullable
as BroadcastAudience?,
  ));
}


}

// dart format on
