// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goals_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalsListState {

 LoadStatus get status; List<MemberGoal> get items; Failure? get failure;
/// Create a copy of GoalsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalsListStateCopyWith<GoalsListState> get copyWith => _$GoalsListStateCopyWithImpl<GoalsListState>(this as GoalsListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalsListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),failure);

@override
String toString() {
  return 'GoalsListState(status: $status, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $GoalsListStateCopyWith<$Res>  {
  factory $GoalsListStateCopyWith(GoalsListState value, $Res Function(GoalsListState) _then) = _$GoalsListStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MemberGoal> items, Failure? failure
});




}
/// @nodoc
class _$GoalsListStateCopyWithImpl<$Res>
    implements $GoalsListStateCopyWith<$Res> {
  _$GoalsListStateCopyWithImpl(this._self, this._then);

  final GoalsListState _self;
  final $Res Function(GoalsListState) _then;

/// Create a copy of GoalsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MemberGoal>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalsListState].
extension GoalsListStatePatterns on GoalsListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalsListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalsListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalsListState value)  $default,){
final _that = this;
switch (_that) {
case _GoalsListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalsListState value)?  $default,){
final _that = this;
switch (_that) {
case _GoalsListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MemberGoal> items,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalsListState() when $default != null:
return $default(_that.status,_that.items,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MemberGoal> items,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _GoalsListState():
return $default(_that.status,_that.items,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MemberGoal> items,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _GoalsListState() when $default != null:
return $default(_that.status,_that.items,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _GoalsListState implements GoalsListState {
  const _GoalsListState({this.status = LoadStatus.initial, final  List<MemberGoal> items = const <MemberGoal>[], this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<MemberGoal> _items;
@override@JsonKey() List<MemberGoal> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Failure? failure;

/// Create a copy of GoalsListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalsListStateCopyWith<_GoalsListState> get copyWith => __$GoalsListStateCopyWithImpl<_GoalsListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalsListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),failure);

@override
String toString() {
  return 'GoalsListState(status: $status, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$GoalsListStateCopyWith<$Res> implements $GoalsListStateCopyWith<$Res> {
  factory _$GoalsListStateCopyWith(_GoalsListState value, $Res Function(_GoalsListState) _then) = __$GoalsListStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MemberGoal> items, Failure? failure
});




}
/// @nodoc
class __$GoalsListStateCopyWithImpl<$Res>
    implements _$GoalsListStateCopyWith<$Res> {
  __$GoalsListStateCopyWithImpl(this._self, this._then);

  final _GoalsListState _self;
  final $Res Function(_GoalsListState) _then;

/// Create a copy of GoalsListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_GoalsListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MemberGoal>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
