// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_member_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditMemberState {

 LoadStatus get status; Person? get person; bool get saving; bool get saved; Failure? get failure;
/// Create a copy of EditMemberState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditMemberStateCopyWith<EditMemberState> get copyWith => _$EditMemberStateCopyWithImpl<EditMemberState>(this as EditMemberState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditMemberState&&(identical(other.status, status) || other.status == status)&&(identical(other.person, person) || other.person == person)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,person,saving,saved,failure);

@override
String toString() {
  return 'EditMemberState(status: $status, person: $person, saving: $saving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EditMemberStateCopyWith<$Res>  {
  factory $EditMemberStateCopyWith(EditMemberState value, $Res Function(EditMemberState) _then) = _$EditMemberStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Person? person, bool saving, bool saved, Failure? failure
});




}
/// @nodoc
class _$EditMemberStateCopyWithImpl<$Res>
    implements $EditMemberStateCopyWith<$Res> {
  _$EditMemberStateCopyWithImpl(this._self, this._then);

  final EditMemberState _self;
  final $Res Function(EditMemberState) _then;

/// Create a copy of EditMemberState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? person = freezed,Object? saving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditMemberState].
extension EditMemberStatePatterns on EditMemberState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditMemberState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditMemberState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditMemberState value)  $default,){
final _that = this;
switch (_that) {
case _EditMemberState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditMemberState value)?  $default,){
final _that = this;
switch (_that) {
case _EditMemberState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Person? person,  bool saving,  bool saved,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditMemberState() when $default != null:
return $default(_that.status,_that.person,_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Person? person,  bool saving,  bool saved,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EditMemberState():
return $default(_that.status,_that.person,_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Person? person,  bool saving,  bool saved,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EditMemberState() when $default != null:
return $default(_that.status,_that.person,_that.saving,_that.saved,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EditMemberState implements EditMemberState {
  const _EditMemberState({this.status = LoadStatus.initial, this.person, this.saving = false, this.saved = false, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  Person? person;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool saved;
@override final  Failure? failure;

/// Create a copy of EditMemberState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditMemberStateCopyWith<_EditMemberState> get copyWith => __$EditMemberStateCopyWithImpl<_EditMemberState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditMemberState&&(identical(other.status, status) || other.status == status)&&(identical(other.person, person) || other.person == person)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,person,saving,saved,failure);

@override
String toString() {
  return 'EditMemberState(status: $status, person: $person, saving: $saving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EditMemberStateCopyWith<$Res> implements $EditMemberStateCopyWith<$Res> {
  factory _$EditMemberStateCopyWith(_EditMemberState value, $Res Function(_EditMemberState) _then) = __$EditMemberStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Person? person, bool saving, bool saved, Failure? failure
});




}
/// @nodoc
class __$EditMemberStateCopyWithImpl<$Res>
    implements _$EditMemberStateCopyWith<$Res> {
  __$EditMemberStateCopyWithImpl(this._self, this._then);

  final _EditMemberState _self;
  final $Res Function(_EditMemberState) _then;

/// Create a copy of EditMemberState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? person = freezed,Object? saving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(_EditMemberState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
