// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_packages_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PtPackagesState {

 LoadStatus get status; List<PtProduct> get items; bool get saving; String? get message; Failure? get failure;
/// Create a copy of PtPackagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PtPackagesStateCopyWith<PtPackagesState> get copyWith => _$PtPackagesStateCopyWithImpl<PtPackagesState>(this as PtPackagesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PtPackagesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),saving,message,failure);

@override
String toString() {
  return 'PtPackagesState(status: $status, items: $items, saving: $saving, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PtPackagesStateCopyWith<$Res>  {
  factory $PtPackagesStateCopyWith(PtPackagesState value, $Res Function(PtPackagesState) _then) = _$PtPackagesStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<PtProduct> items, bool saving, String? message, Failure? failure
});




}
/// @nodoc
class _$PtPackagesStateCopyWithImpl<$Res>
    implements $PtPackagesStateCopyWith<$Res> {
  _$PtPackagesStateCopyWithImpl(this._self, this._then);

  final PtPackagesState _self;
  final $Res Function(PtPackagesState) _then;

/// Create a copy of PtPackagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? saving = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PtProduct>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PtPackagesState].
extension PtPackagesStatePatterns on PtPackagesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PtPackagesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PtPackagesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PtPackagesState value)  $default,){
final _that = this;
switch (_that) {
case _PtPackagesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PtPackagesState value)?  $default,){
final _that = this;
switch (_that) {
case _PtPackagesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<PtProduct> items,  bool saving,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PtPackagesState() when $default != null:
return $default(_that.status,_that.items,_that.saving,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<PtProduct> items,  bool saving,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PtPackagesState():
return $default(_that.status,_that.items,_that.saving,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<PtProduct> items,  bool saving,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PtPackagesState() when $default != null:
return $default(_that.status,_that.items,_that.saving,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PtPackagesState implements PtPackagesState {
  const _PtPackagesState({this.status = LoadStatus.initial, final  List<PtProduct> items = const <PtProduct>[], this.saving = false, this.message, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<PtProduct> _items;
@override@JsonKey() List<PtProduct> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool saving;
@override final  String? message;
@override final  Failure? failure;

/// Create a copy of PtPackagesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PtPackagesStateCopyWith<_PtPackagesState> get copyWith => __$PtPackagesStateCopyWithImpl<_PtPackagesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PtPackagesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),saving,message,failure);

@override
String toString() {
  return 'PtPackagesState(status: $status, items: $items, saving: $saving, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PtPackagesStateCopyWith<$Res> implements $PtPackagesStateCopyWith<$Res> {
  factory _$PtPackagesStateCopyWith(_PtPackagesState value, $Res Function(_PtPackagesState) _then) = __$PtPackagesStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<PtProduct> items, bool saving, String? message, Failure? failure
});




}
/// @nodoc
class __$PtPackagesStateCopyWithImpl<$Res>
    implements _$PtPackagesStateCopyWith<$Res> {
  __$PtPackagesStateCopyWithImpl(this._self, this._then);

  final _PtPackagesState _self;
  final $Res Function(_PtPackagesState) _then;

/// Create a copy of PtPackagesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? saving = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_PtPackagesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PtProduct>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
