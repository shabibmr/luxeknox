// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_notes_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressNotesState {

 LoadStatus get status; List<ProgressNote> get notes; bool get submitting; bool get hasMore; String? get nextCursor; Failure? get failure;
/// Create a copy of ProgressNotesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressNotesStateCopyWith<ProgressNotesState> get copyWith => _$ProgressNotesStateCopyWithImpl<ProgressNotesState>(this as ProgressNotesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressNotesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.notes, notes)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(notes),submitting,hasMore,nextCursor,failure);

@override
String toString() {
  return 'ProgressNotesState(status: $status, notes: $notes, submitting: $submitting, hasMore: $hasMore, nextCursor: $nextCursor, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ProgressNotesStateCopyWith<$Res>  {
  factory $ProgressNotesStateCopyWith(ProgressNotesState value, $Res Function(ProgressNotesState) _then) = _$ProgressNotesStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<ProgressNote> notes, bool submitting, bool hasMore, String? nextCursor, Failure? failure
});




}
/// @nodoc
class _$ProgressNotesStateCopyWithImpl<$Res>
    implements $ProgressNotesStateCopyWith<$Res> {
  _$ProgressNotesStateCopyWithImpl(this._self, this._then);

  final ProgressNotesState _self;
  final $Res Function(ProgressNotesState) _then;

/// Create a copy of ProgressNotesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? notes = null,Object? submitting = null,Object? hasMore = null,Object? nextCursor = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<ProgressNote>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressNotesState].
extension ProgressNotesStatePatterns on ProgressNotesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressNotesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressNotesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressNotesState value)  $default,){
final _that = this;
switch (_that) {
case _ProgressNotesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressNotesState value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressNotesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<ProgressNote> notes,  bool submitting,  bool hasMore,  String? nextCursor,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressNotesState() when $default != null:
return $default(_that.status,_that.notes,_that.submitting,_that.hasMore,_that.nextCursor,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<ProgressNote> notes,  bool submitting,  bool hasMore,  String? nextCursor,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ProgressNotesState():
return $default(_that.status,_that.notes,_that.submitting,_that.hasMore,_that.nextCursor,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<ProgressNote> notes,  bool submitting,  bool hasMore,  String? nextCursor,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ProgressNotesState() when $default != null:
return $default(_that.status,_that.notes,_that.submitting,_that.hasMore,_that.nextCursor,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressNotesState implements ProgressNotesState {
  const _ProgressNotesState({this.status = LoadStatus.initial, final  List<ProgressNote> notes = const <ProgressNote>[], this.submitting = false, this.hasMore = false, this.nextCursor, this.failure}): _notes = notes;
  

@override@JsonKey() final  LoadStatus status;
 final  List<ProgressNote> _notes;
@override@JsonKey() List<ProgressNote> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

@override@JsonKey() final  bool submitting;
@override@JsonKey() final  bool hasMore;
@override final  String? nextCursor;
@override final  Failure? failure;

/// Create a copy of ProgressNotesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressNotesStateCopyWith<_ProgressNotesState> get copyWith => __$ProgressNotesStateCopyWithImpl<_ProgressNotesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressNotesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._notes, _notes)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_notes),submitting,hasMore,nextCursor,failure);

@override
String toString() {
  return 'ProgressNotesState(status: $status, notes: $notes, submitting: $submitting, hasMore: $hasMore, nextCursor: $nextCursor, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ProgressNotesStateCopyWith<$Res> implements $ProgressNotesStateCopyWith<$Res> {
  factory _$ProgressNotesStateCopyWith(_ProgressNotesState value, $Res Function(_ProgressNotesState) _then) = __$ProgressNotesStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<ProgressNote> notes, bool submitting, bool hasMore, String? nextCursor, Failure? failure
});




}
/// @nodoc
class __$ProgressNotesStateCopyWithImpl<$Res>
    implements _$ProgressNotesStateCopyWith<$Res> {
  __$ProgressNotesStateCopyWithImpl(this._self, this._then);

  final _ProgressNotesState _self;
  final $Res Function(_ProgressNotesState) _then;

/// Create a copy of ProgressNotesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? notes = null,Object? submitting = null,Object? hasMore = null,Object? nextCursor = freezed,Object? failure = freezed,}) {
  return _then(_ProgressNotesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<ProgressNote>,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
