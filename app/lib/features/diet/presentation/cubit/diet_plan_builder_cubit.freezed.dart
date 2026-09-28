// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_plan_builder_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DietPlanBuilderState {

 LoadStatus get status; String? get planId; int? get rowVersion; String get title; int? get dailyCalorieTarget; num? get proteinTargetG; num? get carbsTargetG; num? get fatTargetG; bool get isTemplate; String get memberId; List<DietPlanMealInput> get meals; bool get dirty; bool get saving; String? get validationMessage; Failure? get failure; DietPlan? get savedPlan;
/// Create a copy of DietPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietPlanBuilderStateCopyWith<DietPlanBuilderState> get copyWith => _$DietPlanBuilderStateCopyWithImpl<DietPlanBuilderState>(this as DietPlanBuilderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietPlanBuilderState&&(identical(other.status, status) || other.status == status)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.rowVersion, rowVersion) || other.rowVersion == rowVersion)&&(identical(other.title, title) || other.title == title)&&(identical(other.dailyCalorieTarget, dailyCalorieTarget) || other.dailyCalorieTarget == dailyCalorieTarget)&&(identical(other.proteinTargetG, proteinTargetG) || other.proteinTargetG == proteinTargetG)&&(identical(other.carbsTargetG, carbsTargetG) || other.carbsTargetG == carbsTargetG)&&(identical(other.fatTargetG, fatTargetG) || other.fatTargetG == fatTargetG)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&const DeepCollectionEquality().equals(other.meals, meals)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.validationMessage, validationMessage) || other.validationMessage == validationMessage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.savedPlan, savedPlan) || other.savedPlan == savedPlan));
}


@override
int get hashCode => Object.hash(runtimeType,status,planId,rowVersion,title,dailyCalorieTarget,proteinTargetG,carbsTargetG,fatTargetG,isTemplate,memberId,const DeepCollectionEquality().hash(meals),dirty,saving,validationMessage,failure,savedPlan);

@override
String toString() {
  return 'DietPlanBuilderState(status: $status, planId: $planId, rowVersion: $rowVersion, title: $title, dailyCalorieTarget: $dailyCalorieTarget, proteinTargetG: $proteinTargetG, carbsTargetG: $carbsTargetG, fatTargetG: $fatTargetG, isTemplate: $isTemplate, memberId: $memberId, meals: $meals, dirty: $dirty, saving: $saving, validationMessage: $validationMessage, failure: $failure, savedPlan: $savedPlan)';
}


}

/// @nodoc
abstract mixin class $DietPlanBuilderStateCopyWith<$Res>  {
  factory $DietPlanBuilderStateCopyWith(DietPlanBuilderState value, $Res Function(DietPlanBuilderState) _then) = _$DietPlanBuilderStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, String? planId, int? rowVersion, String title, int? dailyCalorieTarget, num? proteinTargetG, num? carbsTargetG, num? fatTargetG, bool isTemplate, String memberId, List<DietPlanMealInput> meals, bool dirty, bool saving, String? validationMessage, Failure? failure, DietPlan? savedPlan
});




}
/// @nodoc
class _$DietPlanBuilderStateCopyWithImpl<$Res>
    implements $DietPlanBuilderStateCopyWith<$Res> {
  _$DietPlanBuilderStateCopyWithImpl(this._self, this._then);

  final DietPlanBuilderState _self;
  final $Res Function(DietPlanBuilderState) _then;

/// Create a copy of DietPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? planId = freezed,Object? rowVersion = freezed,Object? title = null,Object? dailyCalorieTarget = freezed,Object? proteinTargetG = freezed,Object? carbsTargetG = freezed,Object? fatTargetG = freezed,Object? isTemplate = null,Object? memberId = null,Object? meals = null,Object? dirty = null,Object? saving = null,Object? validationMessage = freezed,Object? failure = freezed,Object? savedPlan = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,rowVersion: freezed == rowVersion ? _self.rowVersion : rowVersion // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dailyCalorieTarget: freezed == dailyCalorieTarget ? _self.dailyCalorieTarget : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
as int?,proteinTargetG: freezed == proteinTargetG ? _self.proteinTargetG : proteinTargetG // ignore: cast_nullable_to_non_nullable
as num?,carbsTargetG: freezed == carbsTargetG ? _self.carbsTargetG : carbsTargetG // ignore: cast_nullable_to_non_nullable
as num?,fatTargetG: freezed == fatTargetG ? _self.fatTargetG : fatTargetG // ignore: cast_nullable_to_non_nullable
as num?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as List<DietPlanMealInput>,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,validationMessage: freezed == validationMessage ? _self.validationMessage : validationMessage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,savedPlan: freezed == savedPlan ? _self.savedPlan : savedPlan // ignore: cast_nullable_to_non_nullable
as DietPlan?,
  ));
}

}


