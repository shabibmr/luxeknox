// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_category_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsCategoryState {

 LoadStatus get status; List<AppSetting> get items; bool get saving; bool get saved; Failure? get failure;
/// Create a copy of SettingsCategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCategoryStateCopyWith<SettingsCategoryState> get copyWith => _$SettingsCategoryStateCopyWithImpl<SettingsCategoryState>(this as SettingsCategoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsCategoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),saving,saved,failure);

@override
String toString() {
  return 'SettingsCategoryState(status: $status, items: $items, saving: $saving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SettingsCategoryStateCopyWith<$Res>  {
  factory $SettingsCategoryStateCopyWith(SettingsCategoryState value, $Res Function(SettingsCategoryState) _then) = _$SettingsCategoryStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, List<AppSetting> items, bool saving, bool saved, Failure? failure
});




}
/// @nodoc
class _$SettingsCategoryStateCopyWithImpl<$Res>
    implements $SettingsCategoryStateCopyWith<$Res> {
  _$SettingsCategoryStateCopyWithImpl(this._self, this._then);

  final SettingsCategoryState _self;
  final $Res Function(SettingsCategoryState) _then;

/// Create a copy of SettingsCategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? saving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AppSetting>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsCategoryState].
extension SettingsCategoryStatePatterns on SettingsCategoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsCategoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsCategoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsCategoryState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsCategoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsCategoryState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsCategoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  List<AppSetting> items,  bool saving,  bool saved,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsCategoryState() when $default != null:
return $default(_that.status,_that.items,_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  List<AppSetting> items,  bool saving,  bool saved,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SettingsCategoryState():
return $default(_that.status,_that.items,_that.saving,_that.saved,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  List<AppSetting> items,  bool saving,  bool saved,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SettingsCategoryState() when $default != null:
return $default(_that.status,_that.items,_that.saving,_that.saved,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsCategoryState implements SettingsCategoryState {
  const _SettingsCategoryState({this.status = LoadStatus.initial, final  List<AppSetting> items = const <AppSetting>[], this.saving = false, this.saved = false, this.failure}): _items = items;
  

@override@JsonKey() final  LoadStatus status;
 final  List<AppSetting> _items;
@override@JsonKey() List<AppSetting> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool saving;
@override@JsonKey() final  bool saved;
@override final  Failure? failure;

/// Create a copy of SettingsCategoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCategoryStateCopyWith<_SettingsCategoryState> get copyWith => __$SettingsCategoryStateCopyWithImpl<_SettingsCategoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsCategoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.saved, saved) || other.saved == saved)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),saving,saved,failure);

@override
String toString() {
  return 'SettingsCategoryState(status: $status, items: $items, saving: $saving, saved: $saved, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SettingsCategoryStateCopyWith<$Res> implements $SettingsCategoryStateCopyWith<$Res> {
  factory _$SettingsCategoryStateCopyWith(_SettingsCategoryState value, $Res Function(_SettingsCategoryState) _then) = __$SettingsCategoryStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, List<AppSetting> items, bool saving, bool saved, Failure? failure
});




}
/// @nodoc
class __$SettingsCategoryStateCopyWithImpl<$Res>
    implements _$SettingsCategoryStateCopyWith<$Res> {
  __$SettingsCategoryStateCopyWithImpl(this._self, this._then);

  final _SettingsCategoryState _self;
  final $Res Function(_SettingsCategoryState) _then;

/// Create a copy of SettingsCategoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? saving = null,Object? saved = null,Object? failure = freezed,}) {
  return _then(_SettingsCategoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AppSetting>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
