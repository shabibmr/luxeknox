// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthHistoryState {

 LoadStatus get status; List<HealthInfo> get records; int get currentIndex; String? get message; Failure? get failure;
/// Create a copy of HealthHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthHistoryStateCopyWith<HealthHistoryState> get copyWith => _$HealthHistoryStateCopyWithImpl<HealthHistoryState>(this as HealthHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(records),currentIndex,message,failure);

@override
String toString() {
  return 'HealthHistoryState(status: $status, records: $records, currentIndex: $currentIndex, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HealthHistoryStateCopyWith<$Res>  {
  factory $HealthHistoryStateCopyWith(HealthHistoryState value, $Res Function(HealthHistoryState) _then) = _$HealthHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<HealthInfo> records, int currentIndex, String? message, Failure? failure
});




}
/// @nodoc
class _$HealthHistoryStateCopyWithImpl<$Res>
    implements $HealthHistoryStateCopyWith<$Res> {
  _$HealthHistoryStateCopyWithImpl(this._self, this._then);

  final HealthHistoryState _self;
  final $Res Function(HealthHistoryState) _then;

/// Create a copy of HealthHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? records = null,Object? currentIndex = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<HealthInfo>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthHistoryState].
extension HealthHistoryStatePatterns on HealthHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _HealthHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _HealthHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<HealthInfo> records,  int currentIndex,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthHistoryState() when $default != null:
return $default(_that.status,_that.records,_that.currentIndex,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<HealthInfo> records,  int currentIndex,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _HealthHistoryState():
return $default(_that.status,_that.records,_that.currentIndex,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<HealthInfo> records,  int currentIndex,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _HealthHistoryState() when $default != null:
return $default(_that.status,_that.records,_that.currentIndex,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _HealthHistoryState implements HealthHistoryState {
  const _HealthHistoryState({this.status = LoadStatus.initial, final  List<HealthInfo> records = const <HealthInfo>[], this.currentIndex = 0, this.message, this.failure}): _records = records;
  

@override@JsonKey() final  LoadStatus status;
 final  List<HealthInfo> _records;
@override@JsonKey() List<HealthInfo> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

@override@JsonKey() final  int currentIndex;
@override final  String? message;
@override final  Failure? failure;

/// Create a copy of HealthHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthHistoryStateCopyWith<_HealthHistoryState> get copyWith => __$HealthHistoryStateCopyWithImpl<_HealthHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_records),currentIndex,message,failure);

@override
String toString() {
  return 'HealthHistoryState(status: $status, records: $records, currentIndex: $currentIndex, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$HealthHistoryStateCopyWith<$Res> implements $HealthHistoryStateCopyWith<$Res> {
  factory _$HealthHistoryStateCopyWith(_HealthHistoryState value, $Res Function(_HealthHistoryState) _then) = __$HealthHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<HealthInfo> records, int currentIndex, String? message, Failure? failure
});




}
/// @nodoc
class __$HealthHistoryStateCopyWithImpl<$Res>
    implements _$HealthHistoryStateCopyWith<$Res> {
  __$HealthHistoryStateCopyWithImpl(this._self, this._then);

  final _HealthHistoryState _self;
  final $Res Function(_HealthHistoryState) _then;

/// Create a copy of HealthHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? records = null,Object? currentIndex = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_HealthHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<HealthInfo>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
