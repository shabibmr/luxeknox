// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_picker_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExercisePickerState {

 LoadStatus get status; List<Exercise> get items; Failure? get failure;
/// Create a copy of ExercisePickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExercisePickerStateCopyWith<ExercisePickerState> get copyWith => _$ExercisePickerStateCopyWithImpl<ExercisePickerState>(this as ExercisePickerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExercisePickerState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),failure);

@override
String toString() {
  return 'ExercisePickerState(status: $status, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExercisePickerStateCopyWith<$Res>  {
  factory $ExercisePickerStateCopyWith(ExercisePickerState value, $Res Function(ExercisePickerState) _then) = _$ExercisePickerStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<Exercise> items, Failure? failure
});




}
/// @nodoc
class _$ExercisePickerStateCopyWithImpl<$Res>
    implements $ExercisePickerStateCopyWith<$Res> {
  _$ExercisePickerStateCopyWithImpl(this._self, this._then);

  final ExercisePickerState _self;
  final $Res Function(ExercisePickerState) _then;

/// Create a copy of ExercisePickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Exercise>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExercisePickerState].
extension ExercisePickerStatePatterns on ExercisePickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExercisePickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExercisePickerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExercisePickerState value)  $default,){
final _that = this;
switch (_that) {
case _ExercisePickerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExercisePickerState value)?  $default,){
final _that = this;
switch (_that) {
case _ExercisePickerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<Exercise> items,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExercisePickerState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<Exercise> items,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ExercisePickerState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<Exercise> items,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ExercisePickerState() when $default != null:
return $default(_that.status,_that.items,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ExercisePickerState implements ExercisePickerState {
  const _ExercisePickerState({this.status = LoadStatus.initial, final  List<Exercise> items = const <Exercise>[], this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<Exercise> _items;
@override@JsonKey() List<Exercise> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Failure? failure;

/// Create a copy of ExercisePickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExercisePickerStateCopyWith<_ExercisePickerState> get copyWith => __$ExercisePickerStateCopyWithImpl<_ExercisePickerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExercisePickerState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),failure);

@override
String toString() {
  return 'ExercisePickerState(status: $status, items: $items, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ExercisePickerStateCopyWith<$Res> implements $ExercisePickerStateCopyWith<$Res> {
  factory _$ExercisePickerStateCopyWith(_ExercisePickerState value, $Res Function(_ExercisePickerState) _then) = __$ExercisePickerStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<Exercise> items, Failure? failure
});




}
/// @nodoc
class __$ExercisePickerStateCopyWithImpl<$Res>
    implements _$ExercisePickerStateCopyWith<$Res> {
  __$ExercisePickerStateCopyWithImpl(this._self, this._then);

  final _ExercisePickerState _self;
  final $Res Function(_ExercisePickerState) _then;

/// Create a copy of ExercisePickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? failure = freezed,}) {
  return _then(_ExercisePickerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Exercise>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
