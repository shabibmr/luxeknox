// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_product_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipProductFormState {

 LoadStatus get status; Failure? get failure; MembershipProduct? get saved;
/// Create a copy of MembershipProductFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipProductFormStateCopyWith<MembershipProductFormState> get copyWith => _$MembershipProductFormStateCopyWithImpl<MembershipProductFormState>(this as MembershipProductFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipProductFormState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.saved, saved) || other.saved == saved));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure,saved);

@override
String toString() {
  return 'MembershipProductFormState(status: $status, failure: $failure, saved: $saved)';
}


}

/// @nodoc
abstract mixin class $MembershipProductFormStateCopyWith<$Res>  {
  factory $MembershipProductFormStateCopyWith(MembershipProductFormState value, $Res Function(MembershipProductFormState) _then) = _$MembershipProductFormStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Failure? failure, MembershipProduct? saved
});




}
/// @nodoc
class _$MembershipProductFormStateCopyWithImpl<$Res>
    implements $MembershipProductFormStateCopyWith<$Res> {
  _$MembershipProductFormStateCopyWithImpl(this._self, this._then);

  final MembershipProductFormState _self;
  final $Res Function(MembershipProductFormState) _then;

/// Create a copy of MembershipProductFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failure = freezed,Object? saved = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as MembershipProduct?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipProductFormState].
extension MembershipProductFormStatePatterns on MembershipProductFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipProductFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipProductFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipProductFormState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipProductFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipProductFormState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipProductFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure,  MembershipProduct? saved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipProductFormState() when $default != null:
return $default(_that.status,_that.failure,_that.saved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure,  MembershipProduct? saved)  $default,) {final _that = this;
switch (_that) {
case _MembershipProductFormState():
return $default(_that.status,_that.failure,_that.saved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Failure? failure,  MembershipProduct? saved)?  $default,) {final _that = this;
switch (_that) {
case _MembershipProductFormState() when $default != null:
return $default(_that.status,_that.failure,_that.saved);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipProductFormState implements MembershipProductFormState {
  const _MembershipProductFormState({this.status = LoadStatus.initial, this.failure, this.saved});
  

@override@JsonKey() final  LoadStatus status;
@override final  Failure? failure;
@override final  MembershipProduct? saved;

/// Create a copy of MembershipProductFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipProductFormStateCopyWith<_MembershipProductFormState> get copyWith => __$MembershipProductFormStateCopyWithImpl<_MembershipProductFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipProductFormState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.saved, saved) || other.saved == saved));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure,saved);

@override
String toString() {
  return 'MembershipProductFormState(status: $status, failure: $failure, saved: $saved)';
}


}

/// @nodoc
abstract mixin class _$MembershipProductFormStateCopyWith<$Res> implements $MembershipProductFormStateCopyWith<$Res> {
  factory _$MembershipProductFormStateCopyWith(_MembershipProductFormState value, $Res Function(_MembershipProductFormState) _then) = __$MembershipProductFormStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Failure? failure, MembershipProduct? saved
});




}
/// @nodoc
class __$MembershipProductFormStateCopyWithImpl<$Res>
    implements _$MembershipProductFormStateCopyWith<$Res> {
  __$MembershipProductFormStateCopyWithImpl(this._self, this._then);

  final _MembershipProductFormState _self;
  final $Res Function(_MembershipProductFormState) _then;

/// Create a copy of MembershipProductFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failure = freezed,Object? saved = freezed,}) {
  return _then(_MembershipProductFormState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,saved: freezed == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as MembershipProduct?,
  ));
}


}

// dart format on
