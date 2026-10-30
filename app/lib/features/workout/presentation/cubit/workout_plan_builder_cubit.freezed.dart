// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan_builder_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutPlanBuilderState {

 LoadStatus get status; String? get planId; int? get rowVersion; String get title; String get description; String get targetGoal; String get difficulty; int? get durationWeeks; bool get isTemplate; String get memberId; String get primaryObjective12w; String get milestone4w; int? get sessionsPerWeek; int? get targetSessionDurationMinutes; String get splitType; List<String> get progressionMethods;/// Set once the user tries to leave the Blueprint step, so errors only
/// appear after a first attempt.
 bool get showBlueprintErrors; List<WorkoutPlanExerciseInput> get exercises; bool get dirty; bool get saving;/// Local validation such as a missing title. API errors use [failure].
 String? get errorMessage; Failure? get failure; WorkoutPlan? get savedPlan;
/// Create a copy of WorkoutPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutPlanBuilderStateCopyWith<WorkoutPlanBuilderState> get copyWith => _$WorkoutPlanBuilderStateCopyWithImpl<WorkoutPlanBuilderState>(this as WorkoutPlanBuilderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutPlanBuilderState&&(identical(other.status, status) || other.status == status)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.rowVersion, rowVersion) || other.rowVersion == rowVersion)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetGoal, targetGoal) || other.targetGoal == targetGoal)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.durationWeeks, durationWeeks) || other.durationWeeks == durationWeeks)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.primaryObjective12w, primaryObjective12w) || other.primaryObjective12w == primaryObjective12w)&&(identical(other.milestone4w, milestone4w) || other.milestone4w == milestone4w)&&(identical(other.sessionsPerWeek, sessionsPerWeek) || other.sessionsPerWeek == sessionsPerWeek)&&(identical(other.targetSessionDurationMinutes, targetSessionDurationMinutes) || other.targetSessionDurationMinutes == targetSessionDurationMinutes)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&const DeepCollectionEquality().equals(other.progressionMethods, progressionMethods)&&(identical(other.showBlueprintErrors, showBlueprintErrors) || other.showBlueprintErrors == showBlueprintErrors)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.savedPlan, savedPlan) || other.savedPlan == savedPlan));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,planId,rowVersion,title,description,targetGoal,difficulty,durationWeeks,isTemplate,memberId,primaryObjective12w,milestone4w,sessionsPerWeek,targetSessionDurationMinutes,splitType,const DeepCollectionEquality().hash(progressionMethods),showBlueprintErrors,const DeepCollectionEquality().hash(exercises),dirty,saving,errorMessage,failure,savedPlan]);

@override
String toString() {
  return 'WorkoutPlanBuilderState(status: $status, planId: $planId, rowVersion: $rowVersion, title: $title, description: $description, targetGoal: $targetGoal, difficulty: $difficulty, durationWeeks: $durationWeeks, isTemplate: $isTemplate, memberId: $memberId, primaryObjective12w: $primaryObjective12w, milestone4w: $milestone4w, sessionsPerWeek: $sessionsPerWeek, targetSessionDurationMinutes: $targetSessionDurationMinutes, splitType: $splitType, progressionMethods: $progressionMethods, showBlueprintErrors: $showBlueprintErrors, exercises: $exercises, dirty: $dirty, saving: $saving, errorMessage: $errorMessage, failure: $failure, savedPlan: $savedPlan)';
}


}

