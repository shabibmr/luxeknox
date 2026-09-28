// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceHistoryState {

 LoadStatus get status; List<AttendanceRecord> get items; String? get nextCursor; bool get hasMore; bool get loadingMore; Failure? get failure;
/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceHistoryStateCopyWith<AttendanceHistoryState> get copyWith => _$AttendanceHistoryStateCopyWithImpl<AttendanceHistoryState>(this as AttendanceHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),nextCursor,hasMore,loadingMore,failure);

@override
String toString() {
  return 'AttendanceHistoryState(status: $status, items: $items, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AttendanceHistoryStateCopyWith<$Res>  {
  factory $AttendanceHistoryStateCopyWith(AttendanceHistoryState value, $Res Function(AttendanceHistoryState) _then) = _$AttendanceHistoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<AttendanceRecord> items, String? nextCursor, bool hasMore, bool loadingMore, Failure? failure
});




}
/// @nodoc
class _$AttendanceHistoryStateCopyWithImpl<$Res>
    implements $AttendanceHistoryStateCopyWith<$Res> {
  _$AttendanceHistoryStateCopyWithImpl(this._self, this._then);

  final AttendanceHistoryState _self;
  final $Res Function(AttendanceHistoryState) _then;

/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceHistoryState].
extension AttendanceHistoryStatePatterns on AttendanceHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<AttendanceRecord> items,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<AttendanceRecord> items,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AttendanceHistoryState():
return $default(_that.status,_that.items,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<AttendanceRecord> items,  String? nextCursor,  bool hasMore,  bool loadingMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceHistoryState() when $default != null:
return $default(_that.status,_that.items,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceHistoryState implements AttendanceHistoryState {
  const _AttendanceHistoryState({this.status = LoadStatus.initial, final  List<AttendanceRecord> items = const <AttendanceRecord>[], this.nextCursor, this.hasMore = false, this.loadingMore = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<AttendanceRecord> _items;
@override@JsonKey() List<AttendanceRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loadingMore;
@override final  Failure? failure;

/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceHistoryStateCopyWith<_AttendanceHistoryState> get copyWith => __$AttendanceHistoryStateCopyWithImpl<_AttendanceHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceHistoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),nextCursor,hasMore,loadingMore,failure);

@override
String toString() {
  return 'AttendanceHistoryState(status: $status, items: $items, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AttendanceHistoryStateCopyWith<$Res> implements $AttendanceHistoryStateCopyWith<$Res> {
  factory _$AttendanceHistoryStateCopyWith(_AttendanceHistoryState value, $Res Function(_AttendanceHistoryState) _then) = __$AttendanceHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<AttendanceRecord> items, String? nextCursor, bool hasMore, bool loadingMore, Failure? failure
});




}
/// @nodoc
class __$AttendanceHistoryStateCopyWithImpl<$Res>
    implements _$AttendanceHistoryStateCopyWith<$Res> {
  __$AttendanceHistoryStateCopyWithImpl(this._self, this._then);

  final _AttendanceHistoryState _self;
  final $Res Function(_AttendanceHistoryState) _then;

/// Create a copy of AttendanceHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? failure = freezed,}) {
  return _then(_AttendanceHistoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc
mixin _$AttendanceSummaryState {

 LoadStatus get status; AttendanceSummaryInfo? get summary; Set<DateTime> get heatmapDays; Failure? get failure;
/// Create a copy of AttendanceSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceSummaryStateCopyWith<AttendanceSummaryState> get copyWith => _$AttendanceSummaryStateCopyWithImpl<AttendanceSummaryState>(this as AttendanceSummaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceSummaryState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.heatmapDays, heatmapDays)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,summary,const DeepCollectionEquality().hash(heatmapDays),failure);

@override
String toString() {
  return 'AttendanceSummaryState(status: $status, summary: $summary, heatmapDays: $heatmapDays, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AttendanceSummaryStateCopyWith<$Res>  {
  factory $AttendanceSummaryStateCopyWith(AttendanceSummaryState value, $Res Function(AttendanceSummaryState) _then) = _$AttendanceSummaryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, AttendanceSummaryInfo? summary, Set<DateTime> heatmapDays, Failure? failure
});




}
/// @nodoc
class _$AttendanceSummaryStateCopyWithImpl<$Res>
    implements $AttendanceSummaryStateCopyWith<$Res> {
  _$AttendanceSummaryStateCopyWithImpl(this._self, this._then);

  final AttendanceSummaryState _self;
  final $Res Function(AttendanceSummaryState) _then;

/// Create a copy of AttendanceSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? summary = freezed,Object? heatmapDays = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AttendanceSummaryInfo?,heatmapDays: null == heatmapDays ? _self.heatmapDays : heatmapDays // ignore: cast_nullable_to_non_nullable
as Set<DateTime>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceSummaryState].
extension AttendanceSummaryStatePatterns on AttendanceSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  AttendanceSummaryInfo? summary,  Set<DateTime> heatmapDays,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceSummaryState() when $default != null:
return $default(_that.status,_that.summary,_that.heatmapDays,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  AttendanceSummaryInfo? summary,  Set<DateTime> heatmapDays,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AttendanceSummaryState():
return $default(_that.status,_that.summary,_that.heatmapDays,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  AttendanceSummaryInfo? summary,  Set<DateTime> heatmapDays,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceSummaryState() when $default != null:
return $default(_that.status,_that.summary,_that.heatmapDays,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceSummaryState implements AttendanceSummaryState {
  const _AttendanceSummaryState({this.status = LoadStatus.initial, this.summary, final  Set<DateTime> heatmapDays = const <DateTime>{}, this.failure}): _heatmapDays = heatmapDays;
  

@override@JsonKey() final  LoadStatus status;
@override final  AttendanceSummaryInfo? summary;
 final  Set<DateTime> _heatmapDays;
@override@JsonKey() Set<DateTime> get heatmapDays {
  if (_heatmapDays is EqualUnmodifiableSetView) return _heatmapDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_heatmapDays);
}

@override final  Failure? failure;

/// Create a copy of AttendanceSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceSummaryStateCopyWith<_AttendanceSummaryState> get copyWith => __$AttendanceSummaryStateCopyWithImpl<_AttendanceSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceSummaryState&&(identical(other.status, status) || other.status == status)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._heatmapDays, _heatmapDays)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,summary,const DeepCollectionEquality().hash(_heatmapDays),failure);

@override
String toString() {
  return 'AttendanceSummaryState(status: $status, summary: $summary, heatmapDays: $heatmapDays, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AttendanceSummaryStateCopyWith<$Res> implements $AttendanceSummaryStateCopyWith<$Res> {
  factory _$AttendanceSummaryStateCopyWith(_AttendanceSummaryState value, $Res Function(_AttendanceSummaryState) _then) = __$AttendanceSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, AttendanceSummaryInfo? summary, Set<DateTime> heatmapDays, Failure? failure
});




}
/// @nodoc
class __$AttendanceSummaryStateCopyWithImpl<$Res>
    implements _$AttendanceSummaryStateCopyWith<$Res> {
  __$AttendanceSummaryStateCopyWithImpl(this._self, this._then);

  final _AttendanceSummaryState _self;
  final $Res Function(_AttendanceSummaryState) _then;

/// Create a copy of AttendanceSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? summary = freezed,Object? heatmapDays = null,Object? failure = freezed,}) {
  return _then(_AttendanceSummaryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as AttendanceSummaryInfo?,heatmapDays: null == heatmapDays ? _self._heatmapDays : heatmapDays // ignore: cast_nullable_to_non_nullable
as Set<DateTime>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

/// @nodoc
mixin _$LiveFeedState {

 LoadStatus get status; List<AttendanceRecord> get items; List<AttendanceHistoryDay> get footfall; String? get nextCursor; bool get hasMore; Failure? get failure;
/// Create a copy of LiveFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveFeedStateCopyWith<LiveFeedState> get copyWith => _$LiveFeedStateCopyWithImpl<LiveFeedState>(this as LiveFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveFeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.footfall, footfall)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(footfall),nextCursor,hasMore,failure);

@override
String toString() {
  return 'LiveFeedState(status: $status, items: $items, footfall: $footfall, nextCursor: $nextCursor, hasMore: $hasMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $LiveFeedStateCopyWith<$Res>  {
  factory $LiveFeedStateCopyWith(LiveFeedState value, $Res Function(LiveFeedState) _then) = _$LiveFeedStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<AttendanceRecord> items, List<AttendanceHistoryDay> footfall, String? nextCursor, bool hasMore, Failure? failure
});




}
/// @nodoc
class _$LiveFeedStateCopyWithImpl<$Res>
    implements $LiveFeedStateCopyWith<$Res> {
  _$LiveFeedStateCopyWithImpl(this._self, this._then);

  final LiveFeedState _self;
  final $Res Function(LiveFeedState) _then;

/// Create a copy of LiveFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? footfall = null,Object? nextCursor = freezed,Object? hasMore = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,footfall: null == footfall ? _self.footfall : footfall // ignore: cast_nullable_to_non_nullable
as List<AttendanceHistoryDay>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveFeedState].
extension LiveFeedStatePatterns on LiveFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveFeedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveFeedState value)  $default,){
final _that = this;
switch (_that) {
case _LiveFeedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _LiveFeedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<AttendanceRecord> items,  List<AttendanceHistoryDay> footfall,  String? nextCursor,  bool hasMore,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveFeedState() when $default != null:
return $default(_that.status,_that.items,_that.footfall,_that.nextCursor,_that.hasMore,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<AttendanceRecord> items,  List<AttendanceHistoryDay> footfall,  String? nextCursor,  bool hasMore,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _LiveFeedState():
return $default(_that.status,_that.items,_that.footfall,_that.nextCursor,_that.hasMore,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<AttendanceRecord> items,  List<AttendanceHistoryDay> footfall,  String? nextCursor,  bool hasMore,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _LiveFeedState() when $default != null:
return $default(_that.status,_that.items,_that.footfall,_that.nextCursor,_that.hasMore,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _LiveFeedState implements LiveFeedState {
  const _LiveFeedState({this.status = LoadStatus.initial, final  List<AttendanceRecord> items = const <AttendanceRecord>[], final  List<AttendanceHistoryDay> footfall = const <AttendanceHistoryDay>[], this.nextCursor, this.hasMore = false, this.failure}): _items = items,_footfall = footfall;
  

@override@JsonKey() final  LoadStatus status;
 final  List<AttendanceRecord> _items;
@override@JsonKey() List<AttendanceRecord> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<AttendanceHistoryDay> _footfall;
@override@JsonKey() List<AttendanceHistoryDay> get footfall {
  if (_footfall is EqualUnmodifiableListView) return _footfall;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_footfall);
}

@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;
@override final  Failure? failure;

/// Create a copy of LiveFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveFeedStateCopyWith<_LiveFeedState> get copyWith => __$LiveFeedStateCopyWithImpl<_LiveFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveFeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._footfall, _footfall)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_footfall),nextCursor,hasMore,failure);

@override
String toString() {
  return 'LiveFeedState(status: $status, items: $items, footfall: $footfall, nextCursor: $nextCursor, hasMore: $hasMore, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$LiveFeedStateCopyWith<$Res> implements $LiveFeedStateCopyWith<$Res> {
  factory _$LiveFeedStateCopyWith(_LiveFeedState value, $Res Function(_LiveFeedState) _then) = __$LiveFeedStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<AttendanceRecord> items, List<AttendanceHistoryDay> footfall, String? nextCursor, bool hasMore, Failure? failure
});




}
/// @nodoc
class __$LiveFeedStateCopyWithImpl<$Res>
    implements _$LiveFeedStateCopyWith<$Res> {
  __$LiveFeedStateCopyWithImpl(this._self, this._then);

  final _LiveFeedState _self;
  final $Res Function(_LiveFeedState) _then;

/// Create a copy of LiveFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? footfall = null,Object? nextCursor = freezed,Object? hasMore = null,Object? failure = freezed,}) {
  return _then(_LiveFeedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceRecord>,footfall: null == footfall ? _self._footfall : footfall // ignore: cast_nullable_to_non_nullable
as List<AttendanceHistoryDay>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
