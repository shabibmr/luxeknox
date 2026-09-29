// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_dossier_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberDossierState {

 LoadStatus get status; Person? get person; Membership? get membership; MemberPtSummary? get pt; bool get ptUnavailable; bool get renewingPt; int? get visitsThisMonth; bool get membershipsUnavailable; TrainerProfile? get assignedTrainer; ScheduleSession? get nextSchedule; bool get editingProfile; String? get message; Failure? get failure;
/// Create a copy of MemberDossierState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberDossierStateCopyWith<MemberDossierState> get copyWith => _$MemberDossierStateCopyWithImpl<MemberDossierState>(this as MemberDossierState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberDossierState&&(identical(other.status, status) || other.status == status)&&(identical(other.person, person) || other.person == person)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.pt, pt) || other.pt == pt)&&(identical(other.ptUnavailable, ptUnavailable) || other.ptUnavailable == ptUnavailable)&&(identical(other.renewingPt, renewingPt) || other.renewingPt == renewingPt)&&(identical(other.visitsThisMonth, visitsThisMonth) || other.visitsThisMonth == visitsThisMonth)&&(identical(other.membershipsUnavailable, membershipsUnavailable) || other.membershipsUnavailable == membershipsUnavailable)&&(identical(other.assignedTrainer, assignedTrainer) || other.assignedTrainer == assignedTrainer)&&(identical(other.nextSchedule, nextSchedule) || other.nextSchedule == nextSchedule)&&(identical(other.editingProfile, editingProfile) || other.editingProfile == editingProfile)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,person,membership,pt,ptUnavailable,renewingPt,visitsThisMonth,membershipsUnavailable,assignedTrainer,nextSchedule,editingProfile,message,failure);

