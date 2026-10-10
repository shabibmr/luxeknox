// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_progress_photos_vault_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminProgressPhotosVaultState {

 LoadStatus get status; List<ProgressPhoto> get photos; bool get canModerate; Failure? get failure;
/// Create a copy of AdminProgressPhotosVaultState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminProgressPhotosVaultStateCopyWith<AdminProgressPhotosVaultState> get copyWith => _$AdminProgressPhotosVaultStateCopyWithImpl<AdminProgressPhotosVaultState>(this as AdminProgressPhotosVaultState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminProgressPhotosVaultState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.canModerate, canModerate) || other.canModerate == canModerate)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(photos),canModerate,failure);

@override
String toString() {
  return 'AdminProgressPhotosVaultState(status: $status, photos: $photos, canModerate: $canModerate, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AdminProgressPhotosVaultStateCopyWith<$Res>  {
  factory $AdminProgressPhotosVaultStateCopyWith(AdminProgressPhotosVaultState value, $Res Function(AdminProgressPhotosVaultState) _then) = _$AdminProgressPhotosVaultStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<ProgressPhoto> photos, bool canModerate, Failure? failure
});




}
/// @nodoc
class _$AdminProgressPhotosVaultStateCopyWithImpl<$Res>
    implements $AdminProgressPhotosVaultStateCopyWith<$Res> {
  _$AdminProgressPhotosVaultStateCopyWithImpl(this._self, this._then);

  final AdminProgressPhotosVaultState _self;
  final $Res Function(AdminProgressPhotosVaultState) _then;

/// Create a copy of AdminProgressPhotosVaultState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? photos = null,Object? canModerate = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<ProgressPhoto>,canModerate: null == canModerate ? _self.canModerate : canModerate // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminProgressPhotosVaultState].
extension AdminProgressPhotosVaultStatePatterns on AdminProgressPhotosVaultState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminProgressPhotosVaultState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminProgressPhotosVaultState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminProgressPhotosVaultState value)  $default,){
final _that = this;
switch (_that) {
case _AdminProgressPhotosVaultState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminProgressPhotosVaultState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminProgressPhotosVaultState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<ProgressPhoto> photos,  bool canModerate,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminProgressPhotosVaultState() when $default != null:
return $default(_that.status,_that.photos,_that.canModerate,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<ProgressPhoto> photos,  bool canModerate,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AdminProgressPhotosVaultState():
return $default(_that.status,_that.photos,_that.canModerate,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<ProgressPhoto> photos,  bool canModerate,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AdminProgressPhotosVaultState() when $default != null:
return $default(_that.status,_that.photos,_that.canModerate,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AdminProgressPhotosVaultState implements AdminProgressPhotosVaultState {
  const _AdminProgressPhotosVaultState({this.status = LoadStatus.initial, final  List<ProgressPhoto> photos = const <ProgressPhoto>[], this.canModerate = false, this.failure}): _photos = photos;
  

@override@JsonKey() final  LoadStatus status;
 final  List<ProgressPhoto> _photos;
@override@JsonKey() List<ProgressPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey() final  bool canModerate;
@override final  Failure? failure;

/// Create a copy of AdminProgressPhotosVaultState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminProgressPhotosVaultStateCopyWith<_AdminProgressPhotosVaultState> get copyWith => __$AdminProgressPhotosVaultStateCopyWithImpl<_AdminProgressPhotosVaultState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminProgressPhotosVaultState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.canModerate, canModerate) || other.canModerate == canModerate)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_photos),canModerate,failure);

@override
String toString() {
  return 'AdminProgressPhotosVaultState(status: $status, photos: $photos, canModerate: $canModerate, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AdminProgressPhotosVaultStateCopyWith<$Res> implements $AdminProgressPhotosVaultStateCopyWith<$Res> {
  factory _$AdminProgressPhotosVaultStateCopyWith(_AdminProgressPhotosVaultState value, $Res Function(_AdminProgressPhotosVaultState) _then) = __$AdminProgressPhotosVaultStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<ProgressPhoto> photos, bool canModerate, Failure? failure
});




}
/// @nodoc
class __$AdminProgressPhotosVaultStateCopyWithImpl<$Res>
    implements _$AdminProgressPhotosVaultStateCopyWith<$Res> {
  __$AdminProgressPhotosVaultStateCopyWithImpl(this._self, this._then);

  final _AdminProgressPhotosVaultState _self;
  final $Res Function(_AdminProgressPhotosVaultState) _then;

/// Create a copy of AdminProgressPhotosVaultState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? photos = null,Object? canModerate = null,Object? failure = freezed,}) {
  return _then(_AdminProgressPhotosVaultState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<ProgressPhoto>,canModerate: null == canModerate ? _self.canModerate : canModerate // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
