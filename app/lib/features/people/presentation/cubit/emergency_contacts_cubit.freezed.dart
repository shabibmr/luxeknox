// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_contacts_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmergencyContactsState {

 LoadStatus get status; List<EmergencyContact> get contacts; String? get message; Failure? get failure;
/// Create a copy of EmergencyContactsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactsStateCopyWith<EmergencyContactsState> get copyWith => _$EmergencyContactsStateCopyWithImpl<EmergencyContactsState>(this as EmergencyContactsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContactsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.contacts, contacts)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(contacts),message,failure);

@override
String toString() {
  return 'EmergencyContactsState(status: $status, contacts: $contacts, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactsStateCopyWith<$Res>  {
  factory $EmergencyContactsStateCopyWith(EmergencyContactsState value, $Res Function(EmergencyContactsState) _then) = _$EmergencyContactsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<EmergencyContact> contacts, String? message, Failure? failure
});




}
/// @nodoc
class _$EmergencyContactsStateCopyWithImpl<$Res>
    implements $EmergencyContactsStateCopyWith<$Res> {
  _$EmergencyContactsStateCopyWithImpl(this._self, this._then);

  final EmergencyContactsState _self;
  final $Res Function(EmergencyContactsState) _then;

/// Create a copy of EmergencyContactsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? contacts = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<EmergencyContact>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyContactsState].
extension EmergencyContactsStatePatterns on EmergencyContactsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContactsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContactsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContactsState value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContactsState value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<EmergencyContact> contacts,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContactsState() when $default != null:
return $default(_that.status,_that.contacts,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<EmergencyContact> contacts,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactsState():
return $default(_that.status,_that.contacts,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<EmergencyContact> contacts,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactsState() when $default != null:
return $default(_that.status,_that.contacts,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EmergencyContactsState implements EmergencyContactsState {
  const _EmergencyContactsState({this.status = LoadStatus.initial, final  List<EmergencyContact> contacts = const <EmergencyContact>[], this.message, this.failure}): _contacts = contacts;
  

@override@JsonKey() final  LoadStatus status;
 final  List<EmergencyContact> _contacts;
@override@JsonKey() List<EmergencyContact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@override final  String? message;
@override final  Failure? failure;

/// Create a copy of EmergencyContactsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactsStateCopyWith<_EmergencyContactsState> get copyWith => __$EmergencyContactsStateCopyWithImpl<_EmergencyContactsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContactsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._contacts, _contacts)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_contacts),message,failure);

@override
String toString() {
  return 'EmergencyContactsState(status: $status, contacts: $contacts, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactsStateCopyWith<$Res> implements $EmergencyContactsStateCopyWith<$Res> {
  factory _$EmergencyContactsStateCopyWith(_EmergencyContactsState value, $Res Function(_EmergencyContactsState) _then) = __$EmergencyContactsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<EmergencyContact> contacts, String? message, Failure? failure
});




}
/// @nodoc
class __$EmergencyContactsStateCopyWithImpl<$Res>
    implements _$EmergencyContactsStateCopyWith<$Res> {
  __$EmergencyContactsStateCopyWithImpl(this._self, this._then);

  final _EmergencyContactsState _self;
  final $Res Function(_EmergencyContactsState) _then;

/// Create a copy of EmergencyContactsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? contacts = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_EmergencyContactsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<EmergencyContact>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
