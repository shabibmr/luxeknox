import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';

import '../../domain/entities/goal_history.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/entities/goal_status.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/entities/photo_pose.dart';
import '../../domain/entities/progress_note.dart';
import '../../domain/entities/progress_note_type.dart';
import '../../domain/entities/progress_photo.dart';

GoalMetricCategory goalMetricCategoryToDomain(Object category) {
  final name = category is Enum ? category.name : category.toString();
  return GoalMetricCategory.fromWire(name);
}

GoalStatus goalStatusToDomain(Object status) {
  final name = status is Enum ? status.name : status.toString();
  return GoalStatus.fromWire(name);
}

PhotoPose photoPoseToDomain(Object pose) {
  final name = pose is Enum ? pose.name : pose.toString();
  return PhotoPose.fromWire(name);
}

ProgressNoteType progressNoteTypeToDomain(Object type) {
  final name = type is Enum ? type.name : type.toString();
  return ProgressNoteType.fromWire(name);
}

extension GoalMetricModelMapper on api.GoalMetric {
  GoalMetric toDomain() {
    return GoalMetric(
      id: id.toString(),
      name: name,
      unitOfMeasure: unitOfMeasure,
      category: goalMetricCategoryToDomain(category),
      isActive: isActive,
    );
  }
}

extension GoalModelMapper on api.Goal {
  MemberGoal toDomain() {
    return MemberGoal(
      id: id.toString(),
      memberId: memberId.toString(),
      metricId: metricId.toString(),
      baselineValue: baselineValue,
      targetValue: targetValue,
      currentValue: currentValue,
      startDate: startDate?.toDateTime(),
      targetDate: targetDate?.toDateTime(),
      status: goalStatusToDomain(status),
      metric: metric?.toDomain(),
    );
  }
}

extension GoalHistoryModelMapper on api.GoalHistory {
  GoalHistoryEntry toDomain() {
    return GoalHistoryEntry(
      id: id.toString(),
      goalId: goalId.toString(),
      recordedValue: recordedValue,
      recordedDate: recordedDate.toDateTime(),
      notes: notes,
    );
  }
}

extension MeasurementValueModelMapper on api.MeasurementValue {
  MeasurementValueEntry toDomain() {
    return MeasurementValueEntry(
      id: id?.toString(),
      measurementId: measurementId?.toString(),
      metricId: metricId.toString(),
      value: value,
    );
  }
}

extension MeasurementModelMapper on api.Measurement {
  MeasurementSession toDomain() {
    return MeasurementSession(
      id: id.toString(),
      memberId: memberId.toString(),
      recordedByUserId: recordedByUserId?.toString(),
      recordedAt: recordedAt,
      notes: notes,
      values: (values ?? BuiltList()).map((v) => v.toDomain()).toList(),
    );
  }
}

extension ProgressPhotoModelMapper on api.ProgressPhoto {
  ProgressPhoto toDomain() {
    return ProgressPhoto(
      id: id.toString(),
      memberId: memberId.toString(),
      photoUrl: photoUrl,
      pose: photoPoseToDomain(pose),
      takenDate: takenDate?.toDateTime(),
      isPrivate: isPrivate ?? false,
    );
  }
}

extension ProgressNoteModelMapper on api.ProgressNote {
  ProgressNote toDomain() {
    return ProgressNote(
      id: id.toString(),
      memberId: memberId.toString(),
      authorUserId: authorUserId.toString(),
      noteText: noteText,
      noteType: progressNoteTypeToDomain(noteType),
      createdAt: createdAt,
    );
  }
}

api.GoalMetricWriteCategoryEnum toApiMetricCategory(GoalMetricCategory c) {
  return switch (c) {
    GoalMetricCategory.bodyComposition =>
      api.GoalMetricWriteCategoryEnum.bodyComposition,
    GoalMetricCategory.circumference =>
      api.GoalMetricWriteCategoryEnum.circumference,
    GoalMetricCategory.strength => api.GoalMetricWriteCategoryEnum.strength,
  };
}

