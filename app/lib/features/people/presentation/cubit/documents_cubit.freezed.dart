// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentsState {

 LoadStatus get status; List<MemberDocument> get documents; bool get uploading; double? get uploadProgress; String? get uploadError; Uint8List? get pendingBytes; String? get pendingContentType; DocumentPurpose? get pendingPurpose; String? get pendingTitle; Failure? get failure;
/// Create a copy of DocumentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentsStateCopyWith<DocumentsState> get copyWith => _$DocumentsStateCopyWithImpl<DocumentsState>(this as DocumentsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.documents, documents)&&(identical(other.uploading, uploading) || other.uploading == uploading)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.uploadError, uploadError) || other.uploadError == uploadError)&&const DeepCollectionEquality().equals(other.pendingBytes, pendingBytes)&&(identical(other.pendingContentType, pendingContentType) || other.pendingContentType == pendingContentType)&&(identical(other.pendingPurpose, pendingPurpose) || other.pendingPurpose == pendingPurpose)&&(identical(other.pendingTitle, pendingTitle) || other.pendingTitle == pendingTitle)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(documents),uploading,uploadProgress,uploadError,const DeepCollectionEquality().hash(pendingBytes),pendingContentType,pendingPurpose,pendingTitle,failure);

@override
String toString() {
  return 'DocumentsState(status: $status, documents: $documents, uploading: $uploading, uploadProgress: $uploadProgress, uploadError: $uploadError, pendingBytes: $pendingBytes, pendingContentType: $pendingContentType, pendingPurpose: $pendingPurpose, pendingTitle: $pendingTitle, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DocumentsStateCopyWith<$Res>  {
  factory $DocumentsStateCopyWith(DocumentsState value, $Res Function(DocumentsState) _then) = _$DocumentsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MemberDocument> documents, bool uploading, double? uploadProgress, String? uploadError, Uint8List? pendingBytes, String? pendingContentType, DocumentPurpose? pendingPurpose, String? pendingTitle, Failure? failure
});




}
/// @nodoc
class _$DocumentsStateCopyWithImpl<$Res>
    implements $DocumentsStateCopyWith<$Res> {
  _$DocumentsStateCopyWithImpl(this._self, this._then);

  final DocumentsState _self;
  final $Res Function(DocumentsState) _then;

/// Create a copy of DocumentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? documents = null,Object? uploading = null,Object? uploadProgress = freezed,Object? uploadError = freezed,Object? pendingBytes = freezed,Object? pendingContentType = freezed,Object? pendingPurpose = freezed,Object? pendingTitle = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<MemberDocument>,uploading: null == uploading ? _self.uploading : uploading // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,uploadError: freezed == uploadError ? _self.uploadError : uploadError // ignore: cast_nullable_to_non_nullable
as String?,pendingBytes: freezed == pendingBytes ? _self.pendingBytes : pendingBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pendingContentType: freezed == pendingContentType ? _self.pendingContentType : pendingContentType // ignore: cast_nullable_to_non_nullable
as String?,pendingPurpose: freezed == pendingPurpose ? _self.pendingPurpose : pendingPurpose // ignore: cast_nullable_to_non_nullable
as DocumentPurpose?,pendingTitle: freezed == pendingTitle ? _self.pendingTitle : pendingTitle // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentsState].
extension DocumentsStatePatterns on DocumentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentsState value)  $default,){
final _that = this;
switch (_that) {
case _DocumentsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentsState value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MemberDocument> documents,  bool uploading,  double? uploadProgress,  String? uploadError,  Uint8List? pendingBytes,  String? pendingContentType,  DocumentPurpose? pendingPurpose,  String? pendingTitle,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentsState() when $default != null:
return $default(_that.status,_that.documents,_that.uploading,_that.uploadProgress,_that.uploadError,_that.pendingBytes,_that.pendingContentType,_that.pendingPurpose,_that.pendingTitle,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MemberDocument> documents,  bool uploading,  double? uploadProgress,  String? uploadError,  Uint8List? pendingBytes,  String? pendingContentType,  DocumentPurpose? pendingPurpose,  String? pendingTitle,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DocumentsState():
return $default(_that.status,_that.documents,_that.uploading,_that.uploadProgress,_that.uploadError,_that.pendingBytes,_that.pendingContentType,_that.pendingPurpose,_that.pendingTitle,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MemberDocument> documents,  bool uploading,  double? uploadProgress,  String? uploadError,  Uint8List? pendingBytes,  String? pendingContentType,  DocumentPurpose? pendingPurpose,  String? pendingTitle,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DocumentsState() when $default != null:
return $default(_that.status,_that.documents,_that.uploading,_that.uploadProgress,_that.uploadError,_that.pendingBytes,_that.pendingContentType,_that.pendingPurpose,_that.pendingTitle,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentsState extends DocumentsState {
  const _DocumentsState({this.status = LoadStatus.initial, final  List<MemberDocument> documents = const <MemberDocument>[], this.uploading = false, this.uploadProgress, this.uploadError, this.pendingBytes, this.pendingContentType, this.pendingPurpose, this.pendingTitle, this.failure}): _documents = documents,super._();
  

@override@JsonKey() final  LoadStatus status;
 final  List<MemberDocument> _documents;
@override@JsonKey() List<MemberDocument> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override@JsonKey() final  bool uploading;
@override final  double? uploadProgress;
@override final  String? uploadError;
@override final  Uint8List? pendingBytes;
@override final  String? pendingContentType;
@override final  DocumentPurpose? pendingPurpose;
@override final  String? pendingTitle;
@override final  Failure? failure;

/// Create a copy of DocumentsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentsStateCopyWith<_DocumentsState> get copyWith => __$DocumentsStateCopyWithImpl<_DocumentsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.uploading, uploading) || other.uploading == uploading)&&(identical(other.uploadProgress, uploadProgress) || other.uploadProgress == uploadProgress)&&(identical(other.uploadError, uploadError) || other.uploadError == uploadError)&&const DeepCollectionEquality().equals(other.pendingBytes, pendingBytes)&&(identical(other.pendingContentType, pendingContentType) || other.pendingContentType == pendingContentType)&&(identical(other.pendingPurpose, pendingPurpose) || other.pendingPurpose == pendingPurpose)&&(identical(other.pendingTitle, pendingTitle) || other.pendingTitle == pendingTitle)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_documents),uploading,uploadProgress,uploadError,const DeepCollectionEquality().hash(pendingBytes),pendingContentType,pendingPurpose,pendingTitle,failure);

@override
String toString() {
  return 'DocumentsState(status: $status, documents: $documents, uploading: $uploading, uploadProgress: $uploadProgress, uploadError: $uploadError, pendingBytes: $pendingBytes, pendingContentType: $pendingContentType, pendingPurpose: $pendingPurpose, pendingTitle: $pendingTitle, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DocumentsStateCopyWith<$Res> implements $DocumentsStateCopyWith<$Res> {
  factory _$DocumentsStateCopyWith(_DocumentsState value, $Res Function(_DocumentsState) _then) = __$DocumentsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MemberDocument> documents, bool uploading, double? uploadProgress, String? uploadError, Uint8List? pendingBytes, String? pendingContentType, DocumentPurpose? pendingPurpose, String? pendingTitle, Failure? failure
});




}
/// @nodoc
class __$DocumentsStateCopyWithImpl<$Res>
    implements _$DocumentsStateCopyWith<$Res> {
  __$DocumentsStateCopyWithImpl(this._self, this._then);

  final _DocumentsState _self;
  final $Res Function(_DocumentsState) _then;

/// Create a copy of DocumentsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? documents = null,Object? uploading = null,Object? uploadProgress = freezed,Object? uploadError = freezed,Object? pendingBytes = freezed,Object? pendingContentType = freezed,Object? pendingPurpose = freezed,Object? pendingTitle = freezed,Object? failure = freezed,}) {
  return _then(_DocumentsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<MemberDocument>,uploading: null == uploading ? _self.uploading : uploading // ignore: cast_nullable_to_non_nullable
as bool,uploadProgress: freezed == uploadProgress ? _self.uploadProgress : uploadProgress // ignore: cast_nullable_to_non_nullable
as double?,uploadError: freezed == uploadError ? _self.uploadError : uploadError // ignore: cast_nullable_to_non_nullable
as String?,pendingBytes: freezed == pendingBytes ? _self.pendingBytes : pendingBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,pendingContentType: freezed == pendingContentType ? _self.pendingContentType : pendingContentType // ignore: cast_nullable_to_non_nullable
as String?,pendingPurpose: freezed == pendingPurpose ? _self.pendingPurpose : pendingPurpose // ignore: cast_nullable_to_non_nullable
as DocumentPurpose?,pendingTitle: freezed == pendingTitle ? _self.pendingTitle : pendingTitle // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
