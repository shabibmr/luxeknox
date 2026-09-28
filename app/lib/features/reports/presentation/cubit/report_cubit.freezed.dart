// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportState {

 LoadStatus get status; ReportQuery get query; ReportResult? get result; int get pageIndex; bool get exporting; String? get exportedCsv; Failure? get failure;
/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportStateCopyWith<ReportState> get copyWith => _$ReportStateCopyWithImpl<ReportState>(this as ReportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportState&&(identical(other.status, status) || other.status == status)&&(identical(other.query, query) || other.query == query)&&(identical(other.result, result) || other.result == result)&&(identical(other.pageIndex, pageIndex) || other.pageIndex == pageIndex)&&(identical(other.exporting, exporting) || other.exporting == exporting)&&(identical(other.exportedCsv, exportedCsv) || other.exportedCsv == exportedCsv)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,query,result,pageIndex,exporting,exportedCsv,failure);

@override
String toString() {
  return 'ReportState(status: $status, query: $query, result: $result, pageIndex: $pageIndex, exporting: $exporting, exportedCsv: $exportedCsv, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ReportStateCopyWith<$Res>  {
  factory $ReportStateCopyWith(ReportState value, $Res Function(ReportState) _then) = _$ReportStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, ReportQuery query, ReportResult? result, int pageIndex, bool exporting, String? exportedCsv, Failure? failure
});




}
/// @nodoc
class _$ReportStateCopyWithImpl<$Res>
    implements $ReportStateCopyWith<$Res> {
  _$ReportStateCopyWithImpl(this._self, this._then);

  final ReportState _self;
  final $Res Function(ReportState) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? query = null,Object? result = freezed,Object? pageIndex = null,Object? exporting = null,Object? exportedCsv = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as ReportQuery,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ReportResult?,pageIndex: null == pageIndex ? _self.pageIndex : pageIndex // ignore: cast_nullable_to_non_nullable
as int,exporting: null == exporting ? _self.exporting : exporting // ignore: cast_nullable_to_non_nullable
as bool,exportedCsv: freezed == exportedCsv ? _self.exportedCsv : exportedCsv // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportState].
extension ReportStatePatterns on ReportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportState value)  $default,){
final _that = this;
switch (_that) {
case _ReportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportState value)?  $default,){
final _that = this;
switch (_that) {
case _ReportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  ReportQuery query,  ReportResult? result,  int pageIndex,  bool exporting,  String? exportedCsv,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportState() when $default != null:
return $default(_that.status,_that.query,_that.result,_that.pageIndex,_that.exporting,_that.exportedCsv,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  ReportQuery query,  ReportResult? result,  int pageIndex,  bool exporting,  String? exportedCsv,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ReportState():
return $default(_that.status,_that.query,_that.result,_that.pageIndex,_that.exporting,_that.exportedCsv,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  ReportQuery query,  ReportResult? result,  int pageIndex,  bool exporting,  String? exportedCsv,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ReportState() when $default != null:
return $default(_that.status,_that.query,_that.result,_that.pageIndex,_that.exporting,_that.exportedCsv,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ReportState extends ReportState {
  const _ReportState({this.status = LoadStatus.initial, required this.query, this.result, this.pageIndex = 0, this.exporting = false, this.exportedCsv, this.failure}): super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  ReportQuery query;
@override final  ReportResult? result;
@override@JsonKey() final  int pageIndex;
@override@JsonKey() final  bool exporting;
@override final  String? exportedCsv;
@override final  Failure? failure;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportStateCopyWith<_ReportState> get copyWith => __$ReportStateCopyWithImpl<_ReportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportState&&(identical(other.status, status) || other.status == status)&&(identical(other.query, query) || other.query == query)&&(identical(other.result, result) || other.result == result)&&(identical(other.pageIndex, pageIndex) || other.pageIndex == pageIndex)&&(identical(other.exporting, exporting) || other.exporting == exporting)&&(identical(other.exportedCsv, exportedCsv) || other.exportedCsv == exportedCsv)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,query,result,pageIndex,exporting,exportedCsv,failure);

@override
String toString() {
  return 'ReportState(status: $status, query: $query, result: $result, pageIndex: $pageIndex, exporting: $exporting, exportedCsv: $exportedCsv, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ReportStateCopyWith<$Res> implements $ReportStateCopyWith<$Res> {
  factory _$ReportStateCopyWith(_ReportState value, $Res Function(_ReportState) _then) = __$ReportStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, ReportQuery query, ReportResult? result, int pageIndex, bool exporting, String? exportedCsv, Failure? failure
});




}
/// @nodoc
class __$ReportStateCopyWithImpl<$Res>
    implements _$ReportStateCopyWith<$Res> {
  __$ReportStateCopyWithImpl(this._self, this._then);

  final _ReportState _self;
  final $Res Function(_ReportState) _then;

/// Create a copy of ReportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? query = null,Object? result = freezed,Object? pageIndex = null,Object? exporting = null,Object? exportedCsv = freezed,Object? failure = freezed,}) {
  return _then(_ReportState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as ReportQuery,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ReportResult?,pageIndex: null == pageIndex ? _self.pageIndex : pageIndex // ignore: cast_nullable_to_non_nullable
as int,exporting: null == exporting ? _self.exporting : exporting // ignore: cast_nullable_to_non_nullable
as bool,exportedCsv: freezed == exportedCsv ? _self.exportedCsv : exportedCsv // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
