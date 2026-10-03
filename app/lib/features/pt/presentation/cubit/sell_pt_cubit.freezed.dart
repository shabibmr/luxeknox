// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sell_pt_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SellPtState {

 LoadStatus get status; int get memberId; String? get memberName; Person? get member;/// Set when re-planning (reassign trainer / change slot) an existing PT.
 PtSubscription? get replanning; List<PtProduct> get products; List<PaymentMethod> get paymentMethods; PtProduct? get product; DateTime? get startDate; List<int> get weekdays; LoadStatus get gridStatus; PtScheduleGrid? get grid; int? get trainerId; String? get slotStart; String? get paymentMethodId; String? get discount; String? get reason; bool get submitting; PtSubscription? get result; Failure? get failure;
/// Create a copy of SellPtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SellPtStateCopyWith<SellPtState> get copyWith => _$SellPtStateCopyWithImpl<SellPtState>(this as SellPtState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SellPtState&&(identical(other.status, status) || other.status == status)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.member, member) || other.member == member)&&(identical(other.replanning, replanning) || other.replanning == replanning)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.paymentMethods, paymentMethods)&&(identical(other.product, product) || other.product == product)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&const DeepCollectionEquality().equals(other.weekdays, weekdays)&&(identical(other.gridStatus, gridStatus) || other.gridStatus == gridStatus)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.slotStart, slotStart) || other.slotStart == slotStart)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.result, result) || other.result == result)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,memberId,memberName,member,replanning,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(paymentMethods),product,startDate,const DeepCollectionEquality().hash(weekdays),gridStatus,grid,trainerId,slotStart,paymentMethodId,discount,reason,submitting,result,failure]);

