// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_membership_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateMembershipState {

 LoadStatus get status; Failure? get failure; List<MembershipProduct> get products; List<ProfileSummary> get members; String? get selectedMemberId; String? get selectedProductId; DateTime? get startDate; String? get lockerNumber; bool get autoRenew; bool get submitting; String? get fieldError; String? get submitError; Membership? get created;
/// Create a copy of CreateMembershipState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateMembershipStateCopyWith<CreateMembershipState> get copyWith => _$CreateMembershipStateCopyWithImpl<CreateMembershipState>(this as CreateMembershipState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateMembershipState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&(identical(other.selectedProductId, selectedProductId) || other.selectedProductId == selectedProductId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.lockerNumber, lockerNumber) || other.lockerNumber == lockerNumber)&&(identical(other.autoRenew, autoRenew) || other.autoRenew == autoRenew)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.fieldError, fieldError) || other.fieldError == fieldError)&&(identical(other.submitError, submitError) || other.submitError == submitError)&&(identical(other.created, created) || other.created == created));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(members),selectedMemberId,selectedProductId,startDate,lockerNumber,autoRenew,submitting,fieldError,submitError,created);

@override
String toString() {
  return 'CreateMembershipState(status: $status, failure: $failure, products: $products, members: $members, selectedMemberId: $selectedMemberId, selectedProductId: $selectedProductId, startDate: $startDate, lockerNumber: $lockerNumber, autoRenew: $autoRenew, submitting: $submitting, fieldError: $fieldError, submitError: $submitError, created: $created)';
}


}

/// @nodoc
abstract mixin class $CreateMembershipStateCopyWith<$Res>  {
  factory $CreateMembershipStateCopyWith(CreateMembershipState value, $Res Function(CreateMembershipState) _then) = _$CreateMembershipStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Failure? failure, List<MembershipProduct> products, List<ProfileSummary> members, String? selectedMemberId, String? selectedProductId, DateTime? startDate, String? lockerNumber, bool autoRenew, bool submitting, String? fieldError, String? submitError, Membership? created
});




}
/// @nodoc
class _$CreateMembershipStateCopyWithImpl<$Res>
    implements $CreateMembershipStateCopyWith<$Res> {
  _$CreateMembershipStateCopyWithImpl(this._self, this._then);

  final CreateMembershipState _self;
  final $Res Function(CreateMembershipState) _then;

/// Create a copy of CreateMembershipState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failure = freezed,Object? products = null,Object? members = null,Object? selectedMemberId = freezed,Object? selectedProductId = freezed,Object? startDate = freezed,Object? lockerNumber = freezed,Object? autoRenew = null,Object? submitting = null,Object? fieldError = freezed,Object? submitError = freezed,Object? created = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<MembershipProduct>,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ProfileSummary>,selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,selectedProductId: freezed == selectedProductId ? _self.selectedProductId : selectedProductId // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lockerNumber: freezed == lockerNumber ? _self.lockerNumber : lockerNumber // ignore: cast_nullable_to_non_nullable
as String?,autoRenew: null == autoRenew ? _self.autoRenew : autoRenew // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,fieldError: freezed == fieldError ? _self.fieldError : fieldError // ignore: cast_nullable_to_non_nullable
as String?,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Membership?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateMembershipState].
extension CreateMembershipStatePatterns on CreateMembershipState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateMembershipState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateMembershipState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateMembershipState value)  $default,){
final _that = this;
switch (_that) {
case _CreateMembershipState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateMembershipState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateMembershipState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure,  List<MembershipProduct> products,  List<ProfileSummary> members,  String? selectedMemberId,  String? selectedProductId,  DateTime? startDate,  String? lockerNumber,  bool autoRenew,  bool submitting,  String? fieldError,  String? submitError,  Membership? created)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateMembershipState() when $default != null:
return $default(_that.status,_that.failure,_that.products,_that.members,_that.selectedMemberId,_that.selectedProductId,_that.startDate,_that.lockerNumber,_that.autoRenew,_that.submitting,_that.fieldError,_that.submitError,_that.created);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Failure? failure,  List<MembershipProduct> products,  List<ProfileSummary> members,  String? selectedMemberId,  String? selectedProductId,  DateTime? startDate,  String? lockerNumber,  bool autoRenew,  bool submitting,  String? fieldError,  String? submitError,  Membership? created)  $default,) {final _that = this;
switch (_that) {
case _CreateMembershipState():
return $default(_that.status,_that.failure,_that.products,_that.members,_that.selectedMemberId,_that.selectedProductId,_that.startDate,_that.lockerNumber,_that.autoRenew,_that.submitting,_that.fieldError,_that.submitError,_that.created);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Failure? failure,  List<MembershipProduct> products,  List<ProfileSummary> members,  String? selectedMemberId,  String? selectedProductId,  DateTime? startDate,  String? lockerNumber,  bool autoRenew,  bool submitting,  String? fieldError,  String? submitError,  Membership? created)?  $default,) {final _that = this;
switch (_that) {
case _CreateMembershipState() when $default != null:
return $default(_that.status,_that.failure,_that.products,_that.members,_that.selectedMemberId,_that.selectedProductId,_that.startDate,_that.lockerNumber,_that.autoRenew,_that.submitting,_that.fieldError,_that.submitError,_that.created);case _:
  return null;

}
}

}