api.GoalWriteStatusEnum? toApiGoalWriteStatus(GoalStatus? s) {
  if (s == null) return null;
  return switch (s) {
    GoalStatus.inProgress => api.GoalWriteStatusEnum.inProgress,
    GoalStatus.achieved => api.GoalWriteStatusEnum.achieved,
    GoalStatus.abandoned => api.GoalWriteStatusEnum.abandoned,
  };
}

api.ProgressPhotoWritePoseEnum toApiPhotoPose(PhotoPose pose) {
  return switch (pose) {
    PhotoPose.front => api.ProgressPhotoWritePoseEnum.front,
    PhotoPose.side => api.ProgressPhotoWritePoseEnum.side,
    PhotoPose.back => api.ProgressPhotoWritePoseEnum.back,
  };
}

api.ProgressNoteWriteNoteTypeEnum toApiNoteType(ProgressNoteType type) {
  return switch (type) {
    ProgressNoteType.memberNote =>
      api.ProgressNoteWriteNoteTypeEnum.memberNote,
    ProgressNoteType.trainerAssessment =>
      api.ProgressNoteWriteNoteTypeEnum.trainerAssessment,
  };
}

api.GoalMetricWrite toGoalMetricWrite({
  required String name,
  required String unitOfMeasure,
  required GoalMetricCategory category,
  bool? isActive,
}) {
  return api.GoalMetricWrite(
    (b) => b
      ..name = name
      ..unitOfMeasure = unitOfMeasure
      ..category = toApiMetricCategory(category)
      ..isActive = isActive,
  );
}

api.GoalWrite toGoalWrite({
  String? metricId,
  num? baselineValue,
  num? targetValue,
  DateTime? startDate,
  DateTime? targetDate,
  GoalStatus? status,
}) {
  return api.GoalWrite(
    (b) => b
      ..metricId = metricId == null ? null : int.tryParse(metricId)
      ..baselineValue = baselineValue
      ..targetValue = targetValue
      ..startDate = startDate?.toDate()
      ..targetDate = targetDate?.toDate()
      ..status = toApiGoalWriteStatus(status),
  );
}

api.GoalCheckInWrite toGoalCheckInWrite({
  required num recordedValue,
  DateTime? recordedDate,
  String? notes,
}) {
  return api.GoalCheckInWrite(
    (b) => b
      ..recordedValue = recordedValue
      ..recordedDate = recordedDate?.toDate()
      ..notes = notes,
  );
}

api.MeasurementWrite toMeasurementWrite({
  DateTime? recordedAt,
  String? notes,
  required List<MeasurementValueEntry> values,
}) {
  return api.MeasurementWrite(
    (b) => b
      ..recordedAt = recordedAt
      ..notes = notes
      ..values.replace(
        values.map(
          (v) => api.MeasurementValue(
            (mb) => mb
              ..metricId = int.parse(v.metricId)
              ..value = v.value
              ..id = v.id == null ? null : int.tryParse(v.id!)
              ..measurementId =
                  v.measurementId == null ? null : int.tryParse(v.measurementId!),
          ),
        ),
      ),
  );
}

api.ProgressPhotoWrite toProgressPhotoWrite({
  required String photoUrl,
  required PhotoPose pose,
  DateTime? takenDate,
  bool? isPrivate,
}) {
  return api.ProgressPhotoWrite(
    (b) => b
      ..photoUrl = photoUrl
      ..pose = toApiPhotoPose(pose)
      ..takenDate = takenDate?.toDate()
      ..isPrivate = isPrivate,
  );
}

api.ProgressNoteWrite toProgressNoteWrite({
  required String noteText,
  required ProgressNoteType noteType,
}) {
  return api.ProgressNoteWrite(
    (b) => b
      ..noteText = noteText
      ..noteType = toApiNoteType(noteType),
  );
}
