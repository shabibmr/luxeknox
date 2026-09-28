// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memberships_directory_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipsDirectoryState {

 LoadStatus get status; List<Membership> get items; MembershipDirectoryFilter get filter; Failure? get failure;
/// Create a copy of MembershipsDirectoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipsDirectoryStateCopyWith<MembershipsDirectoryState> get copyWith => _$MembershipsDirectoryStateCopyWithImpl<MembershipsDirectoryState>(this as MembershipsDirectoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipsDirectoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),filter,failure);

@override
String toString() {
  return 'MembershipsDirectoryState(status: $status, items: $items, filter: $filter, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MembershipsDirectoryStateCopyWith<$Res>  {
  factory $MembershipsDirectoryStateCopyWith(MembershipsDirectoryState value, $Res Function(MembershipsDirectoryState) _then) = _$MembershipsDirectoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<Membership> items, MembershipDirectoryFilter filter, Failure? failure
});




}
/// @nodoc
class _$MembershipsDirectoryStateCopyWithImpl<$Res>
    implements $MembershipsDirectoryStateCopyWith<$Res> {
  _$MembershipsDirectoryStateCopyWithImpl(this._self, this._then);

  final MembershipsDirectoryState _self;
  final $Res Function(MembershipsDirectoryState) _then;

/// Create a copy of MembershipsDirectoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Membership>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as MembershipDirectoryFilter,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipsDirectoryState].
extension MembershipsDirectoryStatePatterns on MembershipsDirectoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipsDirectoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipsDirectoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipsDirectoryState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipsDirectoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipsDirectoryState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipsDirectoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<Membership> items,  MembershipDirectoryFilter filter,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipsDirectoryState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<Membership> items,  MembershipDirectoryFilter filter,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MembershipsDirectoryState():
return $default(_that.status,_that.items,_that.filter,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<Membership> items,  MembershipDirectoryFilter filter,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MembershipsDirectoryState() when $default != null:
return $default(_that.status,_that.items,_that.filter,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipsDirectoryState implements MembershipsDirectoryState {
  const _MembershipsDirectoryState({this.status = LoadStatus.initial, final  List<Membership> items = const <Membership>[], this.filter = MembershipDirectoryFilter.all, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<Membership> _items;
@override@JsonKey() List<Membership> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  MembershipDirectoryFilter filter;
@override final  Failure? failure;

/// Create a copy of MembershipsDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipsDirectoryStateCopyWith<_MembershipsDirectoryState> get copyWith => __$MembershipsDirectoryStateCopyWithImpl<_MembershipsDirectoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipsDirectoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),filter,failure);

@override
String toString() {
  return 'MembershipsDirectoryState(status: $status, items: $items, filter: $filter, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MembershipsDirectoryStateCopyWith<$Res> implements $MembershipsDirectoryStateCopyWith<$Res> {
  factory _$MembershipsDirectoryStateCopyWith(_MembershipsDirectoryState value, $Res Function(_MembershipsDirectoryState) _then) = __$MembershipsDirectoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<Membership> items, MembershipDirectoryFilter filter, Failure? failure
});




}
/// @nodoc
class __$MembershipsDirectoryStateCopyWithImpl<$Res>
    implements _$MembershipsDirectoryStateCopyWith<$Res> {
  __$MembershipsDirectoryStateCopyWithImpl(this._self, this._then);

  final _MembershipsDirectoryState _self;
  final $Res Function(_MembershipsDirectoryState) _then;

/// Create a copy of MembershipsDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? filter = null,Object? failure = freezed,}) {
  return _then(_MembershipsDirectoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Membership>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as MembershipDirectoryFilter,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
