// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_renew_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembershipRenewState {

 LoadStatus get status; Membership? get membership; List<MembershipProduct> get products; String? get selectedProductId; String get reason; Failure? get failure; bool get isSubmitting; bool get success; bool get isConflict;
/// Create a copy of MembershipRenewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipRenewStateCopyWith<MembershipRenewState> get copyWith => _$MembershipRenewStateCopyWithImpl<MembershipRenewState>(this as MembershipRenewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembershipRenewState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.selectedProductId, selectedProductId) || other.selectedProductId == selectedProductId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.success, success) || other.success == success)&&(identical(other.isConflict, isConflict) || other.isConflict == isConflict));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,const DeepCollectionEquality().hash(products),selectedProductId,reason,failure,isSubmitting,success,isConflict);

@override
String toString() {
  return 'MembershipRenewState(status: $status, membership: $membership, products: $products, selectedProductId: $selectedProductId, reason: $reason, failure: $failure, isSubmitting: $isSubmitting, success: $success, isConflict: $isConflict)';
}


}

/// @nodoc
abstract mixin class $MembershipRenewStateCopyWith<$Res>  {
  factory $MembershipRenewStateCopyWith(MembershipRenewState value, $Res Function(MembershipRenewState) _then) = _$MembershipRenewStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Membership? membership, List<MembershipProduct> products, String? selectedProductId, String reason, Failure? failure, bool isSubmitting, bool success, bool isConflict
});




}
/// @nodoc
class _$MembershipRenewStateCopyWithImpl<$Res>
    implements $MembershipRenewStateCopyWith<$Res> {
  _$MembershipRenewStateCopyWithImpl(this._self, this._then);

  final MembershipRenewState _self;
  final $Res Function(MembershipRenewState) _then;

/// Create a copy of MembershipRenewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? membership = freezed,Object? products = null,Object? selectedProductId = freezed,Object? reason = null,Object? failure = freezed,Object? isSubmitting = null,Object? success = null,Object? isConflict = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<MembershipProduct>,selectedProductId: freezed == selectedProductId ? _self.selectedProductId : selectedProductId // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,isConflict: null == isConflict ? _self.isConflict : isConflict // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MembershipRenewState].
extension MembershipRenewStatePatterns on MembershipRenewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembershipRenewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembershipRenewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembershipRenewState value)  $default,){
final _that = this;
switch (_that) {
case _MembershipRenewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembershipRenewState value)?  $default,){
final _that = this;
switch (_that) {
case _MembershipRenewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  List<MembershipProduct> products,  String? selectedProductId,  String reason,  Failure? failure,  bool isSubmitting,  bool success,  bool isConflict)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembershipRenewState() when $default != null:
return $default(_that.status,_that.membership,_that.products,_that.selectedProductId,_that.reason,_that.failure,_that.isSubmitting,_that.success,_that.isConflict);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Membership? membership,  List<MembershipProduct> products,  String? selectedProductId,  String reason,  Failure? failure,  bool isSubmitting,  bool success,  bool isConflict)  $default,) {final _that = this;
switch (_that) {
case _MembershipRenewState():
return $default(_that.status,_that.membership,_that.products,_that.selectedProductId,_that.reason,_that.failure,_that.isSubmitting,_that.success,_that.isConflict);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Membership? membership,  List<MembershipProduct> products,  String? selectedProductId,  String reason,  Failure? failure,  bool isSubmitting,  bool success,  bool isConflict)?  $default,) {final _that = this;
switch (_that) {
case _MembershipRenewState() when $default != null:
return $default(_that.status,_that.membership,_that.products,_that.selectedProductId,_that.reason,_that.failure,_that.isSubmitting,_that.success,_that.isConflict);case _:
  return null;

}
}

}

/// @nodoc


class _MembershipRenewState implements MembershipRenewState {
  const _MembershipRenewState({this.status = LoadStatus.initial, this.membership, final  List<MembershipProduct> products = const <MembershipProduct>[], this.selectedProductId, this.reason = '', this.failure, this.isSubmitting = false, this.success = false, this.isConflict = false}): _products = products;
  

@override@JsonKey() final  LoadStatus status;
@override final  Membership? membership;
 final  List<MembershipProduct> _products;
@override@JsonKey() List<MembershipProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override final  String? selectedProductId;
@override@JsonKey() final  String reason;
@override final  Failure? failure;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool success;
@override@JsonKey() final  bool isConflict;

/// Create a copy of MembershipRenewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipRenewStateCopyWith<_MembershipRenewState> get copyWith => __$MembershipRenewStateCopyWithImpl<_MembershipRenewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembershipRenewState&&(identical(other.status, status) || other.status == status)&&(identical(other.membership, membership) || other.membership == membership)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.selectedProductId, selectedProductId) || other.selectedProductId == selectedProductId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.success, success) || other.success == success)&&(identical(other.isConflict, isConflict) || other.isConflict == isConflict));
}


@override
int get hashCode => Object.hash(runtimeType,status,membership,const DeepCollectionEquality().hash(_products),selectedProductId,reason,failure,isSubmitting,success,isConflict);

@override
String toString() {
  return 'MembershipRenewState(status: $status, membership: $membership, products: $products, selectedProductId: $selectedProductId, reason: $reason, failure: $failure, isSubmitting: $isSubmitting, success: $success, isConflict: $isConflict)';
}


}

/// @nodoc
abstract mixin class _$MembershipRenewStateCopyWith<$Res> implements $MembershipRenewStateCopyWith<$Res> {
  factory _$MembershipRenewStateCopyWith(_MembershipRenewState value, $Res Function(_MembershipRenewState) _then) = __$MembershipRenewStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Membership? membership, List<MembershipProduct> products, String? selectedProductId, String reason, Failure? failure, bool isSubmitting, bool success, bool isConflict
});




}
/// @nodoc
class __$MembershipRenewStateCopyWithImpl<$Res>
    implements _$MembershipRenewStateCopyWith<$Res> {
  __$MembershipRenewStateCopyWithImpl(this._self, this._then);

  final _MembershipRenewState _self;
  final $Res Function(_MembershipRenewState) _then;

/// Create a copy of MembershipRenewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? membership = freezed,Object? products = null,Object? selectedProductId = freezed,Object? reason = null,Object? failure = freezed,Object? isSubmitting = null,Object? success = null,Object? isConflict = null,}) {
  return _then(_MembershipRenewState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<MembershipProduct>,selectedProductId: freezed == selectedProductId ? _self.selectedProductId : selectedProductId // ignore: cast_nullable_to_non_nullable
as String?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,isConflict: null == isConflict ? _self.isConflict : isConflict // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