/// @nodoc
abstract mixin class $WorkoutPlanBuilderStateCopyWith<$Res>  {
  factory $WorkoutPlanBuilderStateCopyWith(WorkoutPlanBuilderState value, $Res Function(WorkoutPlanBuilderState) _then) = _$WorkoutPlanBuilderStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, String? planId, int? rowVersion, String title, String description, String targetGoal, String difficulty, int? durationWeeks, bool isTemplate, String memberId, String primaryObjective12w, String milestone4w, int? sessionsPerWeek, int? targetSessionDurationMinutes, String splitType, List<String> progressionMethods, bool showBlueprintErrors, List<WorkoutPlanExerciseInput> exercises, bool dirty, bool saving, String? errorMessage, Failure? failure, WorkoutPlan? savedPlan
});




}
/// @nodoc
class _$WorkoutPlanBuilderStateCopyWithImpl<$Res>
    implements $WorkoutPlanBuilderStateCopyWith<$Res> {
  _$WorkoutPlanBuilderStateCopyWithImpl(this._self, this._then);

  final WorkoutPlanBuilderState _self;
  final $Res Function(WorkoutPlanBuilderState) _then;

/// Create a copy of WorkoutPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? planId = freezed,Object? rowVersion = freezed,Object? title = null,Object? description = null,Object? targetGoal = null,Object? difficulty = null,Object? durationWeeks = freezed,Object? isTemplate = null,Object? memberId = null,Object? primaryObjective12w = null,Object? milestone4w = null,Object? sessionsPerWeek = freezed,Object? targetSessionDurationMinutes = freezed,Object? splitType = null,Object? progressionMethods = null,Object? showBlueprintErrors = null,Object? exercises = null,Object? dirty = null,Object? saving = null,Object? errorMessage = freezed,Object? failure = freezed,Object? savedPlan = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,rowVersion: freezed == rowVersion ? _self.rowVersion : rowVersion // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,targetGoal: null == targetGoal ? _self.targetGoal : targetGoal // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,durationWeeks: freezed == durationWeeks ? _self.durationWeeks : durationWeeks // ignore: cast_nullable_to_non_nullable
as int?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,primaryObjective12w: null == primaryObjective12w ? _self.primaryObjective12w : primaryObjective12w // ignore: cast_nullable_to_non_nullable
as String,milestone4w: null == milestone4w ? _self.milestone4w : milestone4w // ignore: cast_nullable_to_non_nullable
as String,sessionsPerWeek: freezed == sessionsPerWeek ? _self.sessionsPerWeek : sessionsPerWeek // ignore: cast_nullable_to_non_nullable
as int?,targetSessionDurationMinutes: freezed == targetSessionDurationMinutes ? _self.targetSessionDurationMinutes : targetSessionDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as String,progressionMethods: null == progressionMethods ? _self.progressionMethods : progressionMethods // ignore: cast_nullable_to_non_nullable
as List<String>,showBlueprintErrors: null == showBlueprintErrors ? _self.showBlueprintErrors : showBlueprintErrors // ignore: cast_nullable_to_non_nullable
as bool,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutPlanExerciseInput>,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,savedPlan: freezed == savedPlan ? _self.savedPlan : savedPlan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutPlanBuilderState].
extension WorkoutPlanBuilderStatePatterns on WorkoutPlanBuilderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutPlanBuilderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutPlanBuilderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutPlanBuilderState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanBuilderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutPlanBuilderState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanBuilderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  String? planId,  int? rowVersion,  String title,  String description,  String targetGoal,  String difficulty,  int? durationWeeks,  bool isTemplate,  String memberId,  String primaryObjective12w,  String milestone4w,  int? sessionsPerWeek,  int? targetSessionDurationMinutes,  String splitType,  List<String> progressionMethods,  bool showBlueprintErrors,  List<WorkoutPlanExerciseInput> exercises,  bool dirty,  bool saving,  String? errorMessage,  Failure? failure,  WorkoutPlan? savedPlan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutPlanBuilderState() when $default != null:
return $default(_that.status,_that.planId,_that.rowVersion,_that.title,_that.description,_that.targetGoal,_that.difficulty,_that.durationWeeks,_that.isTemplate,_that.memberId,_that.primaryObjective12w,_that.milestone4w,_that.sessionsPerWeek,_that.targetSessionDurationMinutes,_that.splitType,_that.progressionMethods,_that.showBlueprintErrors,_that.exercises,_that.dirty,_that.saving,_that.errorMessage,_that.failure,_that.savedPlan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  String? planId,  int? rowVersion,  String title,  String description,  String targetGoal,  String difficulty,  int? durationWeeks,  bool isTemplate,  String memberId,  String primaryObjective12w,  String milestone4w,  int? sessionsPerWeek,  int? targetSessionDurationMinutes,  String splitType,  List<String> progressionMethods,  bool showBlueprintErrors,  List<WorkoutPlanExerciseInput> exercises,  bool dirty,  bool saving,  String? errorMessage,  Failure? failure,  WorkoutPlan? savedPlan)  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanBuilderState():
return $default(_that.status,_that.planId,_that.rowVersion,_that.title,_that.description,_that.targetGoal,_that.difficulty,_that.durationWeeks,_that.isTemplate,_that.memberId,_that.primaryObjective12w,_that.milestone4w,_that.sessionsPerWeek,_that.targetSessionDurationMinutes,_that.splitType,_that.progressionMethods,_that.showBlueprintErrors,_that.exercises,_that.dirty,_that.saving,_that.errorMessage,_that.failure,_that.savedPlan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  String? planId,  int? rowVersion,  String title,  String description,  String targetGoal,  String difficulty,  int? durationWeeks,  bool isTemplate,  String memberId,  String primaryObjective12w,  String milestone4w,  int? sessionsPerWeek,  int? targetSessionDurationMinutes,  String splitType,  List<String> progressionMethods,  bool showBlueprintErrors,  List<WorkoutPlanExerciseInput> exercises,  bool dirty,  bool saving,  String? errorMessage,  Failure? failure,  WorkoutPlan? savedPlan)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanBuilderState() when $default != null:
return $default(_that.status,_that.planId,_that.rowVersion,_that.title,_that.description,_that.targetGoal,_that.difficulty,_that.durationWeeks,_that.isTemplate,_that.memberId,_that.primaryObjective12w,_that.milestone4w,_that.sessionsPerWeek,_that.targetSessionDurationMinutes,_that.splitType,_that.progressionMethods,_that.showBlueprintErrors,_that.exercises,_that.dirty,_that.saving,_that.errorMessage,_that.failure,_that.savedPlan);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutPlanBuilderState extends WorkoutPlanBuilderState {
  const _WorkoutPlanBuilderState({this.status = LoadStatus.initial, this.planId, this.rowVersion, this.title = '', this.description = '', this.targetGoal = '', this.difficulty = '', this.durationWeeks, this.isTemplate = false, this.memberId = '', this.primaryObjective12w = '', this.milestone4w = '', this.sessionsPerWeek, this.targetSessionDurationMinutes, this.splitType = '', final  List<String> progressionMethods = const <String>[], this.showBlueprintErrors = false, final  List<WorkoutPlanExerciseInput> exercises = const <WorkoutPlanExerciseInput>[], this.dirty = false, this.saving = false, this.errorMessage, this.failure, this.savedPlan}): _progressionMethods = progressionMethods,_exercises = exercises,super._();
  

@override@JsonKey() final  LoadStatus status;
@override final  String? planId;
@override final  int? rowVersion;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String targetGoal;
@override@JsonKey() final  String difficulty;
@override final  int? durationWeeks;
@override@JsonKey() final  bool isTemplate;
@override@JsonKey() final  String memberId;
@override@JsonKey() final  String primaryObjective12w;
@override@JsonKey() final  String milestone4w;
@override final  int? sessionsPerWeek;
@override final  int? targetSessionDurationMinutes;
@override@JsonKey() final  String splitType;
 final  List<String> _progressionMethods;
@override@JsonKey() List<String> get progressionMethods {
  if (_progressionMethods is EqualUnmodifiableListView) return _progressionMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_progressionMethods);
}

