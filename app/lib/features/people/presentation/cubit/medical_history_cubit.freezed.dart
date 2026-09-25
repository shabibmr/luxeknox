// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicalHistoryState {

 LoadStatus get status; List<MedicalRecord> get records; String? get message; Failure? get failure;
/// Create a copy of MedicalHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalHistoryStateCopyWith<MedicalHistoryState> get copyWith => _$MedicalHistoryStateCopyWithImpl<MedicalHistoryState>(this as MedicalHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(records),message,failure);

@override
String toString() {
  return 'MedicalHistoryState(status: $status, records: $records, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MedicalHistoryStateCopyWith<$Res>  {
  factory $MedicalHistoryStateCopyWith(MedicalHistoryState value, $Res Function(MedicalHistoryState) _then) = _$MedicalHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<MedicalRecord> records, String? message, Failure? failure
});




}
/// @nodoc
class _$MedicalHistoryStateCopyWithImpl<$Res>
    implements $MedicalHistoryStateCopyWith<$Res> {
  _$MedicalHistoryStateCopyWithImpl(this._self, this._then);

  final MedicalHistoryState _self;
  final $Res Function(MedicalHistoryState) _then;

/// Create a copy of MedicalHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? records = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<MedicalRecord>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalHistoryState].
extension MedicalHistoryStatePatterns on MedicalHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _MedicalHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<MedicalRecord> records,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalHistoryState() when $default != null:
return $default(_that.status,_that.records,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<MedicalRecord> records,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MedicalHistoryState():
return $default(_that.status,_that.records,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<MedicalRecord> records,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MedicalHistoryState() when $default != null:
return $default(_that.status,_that.records,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MedicalHistoryState implements MedicalHistoryState {
  const _MedicalHistoryState({this.status = LoadStatus.initial, final  List<MedicalRecord> records = const <MedicalRecord>[], this.message, this.failure}): _records = records;
  

@override@JsonKey() final  LoadStatus status;
 final  List<MedicalRecord> _records;
@override@JsonKey() List<MedicalRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override final  String? message;
@override final  Failure? failure;

/// Create a copy of MedicalHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalHistoryStateCopyWith<_MedicalHistoryState> get copyWith => __$MedicalHistoryStateCopyWithImpl<_MedicalHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_records),message,failure);

@override
String toString() {
  return 'MedicalHistoryState(status: $status, records: $records, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MedicalHistoryStateCopyWith<$Res> implements $MedicalHistoryStateCopyWith<$Res> {
  factory _$MedicalHistoryStateCopyWith(_MedicalHistoryState value, $Res Function(_MedicalHistoryState) _then) = __$MedicalHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<MedicalRecord> records, String? message, Failure? failure
});




}
/// @nodoc
class __$MedicalHistoryStateCopyWithImpl<$Res>
    implements _$MedicalHistoryStateCopyWith<$Res> {
  __$MedicalHistoryStateCopyWithImpl(this._self, this._then);

  final _MedicalHistoryState _self;
  final $Res Function(_MedicalHistoryState) _then;

/// Create a copy of MedicalHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? records = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_MedicalHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<MedicalRecord>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
