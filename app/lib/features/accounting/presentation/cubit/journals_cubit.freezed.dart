// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journals_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalsState {

 LoadStatus get status; List<Journal> get journals; DateTime? get fromDate; DateTime? get toDate; String? get paymentId; String? get sourceType; Failure? get failure;
/// Create a copy of JournalsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalsStateCopyWith<JournalsState> get copyWith => _$JournalsStateCopyWithImpl<JournalsState>(this as JournalsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.journals, journals)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(journals),fromDate,toDate,paymentId,sourceType,failure);

@override
String toString() {
  return 'JournalsState(status: $status, journals: $journals, fromDate: $fromDate, toDate: $toDate, paymentId: $paymentId, sourceType: $sourceType, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $JournalsStateCopyWith<$Res>  {
  factory $JournalsStateCopyWith(JournalsState value, $Res Function(JournalsState) _then) = _$JournalsStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<Journal> journals, DateTime? fromDate, DateTime? toDate, String? paymentId, String? sourceType, Failure? failure
});




}
/// @nodoc
class _$JournalsStateCopyWithImpl<$Res>
    implements $JournalsStateCopyWith<$Res> {
  _$JournalsStateCopyWithImpl(this._self, this._then);

  final JournalsState _self;
  final $Res Function(JournalsState) _then;

/// Create a copy of JournalsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? journals = null,Object? fromDate = freezed,Object? toDate = freezed,Object? paymentId = freezed,Object? sourceType = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,journals: null == journals ? _self.journals : journals // ignore: cast_nullable_to_non_nullable
as List<Journal>,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalsState].
extension JournalsStatePatterns on JournalsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalsState value)  $default,){
final _that = this;
switch (_that) {
case _JournalsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalsState value)?  $default,){
final _that = this;
switch (_that) {
case _JournalsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<Journal> journals,  DateTime? fromDate,  DateTime? toDate,  String? paymentId,  String? sourceType,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalsState() when $default != null:
return $default(_that.status,_that.journals,_that.fromDate,_that.toDate,_that.paymentId,_that.sourceType,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<Journal> journals,  DateTime? fromDate,  DateTime? toDate,  String? paymentId,  String? sourceType,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _JournalsState():
return $default(_that.status,_that.journals,_that.fromDate,_that.toDate,_that.paymentId,_that.sourceType,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<Journal> journals,  DateTime? fromDate,  DateTime? toDate,  String? paymentId,  String? sourceType,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _JournalsState() when $default != null:
return $default(_that.status,_that.journals,_that.fromDate,_that.toDate,_that.paymentId,_that.sourceType,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _JournalsState implements JournalsState {
  const _JournalsState({this.status = LoadStatus.initial, final  List<Journal> journals = const <Journal>[], this.fromDate, this.toDate, this.paymentId, this.sourceType, this.failure}): _journals = journals;
  

@override@JsonKey() final  LoadStatus status;
 final  List<Journal> _journals;
@override@JsonKey() List<Journal> get journals {
  if (_journals is EqualUnmodifiableListView) return _journals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_journals);
}

@override final  DateTime? fromDate;
@override final  DateTime? toDate;
@override final  String? paymentId;
@override final  String? sourceType;
@override final  Failure? failure;

/// Create a copy of JournalsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalsStateCopyWith<_JournalsState> get copyWith => __$JournalsStateCopyWithImpl<_JournalsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._journals, _journals)&&(identical(other.fromDate, fromDate) || other.fromDate == fromDate)&&(identical(other.toDate, toDate) || other.toDate == toDate)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_journals),fromDate,toDate,paymentId,sourceType,failure);

@override
String toString() {
  return 'JournalsState(status: $status, journals: $journals, fromDate: $fromDate, toDate: $toDate, paymentId: $paymentId, sourceType: $sourceType, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$JournalsStateCopyWith<$Res> implements $JournalsStateCopyWith<$Res> {
  factory _$JournalsStateCopyWith(_JournalsState value, $Res Function(_JournalsState) _then) = __$JournalsStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<Journal> journals, DateTime? fromDate, DateTime? toDate, String? paymentId, String? sourceType, Failure? failure
});




}
/// @nodoc
class __$JournalsStateCopyWithImpl<$Res>
    implements _$JournalsStateCopyWith<$Res> {
  __$JournalsStateCopyWithImpl(this._self, this._then);

  final _JournalsState _self;
  final $Res Function(_JournalsState) _then;

/// Create a copy of JournalsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? journals = null,Object? fromDate = freezed,Object? toDate = freezed,Object? paymentId = freezed,Object? sourceType = freezed,Object? failure = freezed,}) {
  return _then(_JournalsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,journals: null == journals ? _self._journals : journals // ignore: cast_nullable_to_non_nullable
as List<Journal>,fromDate: freezed == fromDate ? _self.fromDate : fromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,toDate: freezed == toDate ? _self.toDate : toDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,sourceType: freezed == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