/// @nodoc


class _CreateMembershipState implements CreateMembershipState {
  const _CreateMembershipState({this.status = LoadStatus.initial, this.failure, final  List<MembershipProduct> products = const <MembershipProduct>[], final  List<ProfileSummary> members = const <ProfileSummary>[], this.selectedMemberId, this.selectedProductId, this.startDate, this.lockerNumber, this.autoRenew = false, this.submitting = false, this.fieldError, this.submitError, this.created}): _products = products,_members = members;
  

@override@JsonKey() final  LoadStatus status;
@override final  Failure? failure;
 final  List<MembershipProduct> _products;
@override@JsonKey() List<MembershipProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<ProfileSummary> _members;
@override@JsonKey() List<ProfileSummary> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override final  String? selectedMemberId;
@override final  String? selectedProductId;
@override final  DateTime? startDate;
@override final  String? lockerNumber;
@override@JsonKey() final  bool autoRenew;
@override@JsonKey() final  bool submitting;
@override final  String? fieldError;
@override final  String? submitError;
@override final  Membership? created;

/// Create a copy of CreateMembershipState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateMembershipStateCopyWith<_CreateMembershipState> get copyWith => __$CreateMembershipStateCopyWithImpl<_CreateMembershipState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateMembershipState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&(identical(other.selectedProductId, selectedProductId) || other.selectedProductId == selectedProductId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.lockerNumber, lockerNumber) || other.lockerNumber == lockerNumber)&&(identical(other.autoRenew, autoRenew) || other.autoRenew == autoRenew)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.fieldError, fieldError) || other.fieldError == fieldError)&&(identical(other.submitError, submitError) || other.submitError == submitError)&&(identical(other.created, created) || other.created == created));
}


@override
int get hashCode => Object.hash(runtimeType,status,failure,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_members),selectedMemberId,selectedProductId,startDate,lockerNumber,autoRenew,submitting,fieldError,submitError,created);

@override
String toString() {
  return 'CreateMembershipState(status: $status, failure: $failure, products: $products, members: $members, selectedMemberId: $selectedMemberId, selectedProductId: $selectedProductId, startDate: $startDate, lockerNumber: $lockerNumber, autoRenew: $autoRenew, submitting: $submitting, fieldError: $fieldError, submitError: $submitError, created: $created)';
}


}

/// @nodoc
abstract mixin class _$CreateMembershipStateCopyWith<$Res> implements $CreateMembershipStateCopyWith<$Res> {
  factory _$CreateMembershipStateCopyWith(_CreateMembershipState value, $Res Function(_CreateMembershipState) _then) = __$CreateMembershipStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Failure? failure, List<MembershipProduct> products, List<ProfileSummary> members, String? selectedMemberId, String? selectedProductId, DateTime? startDate, String? lockerNumber, bool autoRenew, bool submitting, String? fieldError, String? submitError, Membership? created
});




}
/// @nodoc
class __$CreateMembershipStateCopyWithImpl<$Res>
    implements _$CreateMembershipStateCopyWith<$Res> {
  __$CreateMembershipStateCopyWithImpl(this._self, this._then);

  final _CreateMembershipState _self;
  final $Res Function(_CreateMembershipState) _then;

/// Create a copy of CreateMembershipState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failure = freezed,Object? products = null,Object? members = null,Object? selectedMemberId = freezed,Object? selectedProductId = freezed,Object? startDate = freezed,Object? lockerNumber = freezed,Object? autoRenew = null,Object? submitting = null,Object? fieldError = freezed,Object? submitError = freezed,Object? created = freezed,}) {
  return _then(_CreateMembershipState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<MembershipProduct>,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<ProfileSummary>,selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,selectedProductId: freezed == selectedProductId ? _self.selectedProductId : selectedProductId // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lockerNumber: freezed == lockerNumber ? _self.lockerNumber : lockerNumber // ignore: cast_nullable_to_non_nullable
as String?,autoRenew: null == autoRenew ? _self.autoRenew : autoRenew // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,fieldError: freezed == fieldError ? _self.fieldError : fieldError // ignore: cast_nullable_to_non_nullable
as String?,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as Membership?,
  ));
}


}

// dart format on
