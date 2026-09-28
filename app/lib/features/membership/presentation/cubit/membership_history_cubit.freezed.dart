// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipHistoryState {

 LoadStatus get status; List<MembershipHistoryEntry> get items; String? get membershipId; Failure? get failure;
/// Create a copy of MembershipHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipHistoryStateCopyWith<MembershipHistoryState> get copyWith => _$MembershipHistoryStateCopyWithImpl<MembershipHistoryState>(this as MembershipHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),membershipId,failure);

@override
String toString() {
  return 'MembershipHistoryState(status: $status, items: $items, membershipId: $membershipId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MembershipHistoryStateCopyWith<$Res>  {
  factory $MembershipHistoryStateCopyWith(MembershipHistoryState value, $Res Function(MembershipHistoryState) _then) = _$MembershipHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MembershipHistoryEntry> items, String? membershipId, Failure? failure
});




}
/// @nodoc
class _$MembershipHistoryStateCopyWithImpl<$Res>
    implements $MembershipHistoryStateCopyWith<$Res> {
  _$MembershipHistoryStateCopyWithImpl(this._self, this._then);

  final MembershipHistoryState _self;
  final $Res Function(MembershipHistoryState) _then;

/// Create a copy of MembershipHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? membershipId = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MembershipHistoryEntry>,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipHistoryState].
extension MembershipHistoryStatePatterns on MembershipHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MembershipHistoryEntry> items,  String? membershipId,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.membershipId,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MembershipHistoryEntry> items,  String? membershipId,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MembershipHistoryState():
return $default(_that.status,_that.items,_that.membershipId,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MembershipHistoryEntry> items,  String? membershipId,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MembershipHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.membershipId,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipHistoryState implements MembershipHistoryState {
  const _MembershipHistoryState({this.status = LoadStatus.initial, final  List<MembershipHistoryEntry> items = const <MembershipHistoryEntry>[], this.membershipId, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<MembershipHistoryEntry> _items;
@override@JsonKey() List<MembershipHistoryEntry> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? membershipId;
@override final  Failure? failure;

/// Create a copy of MembershipHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipHistoryStateCopyWith<_MembershipHistoryState> get copyWith => __$MembershipHistoryStateCopyWithImpl<_MembershipHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),membershipId,failure);

@override
String toString() {
  return 'MembershipHistoryState(status: $status, items: $items, membershipId: $membershipId, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MembershipHistoryStateCopyWith<$Res> implements $MembershipHistoryStateCopyWith<$Res> {
  factory _$MembershipHistoryStateCopyWith(_MembershipHistoryState value, $Res Function(_MembershipHistoryState) _then) = __$MembershipHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MembershipHistoryEntry> items, String? membershipId, Failure? failure
});




}
/// @nodoc
class __$MembershipHistoryStateCopyWithImpl<$Res>
    implements _$MembershipHistoryStateCopyWith<$Res> {
  __$MembershipHistoryStateCopyWithImpl(this._self, this._then);

  final _MembershipHistoryState _self;
  final $Res Function(_MembershipHistoryState) _then;

/// Create a copy of MembershipHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? membershipId = freezed,Object? failure = freezed,}) {
  return _then(_MembershipHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MembershipHistoryEntry>,membershipId: freezed == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