/// Set once the user tries to leave the Blueprint step, so errors only
/// appear after a first attempt.
@override@JsonKey() final  bool showBlueprintErrors;
 final  List<WorkoutPlanExerciseInput> _exercises;
@override@JsonKey() List<WorkoutPlanExerciseInput> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  bool dirty;
@override@JsonKey() final  bool saving;
/// Local validation such as a missing title. API errors use [failure].
@override final  String? errorMessage;
@override final  Failure? failure;
@override final  WorkoutPlan? savedPlan;

/// Create a copy of WorkoutPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutPlanBuilderStateCopyWith<_WorkoutPlanBuilderState> get copyWith => __$WorkoutPlanBuilderStateCopyWithImpl<_WorkoutPlanBuilderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutPlanBuilderState&&(identical(other.status, status) || other.status == status)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.rowVersion, rowVersion) || other.rowVersion == rowVersion)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetGoal, targetGoal) || other.targetGoal == targetGoal)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.durationWeeks, durationWeeks) || other.durationWeeks == durationWeeks)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.primaryObjective12w, primaryObjective12w) || other.primaryObjective12w == primaryObjective12w)&&(identical(other.milestone4w, milestone4w) || other.milestone4w == milestone4w)&&(identical(other.sessionsPerWeek, sessionsPerWeek) || other.sessionsPerWeek == sessionsPerWeek)&&(identical(other.targetSessionDurationMinutes, targetSessionDurationMinutes) || other.targetSessionDurationMinutes == targetSessionDurationMinutes)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&const DeepCollectionEquality().equals(other._progressionMethods, _progressionMethods)&&(identical(other.showBlueprintErrors, showBlueprintErrors) || other.showBlueprintErrors == showBlueprintErrors)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.dirty, dirty) || other.dirty == dirty)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.savedPlan, savedPlan) || other.savedPlan == savedPlan));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,planId,rowVersion,title,description,targetGoal,difficulty,durationWeeks,isTemplate,memberId,primaryObjective12w,milestone4w,sessionsPerWeek,targetSessionDurationMinutes,splitType,const DeepCollectionEquality().hash(_progressionMethods),showBlueprintErrors,const DeepCollectionEquality().hash(_exercises),dirty,saving,errorMessage,failure,savedPlan]);