@override
String toString() {
  return 'MemberDossierState(status: $status, person: $person, membership: $membership, pt: $pt, ptUnavailable: $ptUnavailable, renewingPt: $renewingPt, visitsThisMonth: $visitsThisMonth, membershipsUnavailable: $membershipsUnavailable, assignedTrainer: $assignedTrainer, nextSchedule: $nextSchedule, editingProfile: $editingProfile, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MemberDossierStateCopyWith<$Res>  {
  factory $MemberDossierStateCopyWith(MemberDossierState value, $Res Function(MemberDossierState) _then) = _$MemberDossierStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, Person? person, Membership? membership, MemberPtSummary? pt, bool ptUnavailable, bool renewingPt, int? visitsThisMonth, bool membershipsUnavailable, TrainerProfile? assignedTrainer, ScheduleSession? nextSchedule, bool editingProfile, String? message, Failure? failure
});




}
/// @nodoc
class _$MemberDossierStateCopyWithImpl<$Res>
    implements $MemberDossierStateCopyWith<$Res> {
  _$MemberDossierStateCopyWithImpl(this._self, this._then);

  final MemberDossierState _self;
  final $Res Function(MemberDossierState) _then;

/// Create a copy of MemberDossierState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? person = freezed,Object? membership = freezed,Object? pt = freezed,Object? ptUnavailable = null,Object? renewingPt = null,Object? visitsThisMonth = freezed,Object? membershipsUnavailable = null,Object? assignedTrainer = freezed,Object? nextSchedule = freezed,Object? editingProfile = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as MemberPtSummary?,ptUnavailable: null == ptUnavailable ? _self.ptUnavailable : ptUnavailable // ignore: cast_nullable_to_non_nullable
as bool,renewingPt: null == renewingPt ? _self.renewingPt : renewingPt // ignore: cast_nullable_to_non_nullable
as bool,visitsThisMonth: freezed == visitsThisMonth ? _self.visitsThisMonth : visitsThisMonth // ignore: cast_nullable_to_non_nullable
as int?,membershipsUnavailable: null == membershipsUnavailable ? _self.membershipsUnavailable : membershipsUnavailable // ignore: cast_nullable_to_non_nullable
as bool,assignedTrainer: freezed == assignedTrainer ? _self.assignedTrainer : assignedTrainer // ignore: cast_nullable_to_non_nullable
as TrainerProfile?,nextSchedule: freezed == nextSchedule ? _self.nextSchedule : nextSchedule // ignore: cast_nullable_to_non_nullable
as ScheduleSession?,editingProfile: null == editingProfile ? _self.editingProfile : editingProfile // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberDossierState].
extension MemberDossierStatePatterns on MemberDossierState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberDossierState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberDossierState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberDossierState value)  $default,){
final _that = this;
switch (_that) {
case _MemberDossierState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberDossierState value)?  $default,){
final _that = this;
switch (_that) {
case _MemberDossierState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  Person? person,  Membership? membership,  MemberPtSummary? pt,  bool ptUnavailable,  bool renewingPt,  int? visitsThisMonth,  bool membershipsUnavailable,  TrainerProfile? assignedTrainer,  ScheduleSession? nextSchedule,  bool editingProfile,  String? message,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberDossierState() when $default != null:
return $default(_that.status,_that.person,_that.membership,_that.pt,_that.ptUnavailable,_that.renewingPt,_that.visitsThisMonth,_that.membershipsUnavailable,_that.assignedTrainer,_that.nextSchedule,_that.editingProfile,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  Person? person,  Membership? membership,  MemberPtSummary? pt,  bool ptUnavailable,  bool renewingPt,  int? visitsThisMonth,  bool membershipsUnavailable,  TrainerProfile? assignedTrainer,  ScheduleSession? nextSchedule,  bool editingProfile,  String? message,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MemberDossierState():
return $default(_that.status,_that.person,_that.membership,_that.pt,_that.ptUnavailable,_that.renewingPt,_that.visitsThisMonth,_that.membershipsUnavailable,_that.assignedTrainer,_that.nextSchedule,_that.editingProfile,_that.message,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  Person? person,  Membership? membership,  MemberPtSummary? pt,  bool ptUnavailable,  bool renewingPt,  int? visitsThisMonth,  bool membershipsUnavailable,  TrainerProfile? assignedTrainer,  ScheduleSession? nextSchedule,  bool editingProfile,  String? message,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MemberDossierState() when $default != null:
return $default(_that.status,_that.person,_that.membership,_that.pt,_that.ptUnavailable,_that.renewingPt,_that.visitsThisMonth,_that.membershipsUnavailable,_that.assignedTrainer,_that.nextSchedule,_that.editingProfile,_that.message,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MemberDossierState implements MemberDossierState {
  const _MemberDossierState({this.status = LoadStatus.initial, this.person, this.membership, this.pt, this.ptUnavailable = false, this.renewingPt = false, this.visitsThisMonth, this.membershipsUnavailable = false, this.assignedTrainer, this.nextSchedule, this.editingProfile = false, this.message, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  Person? person;
@override final  Membership? membership;
@override final  MemberPtSummary? pt;
@override@JsonKey() final  bool ptUnavailable;
@override@JsonKey() final  bool renewingPt;
@override final  int? visitsThisMonth;
@override@JsonKey() final  bool membershipsUnavailable;
@override final  TrainerProfile? assignedTrainer;
@override final  ScheduleSession? nextSchedule;
@override@JsonKey() final  bool editingProfile;
@override final  String? message;
@override final  Failure? failure;

/// Create a copy of MemberDossierState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberDossierStateCopyWith<_MemberDossierState> get copyWith => __$MemberDossierStateCopyWithImpl<_MemberDossierState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberDossierState&&(identical(other.status, status) || other.status == status)&&(identical(other.person, person) || other.person == person)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.pt, pt) || other.pt == pt)&&(identical(other.ptUnavailable, ptUnavailable) || other.ptUnavailable == ptUnavailable)&&(identical(other.renewingPt, renewingPt) || other.renewingPt == renewingPt)&&(identical(other.visitsThisMonth, visitsThisMonth) || other.visitsThisMonth == visitsThisMonth)&&(identical(other.membershipsUnavailable, membershipsUnavailable) || other.membershipsUnavailable == membershipsUnavailable)&&(identical(other.assignedTrainer, assignedTrainer) || other.assignedTrainer == assignedTrainer)&&(identical(other.nextSchedule, nextSchedule) || other.nextSchedule == nextSchedule)&&(identical(other.editingProfile, editingProfile) || other.editingProfile == editingProfile)&&(identical(other.message, message) || other.message == message)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,person,membership,pt,ptUnavailable,renewingPt,visitsThisMonth,membershipsUnavailable,assignedTrainer,nextSchedule,editingProfile,message,failure);

@override
String toString() {
  return 'MemberDossierState(status: $status, person: $person, membership: $membership, pt: $pt, ptUnavailable: $ptUnavailable, renewingPt: $renewingPt, visitsThisMonth: $visitsThisMonth, membershipsUnavailable: $membershipsUnavailable, assignedTrainer: $assignedTrainer, nextSchedule: $nextSchedule, editingProfile: $editingProfile, message: $message, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MemberDossierStateCopyWith<$Res> implements $MemberDossierStateCopyWith<$Res> {
  factory _$MemberDossierStateCopyWith(_MemberDossierState value, $Res Function(_MemberDossierState) _then) = __$MemberDossierStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, Person? person, Membership? membership, MemberPtSummary? pt, bool ptUnavailable, bool renewingPt, int? visitsThisMonth, bool membershipsUnavailable, TrainerProfile? assignedTrainer, ScheduleSession? nextSchedule, bool editingProfile, String? message, Failure? failure
});




}
/// @nodoc
class __$MemberDossierStateCopyWithImpl<$Res>
    implements _$MemberDossierStateCopyWith<$Res> {
  __$MemberDossierStateCopyWithImpl(this._self, this._then);

  final _MemberDossierState _self;
  final $Res Function(_MemberDossierState) _then;

/// Create a copy of MemberDossierState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? person = freezed,Object? membership = freezed,Object? pt = freezed,Object? ptUnavailable = null,Object? renewingPt = null,Object? visitsThisMonth = freezed,Object? membershipsUnavailable = null,Object? assignedTrainer = freezed,Object? nextSchedule = freezed,Object? editingProfile = null,Object? message = freezed,Object? failure = freezed,}) {
  return _then(_MemberDossierState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,person: freezed == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as Person?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as MemberPtSummary?,ptUnavailable: null == ptUnavailable ? _self.ptUnavailable : ptUnavailable // ignore: cast_nullable_to_non_nullable
as bool,renewingPt: null == renewingPt ? _self.renewingPt : renewingPt // ignore: cast_nullable_to_non_nullable
as bool,visitsThisMonth: freezed == visitsThisMonth ? _self.visitsThisMonth : visitsThisMonth // ignore: cast_nullable_to_non_nullable
as int?,membershipsUnavailable: null == membershipsUnavailable ? _self.membershipsUnavailable : membershipsUnavailable // ignore: cast_nullable_to_non_nullable
as bool,assignedTrainer: freezed == assignedTrainer ? _self.assignedTrainer : assignedTrainer // ignore: cast_nullable_to_non_nullable
as TrainerProfile?,nextSchedule: freezed == nextSchedule ? _self.nextSchedule : nextSchedule // ignore: cast_nullable_to_non_nullable
as ScheduleSession?,editingProfile: null == editingProfile ? _self.editingProfile : editingProfile // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
