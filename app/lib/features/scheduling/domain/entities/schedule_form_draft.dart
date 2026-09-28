import 'package:equatable/equatable.dart';

import '../../../people/domain/entities/trainer_summary.dart';
import '../repositories/scheduling_repository.dart';
import 'schedule_catalog.dart';

/// Field-level validation errors for [ScheduleFormDraft], keyed by field
/// name. Empty when the draft is valid.
typedef ScheduleFormErrors = Map<String, String>;

/// Mutable-by-copy draft backing the (future) admin create/edit schedule
/// form (M4), assembled from the F2 picker/date-range field widgets.
class ScheduleFormDraft extends Equatable {
  const ScheduleFormDraft({
    this.scheduleType,
    this.facility,
    this.trainer,
    this.title = '',
    this.start,
    this.end,
    this.maxCapacity,
    this.notes,
    this.recurUntil,
  });

  final ScheduleTypeInfo? scheduleType;
  final FacilityInfo? facility;
  final TrainerSummary? trainer;
  final String title;
  final DateTime? start;
  final DateTime? end;
  final int? maxCapacity;
  final String? notes;
  final DateTime? recurUntil;

  ScheduleFormDraft copyWith({
    ScheduleTypeInfo? scheduleType,
    bool clearScheduleType = false,
    FacilityInfo? facility,
    bool clearFacility = false,
    TrainerSummary? trainer,
    bool clearTrainer = false,
    String? title,
    DateTime? start,
    DateTime? end,
    int? maxCapacity,
    bool clearMaxCapacity = false,
    String? notes,
    bool clearNotes = false,
    DateTime? recurUntil,
    bool clearRecurUntil = false,
  }) {
    return ScheduleFormDraft(
      scheduleType: clearScheduleType
          ? null
          : (scheduleType ?? this.scheduleType),
      facility: clearFacility ? null : (facility ?? this.facility),
      trainer: clearTrainer ? null : (trainer ?? this.trainer),
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      maxCapacity: clearMaxCapacity ? null : (maxCapacity ?? this.maxCapacity),
      notes: clearNotes ? null : (notes ?? this.notes),
      recurUntil: clearRecurUntil ? null : (recurUntil ?? this.recurUntil),
    );
  }

  static const _requiredError = 'Required';
  static const _endBeforeStartError = 'End time must be after start time.';
  static const _capacityInvalidError = 'Capacity must be greater than 0.';
  static const _recurUntilBeforeStartError =
      'Repeat until date must be on or after start date.';

  /// Field-level validation errors. A trainer is only required when the
  /// selected [scheduleType] has `requiresTrainer == true`.
  ScheduleFormErrors validate() {
    final errors = <String, String>{};

    if (scheduleType == null) {
      errors['scheduleType'] = _requiredError;
    }
    if (title.trim().isEmpty) {
      errors['title'] = _requiredError;
    }
    if (start == null) {
      errors['start'] = _requiredError;
    }
    if (end == null) {
      errors['end'] = _requiredError;
    } else if (start != null && !end!.isAfter(start!)) {
      errors['end'] = _endBeforeStartError;
    }
    if (scheduleType?.requiresTrainer == true && trainer == null) {
      errors['trainer'] = _requiredError;
    }
    if (maxCapacity != null && maxCapacity! <= 0) {
      errors['maxCapacity'] = _capacityInvalidError;
    }
    if (recurUntil != null && start != null) {
      final startDateOnly = DateTime(start!.year, start!.month, start!.day);
      final recurDateOnly =
          DateTime(recurUntil!.year, recurUntil!.month, recurUntil!.day);
      if (recurDateOnly.isBefore(startDateOnly)) {
        errors['recurUntil'] = _recurUntilBeforeStartError;
      }
    }

    return errors;
  }

  bool get isValid => validate().isEmpty;

  /// Maps this draft onto the repository's write DTO. Caller supplies the
  /// fields the draft doesn't own (idempotency key, series linkage, the
  /// current `rowVersion` on edit).
  CreateScheduleInput toCreateInput({
    String? idempotencyKey,
    String? seriesId,
    DateTime? recurUntil,
    int? rowVersion,
  }) {
    return CreateScheduleInput(
      seriesId: seriesId,
      scheduleTypeId: scheduleType?.id,
      facilityId: facility?.id,
      trainerId: trainer?.id.toString(),
      title: title.trim(),
      startTime: start,
      endTime: end,
      maxCapacity: maxCapacity,
      notes: notes,
      rowVersion: rowVersion,
      recurUntil: recurUntil ?? this.recurUntil,
      idempotencyKey: idempotencyKey,
    );
  }

  @override
  List<Object?> get props => [
    scheduleType,
    facility,
    trainer,
    title,
    start,
    end,
    maxCapacity,
    notes,
    recurUntil,
  ];
}