@override
String toString() {
  return 'WorkoutPlanBuilderState(status: $status, planId: $planId, rowVersion: $rowVersion, title: $title, description: $description, targetGoal: $targetGoal, difficulty: $difficulty, durationWeeks: $durationWeeks, isTemplate: $isTemplate, memberId: $memberId, primaryObjective12w: $primaryObjective12w, milestone4w: $milestone4w, sessionsPerWeek: $sessionsPerWeek, targetSessionDurationMinutes: $targetSessionDurationMinutes, splitType: $splitType, progressionMethods: $progressionMethods, showBlueprintErrors: $showBlueprintErrors, exercises: $exercises, dirty: $dirty, saving: $saving, errorMessage: $errorMessage, failure: $failure, savedPlan: $savedPlan)';
}


}

/// @nodoc
abstract mixin class _$WorkoutPlanBuilderStateCopyWith<$Res> implements $WorkoutPlanBuilderStateCopyWith<$Res> {
  factory _$WorkoutPlanBuilderStateCopyWith(_WorkoutPlanBuilderState value, $Res Function(_WorkoutPlanBuilderState) _then) = __$WorkoutPlanBuilderStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, String? planId, int? rowVersion, String title, String description, String targetGoal, String difficulty, int? durationWeeks, bool isTemplate, String memberId, String primaryObjective12w, String milestone4w, int? sessionsPerWeek, int? targetSessionDurationMinutes, String splitType, List<String> progressionMethods, bool showBlueprintErrors, List<WorkoutPlanExerciseInput> exercises, bool dirty, bool saving, String? errorMessage, Failure? failure, WorkoutPlan? savedPlan
});




}
/// @nodoc
class __$WorkoutPlanBuilderStateCopyWithImpl<$Res>
    implements _$WorkoutPlanBuilderStateCopyWith<$Res> {
  __$WorkoutPlanBuilderStateCopyWithImpl(this._self, this._then);

  final _WorkoutPlanBuilderState _self;
  final $Res Function(_WorkoutPlanBuilderState) _then;

/// Create a copy of WorkoutPlanBuilderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? planId = freezed,Object? rowVersion = freezed,Object? title = null,Object? description = null,Object? targetGoal = null,Object? difficulty = null,Object? durationWeeks = freezed,Object? isTemplate = null,Object? memberId = null,Object? primaryObjective12w = null,Object? milestone4w = null,Object? sessionsPerWeek = freezed,Object? targetSessionDurationMinutes = freezed,Object? splitType = null,Object? progressionMethods = null,Object? showBlueprintErrors = null,Object? exercises = null,Object? dirty = null,Object? saving = null,Object? errorMessage = freezed,Object? failure = freezed,Object? savedPlan = freezed,}) {
  return _then(_WorkoutPlanBuilderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,rowVersion: freezed == rowVersion ? _self.rowVersion : rowVersion // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,targetGoal: null == targetGoal ? _self.targetGoal : targetGoal // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,durationWeeks: freezed == durationWeeks ? _self.durationWeeks : durationWeeks // ignore: cast_nullable_to_non_nullable
as int?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,primaryObjective12w: null == primaryObjective12w ? _self.primaryObjective12w : primaryObjective12w // ignore: cast_nullable_to_non_nullable
as String,milestone4w: null == milestone4w ? _self.milestone4w : milestone4w // ignore: cast_nullable_to_non_nullable
as String,sessionsPerWeek: freezed == sessionsPerWeek ? _self.sessionsPerWeek : sessionsPerWeek // ignore: cast_nullable_to_non_nullable
as int?,targetSessionDurationMinutes: freezed == targetSessionDurationMinutes ? _self.targetSessionDurationMinutes : targetSessionDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as String,progressionMethods: null == progressionMethods ? _self._progressionMethods : progressionMethods // ignore: cast_nullable_to_non_nullable
as List<String>,showBlueprintErrors: null == showBlueprintErrors ? _self.showBlueprintErrors : showBlueprintErrors // ignore: cast_nullable_to_non_nullable
as bool,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<WorkoutPlanExerciseInput>,dirty: null == dirty ? _self.dirty : dirty // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,savedPlan: freezed == savedPlan ? _self.savedPlan : savedPlan // ignore: cast_nullable_to_non_nullable
as WorkoutPlan?,
  ));
}


}

// dart format on