/// Adds pattern-matching-related methods to [DietPlanBuilderState].
extension DietPlanBuilderStatePatterns on DietPlanBuilderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietPlanBuilderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietPlanBuilderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietPlanBuilderState value)  $default,){
final _that = this;
switch (_that) {
case _DietPlanBuilderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietPlanBuilderState value)?  $default,){
final _that = this;
switch (_that) {
case _DietPlanBuilderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  String? planId,  int? rowVersion,  String title,  int? dailyCalorieTarget,  num? proteinTargetG,  num? carbsTargetG,  num? fatTargetG,  bool isTemplate,  String memberId,  List<DietPlanMealInput> meals,  bool dirty,  bool saving,  String? validationMessage,  Failure? failure,  DietPlan? savedPlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietPlanBuilderState() when $default != null:
return $default(_that.status,_that.planId,_that.rowVersion,_that.title,_that.dailyCalorieTarget,_that.proteinTargetG,_that.carbsTargetG,_that.fatTargetG,_that.isTemplate,_that.memberId,_that.meals,_that.dirty,_that.saving,_that.validationMessage,_that.failure,_that.savedPlan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  String? planId,  int? rowVersion,  String title,  int? dailyCalorieTarget,  num? proteinTargetG,  num? carbsTargetG,  num? fatTargetG,  bool isTemplate,  String memberId,  List<DietPlanMealInput> meals,  bool dirty,  bool saving,  String? validationMessage,  Failure? failure,  DietPlan? savedPlan)  $default,) {final _that = this;
switch (_that) {
case _DietPlanBuilderState():
return $default(_that.status,_that.planId,_that.rowVersion,_that.title,_that.dailyCalorieTarget,_that.proteinTargetG,_that.carbsTargetG,_that.fatTargetG,_that.isTemplate,_that.memberId,_that.meals,_that.dirty,_that.saving,_that.validationMessage,_that.failure,_that.savedPlan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  String? planId,  int? rowVersion,  String title,  int? dailyCalorieTarget,  num? proteinTargetG,  num? carbsTargetG,  num? fatTargetG,  bool isTemplate,  String memberId,  List<DietPlanMealInput> meals,  bool dirty,  bool saving,  String? validationMessage,  Failure? failure,  DietPlan? savedPlan)?  $default,) {final _that = this;
switch (_that) {
case _DietPlanBuilderState() when $default != null:
return $default(_that.status,_that.planId,_that.rowVersion,_that.title,_that.dailyCalorieTarget,_that.proteinTargetG,_that.carbsTargetG,_that.fatTargetG,_that.isTemplate,_that.memberId,_that.meals,_that.dirty,_that.saving,_that.validationMessage,_that.failure,_that.savedPlan);case _:
  return null;

}
}

}

/// @nodoc


class _DietPlanBuilderState extends DietPlanBuilderState {
  const _DietPlanBuilderState({this.status = LoadStatus.initial, this.planId, this.rowVersion, this.title = '', this.dailyCalorieTarget, this.proteinTargetG, this.carbsTargetG, this.fatTargetG, this.isTemplate = false, this.memberId = '', final  List<DietPlanMealInput> meals = const <DietPlanMealInput>[], this.dirty = false, this.saving = false, this.validationMessage, this.failure, this.savedPlan}): _meals = meals,super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  String? planId;
@override final  int? rowVersion;
@override@JsonKey() final  String title;
@override final  int? dailyCalorieTarget;
@override final  num? proteinTargetG;
@override final  num? carbsTargetG;
@override final  num? fatTargetG;
@override@JsonKey() final  bool isTemplate;
@override@JsonKey() final  String memberId;
 final  List<DietPlanMealInput> _meals;
@override@JsonKey() List<DietPlanMealInput> get meals {
  if (_meals is EqualUnmodifiableListView) return _meals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meals);
}

@override@JsonKey() final  bool dirty;
@override@JsonKey() final  bool saving;
@override final  String? validationMessage;
@override final  Failure? failure;
@override final  DietPlan? savedPlan;

/// Create a copy of DietPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietPlanBuilderStateCopyWith<_DietPlanBuilderState> get copyWith => __$DietPlanBuilderStateCopyWithImpl<_DietPlanBuilderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietPlanBuilderState&&(identical(other.status, status) || other.status == status)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.rowVersion, rowVersion) || other.rowVersion == rowVersion)&&(identical(other.title, title) || other.title == title)&&(identical(other.dailyCalorieTarget, dailyCalorieTarget) || other.dailyCalorieTarget == dailyCalorieTarget)&&(identical(other.proteinTargetG, proteinTargetG) || other.proteinTargetG == proteinTargetG)&&(identical(other.carbsTargetG, carbsTargetG) || other.carbsTargetG == carbsTargetG)&&(identical(other.fatTargetG, fatTargetG) || other.fatTargetG == fatTargetG)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&const DeepCollectionEquality().equals(other._meals, _meals)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.validationMessage, validationMessage) || other.validationMessage == validationMessage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.savedPlan, savedPlan) || other.savedPlan == savedPlan));
}


