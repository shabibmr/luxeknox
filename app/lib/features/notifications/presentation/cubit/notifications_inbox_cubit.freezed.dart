// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_inbox_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsInboxState {

 LoadStatus get status; List<AppNotification> get items; InboxFilter get filter; bool get hasMore; String? get nextCursor; bool get loadingMore; Failure? get failure; String? get actionMessage;
/// Create a copy of NotificationsInboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsInboxStateCopyWith<NotificationsInboxState> get copyWith => _$NotificationsInboxStateCopyWithImpl<NotificationsInboxState>(this as NotificationsInboxState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsInboxState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.actionMessage, actionMessage) || other.actionMessage == actionMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),filter,hasMore,nextCursor,loadingMore,failure,actionMessage);

@override
String toString() {
  return 'NotificationsInboxState(status: $status, items: $items, filter: $filter, hasMore: $hasMore, nextCursor: $nextCursor, loadingMore: $loadingMore, failure: $failure, actionMessage: $actionMessage)';
}


}

/// @nodoc
abstract mixin class $NotificationsInboxStateCopyWith<$Res>  {
  factory $NotificationsInboxStateCopyWith(NotificationsInboxState value, $Res Function(NotificationsInboxState) _then) = _$NotificationsInboxStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<AppNotification> items, InboxFilter filter, bool hasMore, String? nextCursor, bool loadingMore, Failure? failure, String? actionMessage
});




}
/// @nodoc
class _$NotificationsInboxStateCopyWithImpl<$Res>
    implements $NotificationsInboxStateCopyWith<$Res> {
  _$NotificationsInboxStateCopyWithImpl(this._self, this._then);

  final NotificationsInboxState _self;
  final $Res Function(NotificationsInboxState) _then;

/// Create a copy of NotificationsInboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? hasMore = null,Object? nextCursor = freezed,Object? loadingMore = null,Object? failure = freezed,Object? actionMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as InboxFilter,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,actionMessage: freezed == actionMessage ? _self.actionMessage : actionMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationsInboxState].
extension NotificationsInboxStatePatterns on NotificationsInboxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsInboxState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsInboxState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsInboxState value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsInboxState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsInboxState value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsInboxState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<AppNotification> items,  InboxFilter filter,  bool hasMore,  String? nextCursor,  bool loadingMore,  Failure? failure,  String? actionMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsInboxState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.hasMore,_that.nextCursor,_that.loadingMore,_that.failure,_that.actionMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<AppNotification> items,  InboxFilter filter,  bool hasMore,  String? nextCursor,  bool loadingMore,  Failure? failure,  String? actionMessage)  $default,) {final _that = this;
switch (_that) {
case _NotificationsInboxState():
return $default(_that.status,_that.items,_that.filter,_that.hasMore,_that.nextCursor,_that.loadingMore,_that.failure,_that.actionMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<AppNotification> items,  InboxFilter filter,  bool hasMore,  String? nextCursor,  bool loadingMore,  Failure? failure,  String? actionMessage)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsInboxState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.hasMore,_that.nextCursor,_that.loadingMore,_that.failure,_that.actionMessage);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsInboxState extends NotificationsInboxState {
  const _NotificationsInboxState({this.status = LoadStatus.initial, final  List<AppNotification> items = const <AppNotification>[], this.filter = InboxFilter.all, this.hasMore = false, this.nextCursor, this.loadingMore = false, this.failure, this.actionMessage}): _items = items,super._();
  

@override@JsonKey() final  LoadStatus status;
 final  List<AppNotification> _items;
@override@JsonKey() List<AppNotification> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  InboxFilter filter;
@override@JsonKey() final  bool hasMore;
@override final  String? nextCursor;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;
@override final  String? actionMessage;

/// Create a copy of NotificationsInboxState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsInboxStateCopyWith<_NotificationsInboxState> get copyWith => __$NotificationsInboxStateCopyWithImpl<_NotificationsInboxState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsInboxState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.actionMessage, actionMessage) || other.actionMessage == actionMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),filter,hasMore,nextCursor,loadingMore,failure,actionMessage);

@override
String toString() {
  return 'NotificationsInboxState(status: $status, items: $items, filter: $filter, hasMore: $hasMore, nextCursor: $nextCursor, loadingMore: $loadingMore, failure: $failure, actionMessage: $actionMessage)';
}


}

/// @nodoc
abstract mixin class _$NotificationsInboxStateCopyWith<$Res> implements $NotificationsInboxStateCopyWith<$Res> {
  factory _$NotificationsInboxStateCopyWith(_NotificationsInboxState value, $Res Function(_NotificationsInboxState) _then) = __$NotificationsInboxStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<AppNotification> items, InboxFilter filter, bool hasMore, String? nextCursor, bool loadingMore, Failure? failure, String? actionMessage
});




}
/// @nodoc
class __$NotificationsInboxStateCopyWithImpl<$Res>
    implements _$NotificationsInboxStateCopyWith<$Res> {
  __$NotificationsInboxStateCopyWithImpl(this._self, this._then);

  final _NotificationsInboxState _self;
  final $Res Function(_NotificationsInboxState) _then;

/// Create a copy of NotificationsInboxState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? hasMore = null,Object? nextCursor = freezed,Object? loadingMore = null,Object? failure = freezed,Object? actionMessage = freezed,}) {
  return _then(_NotificationsInboxState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as InboxFilter,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,actionMessage: freezed == actionMessage ? _self.actionMessage : actionMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
