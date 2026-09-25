// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_freeze_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipFreezeState {

 LoadStatus get status; List<MembershipFreeze> get items; String? get membershipId; Failure? get failure; String? get busyId;
/// Create a copy of MembershipFreezeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipFreezeStateCopyWith<MembershipFreezeState> get copyWith => _$MembershipFreezeStateCopyWithImpl<MembershipFreezeState>(this as MembershipFreezeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipFreezeState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.busyId, busyId) || other.busyId == busyId));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),membershipId,failure,busyId);

@override
String toString() {
  return 'MembershipFreezeState(status: $status, items: $items, membershipId: $membershipId, failure: $failure, busyId: $busyId)';
}


}

/// @nodoc
abstract mixin class $MembershipFreezeStateCopyWith<$Res>  {
  factory $MembershipFreezeStateCopyWith(MembershipFreezeState value, $Res Function(MembershipFreezeState) _then) = _$MembershipFreezeStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MembershipFreeze> items, String? membershipId, Failure? failure, String? busyId
});




}
/// @nodoc
class _$MembershipFreezeStateCopyWithImpl<$Res>
    implements $MembershipFreezeStateCopyWith<$Res> {
  _$MembershipFreezeStateCopyWithImpl(this._self, this._then);

  final MembershipFreezeState _self;
  final $Res Function(MembershipFreezeState) _then;

/// Create a copy of MembershipFreezeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? membershipId = freezed,Object? failure = freezed,Object? busyId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MembershipFreeze>,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,busyId: freezed == busyId ? _self.busyId : busyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipFreezeState].
extension MembershipFreezeStatePatterns on MembershipFreezeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipFreezeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipFreezeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipFreezeState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipFreezeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipFreezeState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipFreezeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MembershipFreeze> items,  String? membershipId,  Failure? failure,  String? busyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipFreezeState() when $default != null:
return $default(_that.status,_that.items,_that.membershipId,_that.failure,_that.busyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MembershipFreeze> items,  String? membershipId,  Failure? failure,  String? busyId)  $default,) {final _that = this;
switch (_that) {
case _MembershipFreezeState():
return $default(_that.status,_that.items,_that.membershipId,_that.failure,_that.busyId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MembershipFreeze> items,  String? membershipId,  Failure? failure,  String? busyId)?  $default,) {final _that = this;
switch (_that) {
case _MembershipFreezeState() when $default != null:
return $default(_that.status,_that.items,_that.membershipId,_that.failure,_that.busyId);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipFreezeState implements MembershipFreezeState {
  const _MembershipFreezeState({this.status = LoadStatus.initial, final  List<MembershipFreeze> items = const <MembershipFreeze>[], this.membershipId, this.failure, this.busyId}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<MembershipFreeze> _items;
@override@JsonKey() List<MembershipFreeze> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? membershipId;
@override final  Failure? failure;
@override final  String? busyId;

/// Create a copy of MembershipFreezeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipFreezeStateCopyWith<_MembershipFreezeState> get copyWith => __$MembershipFreezeStateCopyWithImpl<_MembershipFreezeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipFreezeState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.busyId, busyId) || other.busyId == busyId));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),membershipId,failure,busyId);

@override
String toString() {
  return 'MembershipFreezeState(status: $status, items: $items, membershipId: $membershipId, failure: $failure, busyId: $busyId)';
}


}

/// @nodoc
abstract mixin class _$MembershipFreezeStateCopyWith<$Res> implements $MembershipFreezeStateCopyWith<$Res> {
  factory _$MembershipFreezeStateCopyWith(_MembershipFreezeState value, $Res Function(_MembershipFreezeState) _then) = __$MembershipFreezeStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MembershipFreeze> items, String? membershipId, Failure? failure, String? busyId
});




}
/// @nodoc
class __$MembershipFreezeStateCopyWithImpl<$Res>
    implements _$MembershipFreezeStateCopyWith<$Res> {
  __$MembershipFreezeStateCopyWithImpl(this._self, this._then);

  final _MembershipFreezeState _self;
  final $Res Function(_MembershipFreezeState) _then;

/// Create a copy of MembershipFreezeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? membershipId = freezed,Object? failure = freezed,Object? busyId = freezed,}) {
  return _then(_MembershipFreezeState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MembershipFreeze>,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,busyId: freezed == busyId ? _self.busyId : busyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