@override
String toString() {
  return 'SellPtState(status: $status, memberId: $memberId, memberName: $memberName, member: $member, replanning: $replanning, products: $products, paymentMethods: $paymentMethods, product: $product, startDate: $startDate, weekdays: $weekdays, gridStatus: $gridStatus, grid: $grid, trainerId: $trainerId, slotStart: $slotStart, paymentMethodId: $paymentMethodId, discount: $discount, reason: $reason, submitting: $submitting, result: $result, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SellPtStateCopyWith<$Res>  {
  factory $SellPtStateCopyWith(SellPtState value, $Res Function(SellPtState) _then) = _$SellPtStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, int memberId, String? memberName, Person? member, PtSubscription? replanning, List<PtProduct> products, List<PaymentMethod> paymentMethods, PtProduct? product, DateTime? startDate, List<int> weekdays, LoadStatus gridStatus, PtScheduleGrid? grid, int? trainerId, String? slotStart, String? paymentMethodId, String? discount, String? reason, bool submitting, PtSubscription? result, Failure? failure
});




}
/// @nodoc
class _$SellPtStateCopyWithImpl<$Res>
    implements $SellPtStateCopyWith<$Res> {
  _$SellPtStateCopyWithImpl(this._self, this._then);

  final SellPtState _self;
  final $Res Function(SellPtState) _then;

/// Create a copy of SellPtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? memberId = null,Object? memberName = freezed,Object? member = freezed,Object? replanning = freezed,Object? products = null,Object? paymentMethods = null,Object? product = freezed,Object? startDate = freezed,Object? weekdays = null,Object? gridStatus = null,Object? grid = freezed,Object? trainerId = freezed,Object? slotStart = freezed,Object? paymentMethodId = freezed,Object? discount = freezed,Object? reason = freezed,Object? submitting = null,Object? result = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as int,memberName: freezed == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String?,member: freezed == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as Person?,replanning: freezed == replanning ? _self.replanning : replanning // ignore: cast_nullable_to_non_nullable
as PtSubscription?,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<PtProduct>,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as PtProduct?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,gridStatus: null == gridStatus ? _self.gridStatus : gridStatus // ignore: cast_nullable_to_non_nullable
as LoadStatus,grid: freezed == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as PtScheduleGrid?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as int?,slotStart: freezed == slotStart ? _self.slotStart : slotStart // ignore: cast_nullable_to_non_nullable
as String?,paymentMethodId: freezed == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as PtSubscription?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SellPtState].
extension SellPtStatePatterns on SellPtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SellPtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SellPtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SellPtState value)  $default,){
final _that = this;
switch (_that) {
case _SellPtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SellPtState value)?  $default,){
final _that = this;
switch (_that) {
case _SellPtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  int memberId,  String? memberName,  Person? member,  PtSubscription? replanning,  List<PtProduct> products,  List<PaymentMethod> paymentMethods,  PtProduct? product,  DateTime? startDate,  List<int> weekdays,  LoadStatus gridStatus,  PtScheduleGrid? grid,  int? trainerId,  String? slotStart,  String? paymentMethodId,  String? discount,  String? reason,  bool submitting,  PtSubscription? result,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SellPtState() when $default != null:
return $default(_that.status,_that.memberId,_that.memberName,_that.member,_that.replanning,_that.products,_that.paymentMethods,_that.product,_that.startDate,_that.weekdays,_that.gridStatus,_that.grid,_that.trainerId,_that.slotStart,_that.paymentMethodId,_that.discount,_that.reason,_that.submitting,_that.result,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  int memberId,  String? memberName,  Person? member,  PtSubscription? replanning,  List<PtProduct> products,  List<PaymentMethod> paymentMethods,  PtProduct? product,  DateTime? startDate,  List<int> weekdays,  LoadStatus gridStatus,  PtScheduleGrid? grid,  int? trainerId,  String? slotStart,  String? paymentMethodId,  String? discount,  String? reason,  bool submitting,  PtSubscription? result,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SellPtState():
return $default(_that.status,_that.memberId,_that.memberName,_that.member,_that.replanning,_that.products,_that.paymentMethods,_that.product,_that.startDate,_that.weekdays,_that.gridStatus,_that.grid,_that.trainerId,_that.slotStart,_that.paymentMethodId,_that.discount,_that.reason,_that.submitting,_that.result,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  int memberId,  String? memberName,  Person? member,  PtSubscription? replanning,  List<PtProduct> products,  List<PaymentMethod> paymentMethods,  PtProduct? product,  DateTime? startDate,  List<int> weekdays,  LoadStatus gridStatus,  PtScheduleGrid? grid,  int? trainerId,  String? slotStart,  String? paymentMethodId,  String? discount,  String? reason,  bool submitting,  PtSubscription? result,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SellPtState() when $default != null:
return $default(_that.status,_that.memberId,_that.memberName,_that.member,_that.replanning,_that.products,_that.paymentMethods,_that.product,_that.startDate,_that.weekdays,_that.gridStatus,_that.grid,_that.trainerId,_that.slotStart,_that.paymentMethodId,_that.discount,_that.reason,_that.submitting,_that.result,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SellPtState extends SellPtState {
  const _SellPtState({this.status = LoadStatus.initial, required this.memberId, this.memberName, this.member, this.replanning, final  List<PtProduct> products = const <PtProduct>[], final  List<PaymentMethod> paymentMethods = const <PaymentMethod>[], this.product, this.startDate, final  List<int> weekdays = const <int>[], this.gridStatus = LoadStatus.initial, this.grid, this.trainerId, this.slotStart, this.paymentMethodId, this.discount, this.reason, this.submitting = false, this.result, this.failure}): _products = products,_paymentMethods = paymentMethods,_weekdays = weekdays,super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  int memberId;
@override final  String? memberName;
@override final  Person? member;
/// Set when re-planning (reassign trainer / change slot) an existing PT.
@override final  PtSubscription? replanning;
 final  List<PtProduct> _products;
@override@JsonKey() List<PtProduct> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<PaymentMethod> _paymentMethods;
@override@JsonKey() List<PaymentMethod> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}

@override final  PtProduct? product;
@override final  DateTime? startDate;
 final  List<int> _weekdays;
@override@JsonKey() List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

@override@JsonKey() final  LoadStatus gridStatus;
@override final  PtScheduleGrid? grid;
@override final  int? trainerId;
@override final  String? slotStart;
@override final  String? paymentMethodId;
@override final  String? discount;
@override final  String? reason;
@override@JsonKey() final  bool submitting;
@override final  PtSubscription? result;
@override final  Failure? failure;

/// Create a copy of SellPtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SellPtStateCopyWith<_SellPtState> get copyWith => __$SellPtStateCopyWithImpl<_SellPtState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SellPtState&&(identical(other.status, status) || other.status == status)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.member, member) || other.member == member)&&(identical(other.replanning, replanning) || other.replanning == replanning)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._paymentMethods, _paymentMethods)&&(identical(other.product, product) || other.product == product)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&const DeepCollectionEquality().equals(other._weekdays, _weekdays)&&(identical(other.gridStatus, gridStatus) || other.gridStatus == gridStatus)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.slotStart, slotStart) || other.slotStart == slotStart)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.result, result) || other.result == result)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,memberId,memberName,member,replanning,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_paymentMethods),product,startDate,const DeepCollectionEquality().hash(_weekdays),gridStatus,grid,trainerId,slotStart,paymentMethodId,discount,reason,submitting,result,failure]);

@override
String toString() {
  return 'SellPtState(status: $status, memberId: $memberId, memberName: $memberName, member: $member, replanning: $replanning, products: $products, paymentMethods: $paymentMethods, product: $product, startDate: $startDate, weekdays: $weekdays, gridStatus: $gridStatus, grid: $grid, trainerId: $trainerId, slotStart: $slotStart, paymentMethodId: $paymentMethodId, discount: $discount, reason: $reason, submitting: $submitting, result: $result, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SellPtStateCopyWith<$Res> implements $SellPtStateCopyWith<$Res> {
  factory _$SellPtStateCopyWith(_SellPtState value, $Res Function(_SellPtState) _then) = __$SellPtStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, int memberId, String? memberName, Person? member, PtSubscription? replanning, List<PtProduct> products, List<PaymentMethod> paymentMethods, PtProduct? product, DateTime? startDate, List<int> weekdays, LoadStatus gridStatus, PtScheduleGrid? grid, int? trainerId, String? slotStart, String? paymentMethodId, String? discount, String? reason, bool submitting, PtSubscription? result, Failure? failure
});




}
/// @nodoc
class __$SellPtStateCopyWithImpl<$Res>
    implements _$SellPtStateCopyWith<$Res> {
  __$SellPtStateCopyWithImpl(this._self, this._then);

  final _SellPtState _self;
  final $Res Function(_SellPtState) _then;

/// Create a copy of SellPtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? memberId = null,Object? memberName = freezed,Object? member = freezed,Object? replanning = freezed,Object? products = null,Object? paymentMethods = null,Object? product = freezed,Object? startDate = freezed,Object? weekdays = null,Object? gridStatus = null,Object? grid = freezed,Object? trainerId = freezed,Object? slotStart = freezed,Object? paymentMethodId = freezed,Object? discount = freezed,Object? reason = freezed,Object? submitting = null,Object? result = freezed,Object? failure = freezed,}) {
  return _then(_SellPtState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as int,memberName: freezed == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String?,member: freezed == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as Person?,replanning: freezed == replanning ? _self.replanning : replanning // ignore: cast_nullable_to_non_nullable
as PtSubscription?,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<PtProduct>,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as PtProduct?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,gridStatus: null == gridStatus ? _self.gridStatus : gridStatus // ignore: cast_nullable_to_non_nullable
as LoadStatus,grid: freezed == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as PtScheduleGrid?,trainerId: freezed == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as int?,slotStart: freezed == slotStart ? _self.slotStart : slotStart // ignore: cast_nullable_to_non_nullable
as String?,paymentMethodId: freezed == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as PtSubscription?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