@override
int get hashCode => Object.hash(runtimeType,status,planId,rowVersion,title,dailyCalorieTarget,proteinTargetG,carbsTargetG,fatTargetG,isTemplate,memberId,const DeepCollectionEquality().hash(_meals),dirty,saving,validationMessage,failure,savedPlan);

@override
String toString() {
  return 'DietPlanBuilderState(status: $status, planId: $planId, rowVersion: $rowVersion, title: $title, dailyCalorieTarget: $dailyCalorieTarget, proteinTargetG: $proteinTargetG, carbsTargetG: $carbsTargetG, fatTargetG: $fatTargetG, isTemplate: $isTemplate, memberId: $memberId, meals: $meals, dirty: $dirty, saving: $saving, validationMessage: $validationMessage, failure: $failure, savedPlan: $savedPlan)';
}


}

/// @nodoc
abstract mixin class _$DietPlanBuilderStateCopyWith<$Res> implements $DietPlanBuilderStateCopyWith<$Res> {
  factory _$DietPlanBuilderStateCopyWith(_DietPlanBuilderState value, $Res Function(_DietPlanBuilderState) _then) = __$DietPlanBuilderStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, String? planId, int? rowVersion, String title, int? dailyCalorieTarget, num? proteinTargetG, num? carbsTargetG, num? fatTargetG, bool isTemplate, String memberId, List<DietPlanMealInput> meals, bool dirty, bool saving, String? validationMessage, Failure? failure, DietPlan? savedPlan
});




}
/// @nodoc
class __$DietPlanBuilderStateCopyWithImpl<$Res>
    implements _$DietPlanBuilderStateCopyWith<$Res> {
  __$DietPlanBuilderStateCopyWithImpl(this._self, this._then);

  final _DietPlanBuilderState _self;
  final $Res Function(_DietPlanBuilderState) _then;

/// Create a copy of DietPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? planId = freezed,Object? rowVersion = freezed,Object? title = null,Object? dailyCalorieTarget = freezed,Object? proteinTargetG = freezed,Object? carbsTargetG = freezed,Object? fatTargetG = freezed,Object? isTemplate = null,Object? memberId = null,Object? meals = null,Object? dirty = null,Object? saving = null,Object? validationMessage = freezed,Object? failure = freezed,Object? savedPlan = freezed,}) {
  return _then(_DietPlanBuilderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,rowVersion: freezed == rowVersion ? _self.rowVersion : rowVersion // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dailyCalorieTarget: freezed == dailyCalorieTarget ? _self.dailyCalorieTarget : dailyCalorieTarget // ignore: cast_nullable_to_non_nullable
as int?,proteinTargetG: freezed == proteinTargetG ? _self.proteinTargetG : proteinTargetG // ignore: cast_nullable_to_non_nullable
as num?,carbsTargetG: freezed == carbsTargetG ? _self.carbsTargetG : carbsTargetG // ignore: cast_nullable_to_non_nullable
as num?,fatTargetG: freezed == fatTargetG ? _self.fatTargetG : fatTargetG // ignore: cast_nullable_to_non_nullable
as num?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,meals: null == meals ? _self._meals : meals // ignore: cast_nullable_to_non_nullable
as List<DietPlanMealInput>,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,validationMessage: freezed == validationMessage ? _self.validationMessage : validationMessage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,savedPlan: freezed == savedPlan ? _self.savedPlan : savedPlan // ignore: cast_nullable_to_non_nullable
as DietPlan?,
  ));
}


}

// dart format on
