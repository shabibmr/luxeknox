// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photos_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhotosState {

 LoadStatus get status; List<MemberPhoto> get photos; bool get uploading; double? get uploadProgress; String? get uploadError; Uint8List? get pendingBytes; String? get pendingContentType; String? get message; Failure? get failure;
/// Create a copy of PhotosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotosStateCopyWith<PhotosState> get copyWith => _$PhotosStateCopyWithImpl<PhotosState>(this as PhotosState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotosState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.uploading, uploading) || other.uploading == uploading)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.uploadError, uploadError) || other.uploadError == uploadError)&&const DeepCollectionEquality().equals(other.pendingBytes, pendingBytes)&&(identical(other.pendingContentType, pendingContentType) || other.pendingContentType == pendingContentType)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(photos),uploading,uploadProgress,uploadError,const DeepCollectionEquality().hash(pendingBytes),pendingContentType,message,failure);

@override
String toString() {
  return 'PhotosState(status: $status, photos: $photos, uploading: $uploading, uploadProgress: $uploadProgress, uploadError: $uploadError, pendingBytes: $pendingBytes, pendingContentType: $pendingContentType, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PhotosStateCopyWith<$Res>  {
  factory $PhotosStateCopyWith(PhotosState value, $Res Function(PhotosState) _then) = _$PhotosStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MemberPhoto> photos, bool uploading, double? uploadProgress, String? uploadError, Uint8List? pendingBytes, String? pendingContentType, String? message, Failure? failure
});




}
/// @nodoc
class _$PhotosStateCopyWithImpl<$Res>
    implements $PhotosStateCopyWith<$Res> {
  _$PhotosStateCopyWithImpl(this._self, this._then);

  final PhotosState _self;
  final $Res Function(PhotosState) _then;

/// Create a copy of PhotosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? photos = null,Object? uploading = null,Object? uploadProgress = freezed,Object? uploadError = freezed,Object? pendingBytes = freezed,Object? pendingContentType = freezed,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<MemberPhoto>,uploading: null == uploading ? _self.uploading : uploading // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,uploadError: freezed == uploadError ? _self.uploadError : uploadError // ignore: cast_nullable_to_non_nullable
as String?,pendingBytes: freezed == pendingBytes ? _self.pendingBytes : pendingBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pendingContentType: freezed == pendingContentType ? _self.pendingContentType : pendingContentType // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotosState].
extension PhotosStatePatterns on PhotosState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotosState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotosState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotosState value)  $default,){
final _that = this;
switch (_that) {
case _PhotosState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotosState value)?  $default,){
final _that = this;
switch (_that) {
case _PhotosState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MemberPhoto> photos,  bool uploading,  double? uploadProgress,  String? uploadError,  Uint8List? pendingBytes,  String? pendingContentType,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotosState() when $default != null:
return $default(_that.status,_that.photos,_that.uploading,_that.uploadProgress,_that.uploadError,_that.pendingBytes,_that.pendingContentType,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MemberPhoto> photos,  bool uploading,  double? uploadProgress,  String? uploadError,  Uint8List? pendingBytes,  String? pendingContentType,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PhotosState():
return $default(_that.status,_that.photos,_that.uploading,_that.uploadProgress,_that.uploadError,_that.pendingBytes,_that.pendingContentType,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MemberPhoto> photos,  bool uploading,  double? uploadProgress,  String? uploadError,  Uint8List? pendingBytes,  String? pendingContentType,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PhotosState() when $default != null:
return $default(_that.status,_that.photos,_that.uploading,_that.uploadProgress,_that.uploadError,_that.pendingBytes,_that.pendingContentType,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PhotosState extends PhotosState {
  const _PhotosState({this.status = LoadStatus.initial, final  List<MemberPhoto> photos = const <MemberPhoto>[], this.uploading = false, this.uploadProgress, this.uploadError, this.pendingBytes, this.pendingContentType, this.message, this.failure}): _photos = photos,super._();
  

@override@JsonKey() final  LoadStatus status;
 final  List<MemberPhoto> _photos;
@override@JsonKey() List<MemberPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey() final  bool uploading;
@override final  double? uploadProgress;
@override final  String? uploadError;
@override final  Uint8List? pendingBytes;
@override final  String? pendingContentType;
@override final  String? message;
@override final  Failure? failure;

/// Create a copy of PhotosState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotosStateCopyWith<_PhotosState> get copyWith => __$PhotosStateCopyWithImpl<_PhotosState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotosState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.uploading, uploading) || other.uploading == uploading)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.uploadError, uploadError) || other.uploadError == uploadError)&&const DeepCollectionEquality().equals(other.pendingBytes, pendingBytes)&&(identical(other.pendingContentType, pendingContentType) || other.pendingContentType == pendingContentType)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_photos),uploading,uploadProgress,uploadError,const DeepCollectionEquality().hash(pendingBytes),pendingContentType,message,failure);

@override
String toString() {
  return 'PhotosState(status: $status, photos: $photos, uploading: $uploading, uploadProgress: $uploadProgress, uploadError: $uploadError, pendingBytes: $pendingBytes, pendingContentType: $pendingContentType, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PhotosStateCopyWith<$Res> implements $PhotosStateCopyWith<$Res> {
  factory _$PhotosStateCopyWith(_PhotosState value, $Res Function(_PhotosState) _then) = __$PhotosStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MemberPhoto> photos, bool uploading, double? uploadProgress, String? uploadError, Uint8List? pendingBytes, String? pendingContentType, String? message, Failure? failure
});




}
/// @nodoc
class __$PhotosStateCopyWithImpl<$Res>
    implements _$PhotosStateCopyWith<$Res> {
  __$PhotosStateCopyWithImpl(this._self, this._then);

  final _PhotosState _self;
  final $Res Function(_PhotosState) _then;

/// Create a copy of PhotosState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? photos = null,Object? uploading = null,Object? uploadProgress = freezed,Object? uploadError = freezed,Object? pendingBytes = freezed,Object? pendingContentType = freezed,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_PhotosState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MemberPhoto>,uploading: null == uploading ? _self.uploading : uploading // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,uploadError: freezed == uploadError ? _self.uploadError : uploadError // ignore: cast_nullable_to_non_nullable
as String?,pendingBytes: freezed == pendingBytes ? _self.pendingBytes : pendingBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pendingContentType: freezed == pendingContentType ? _self.pendingContentType : pendingContentType // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
