// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationDetailState {

 LoadStatus get status; AppNotification? get notification; String? get deepLinkPath; Failure? get failure;
/// Create a copy of NotificationDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationDetailStateCopyWith<NotificationDetailState> get copyWith => _$NotificationDetailStateCopyWithImpl<NotificationDetailState>(this as NotificationDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.deepLinkPath, deepLinkPath) || other.deepLinkPath == deepLinkPath)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,notification,deepLinkPath,failure);

@override
String toString() {
  return 'NotificationDetailState(status: $status, notification: $notification, deepLinkPath: $deepLinkPath, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $NotificationDetailStateCopyWith<$Res>  {
  factory $NotificationDetailStateCopyWith(NotificationDetailState value, $Res Function(NotificationDetailState) _then) = _$NotificationDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, AppNotification? notification, String? deepLinkPath, Failure? failure
});




}
/// @nodoc
class _$NotificationDetailStateCopyWithImpl<$Res>
    implements $NotificationDetailStateCopyWith<$Res> {
  _$NotificationDetailStateCopyWithImpl(this._self, this._then);

  final NotificationDetailState _self;
  final $Res Function(NotificationDetailState) _then;

/// Create a copy of NotificationDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? notification = freezed,Object? deepLinkPath = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,deepLinkPath: freezed == deepLinkPath ? _self.deepLinkPath : deepLinkPath // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationDetailState].
extension NotificationDetailStatePatterns on NotificationDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationDetailState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  AppNotification? notification,  String? deepLinkPath,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationDetailState() when $default != null:
return $default(_that.status,_that.notification,_that.deepLinkPath,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  AppNotification? notification,  String? deepLinkPath,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _NotificationDetailState():
return $default(_that.status,_that.notification,_that.deepLinkPath,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  AppNotification? notification,  String? deepLinkPath,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _NotificationDetailState() when $default != null:
return $default(_that.status,_that.notification,_that.deepLinkPath,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationDetailState implements NotificationDetailState {
  const _NotificationDetailState({this.status = LoadStatus.initial, this.notification, this.deepLinkPath, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  AppNotification? notification;
@override final  String? deepLinkPath;
@override final  Failure? failure;

/// Create a copy of NotificationDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationDetailStateCopyWith<_NotificationDetailState> get copyWith => __$NotificationDetailStateCopyWithImpl<_NotificationDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.deepLinkPath, deepLinkPath) || other.deepLinkPath == deepLinkPath)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,notification,deepLinkPath,failure);

@override
String toString() {
  return 'NotificationDetailState(status: $status, notification: $notification, deepLinkPath: $deepLinkPath, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$NotificationDetailStateCopyWith<$Res> implements $NotificationDetailStateCopyWith<$Res> {
  factory _$NotificationDetailStateCopyWith(_NotificationDetailState value, $Res Function(_NotificationDetailState) _then) = __$NotificationDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, AppNotification? notification, String? deepLinkPath, Failure? failure
});




}
/// @nodoc
class __$NotificationDetailStateCopyWithImpl<$Res>
    implements _$NotificationDetailStateCopyWith<$Res> {
  __$NotificationDetailStateCopyWithImpl(this._self, this._then);

  final _NotificationDetailState _self;
  final $Res Function(_NotificationDetailState) _then;

/// Create a copy of NotificationDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? notification = freezed,Object? deepLinkPath = freezed,Object? failure = freezed,}) {
  return _then(_NotificationDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as AppNotification?,deepLinkPath: freezed == deepLinkPath ? _self.deepLinkPath : deepLinkPath // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
