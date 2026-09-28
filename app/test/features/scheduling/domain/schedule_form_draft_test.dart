import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_catalog.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_form_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const scheduleType = ScheduleTypeInfo(
    id: 'st1',
    name: 'Yoga',
    requiresTrainer: false,
  );
  const ptScheduleType = ScheduleTypeInfo(
    id: 'st2',
    name: 'Personal training',
    requiresTrainer: true,
  );
  const trainer = TrainerSummary(id: 1, userId: 10, fullName: 'Alex Trainer');

  final start = DateTime(2026, 1, 1, 9);
  final end = DateTime(2026, 1, 1, 10);

  group('validate', () {
    test('empty draft reports all required fields', () {
      const draft = ScheduleFormDraft();
      final errors = draft.validate();
      expect(errors['scheduleType'], isNotNull);
      expect(errors['title'], isNotNull);
      expect(errors['start'], isNotNull);
      expect(errors['end'], isNotNull);
      expect(draft.isValid, isFalse);
    });

    test('valid draft has no errors', () {
      final draft = ScheduleFormDraft(
        scheduleType: scheduleType,
        title: 'Morning yoga',
        start: start,
        end: end,
      );
      expect(draft.validate(), isEmpty);
      expect(draft.isValid, isTrue);
    });

    test('end must be after start', () {
      final draft = ScheduleFormDraft(
        scheduleType: scheduleType,
        title: 'Morning yoga',
        start: end,
        end: start,
      );
      expect(draft.validate()['end'], contains('after'));
    });

    test('trainer required when schedule type requires one', () {
      final draft = ScheduleFormDraft(
        scheduleType: ptScheduleType,
        title: '1:1 PT',
        start: start,
        end: end,
      );
      expect(draft.validate()['trainer'], isNotNull);

      final withTrainer = draft.copyWith(trainer: trainer);
      expect(withTrainer.validate(), isEmpty);
    });

    test('capacity must be greater than 0 when provided', () {
      final draft = ScheduleFormDraft(
        scheduleType: scheduleType,
        title: 'Morning yoga',
        start: start,
        end: end,
        maxCapacity: 0,
      );
      expect(draft.validate()['maxCapacity'], isNotNull);

      final positive = draft.copyWith(maxCapacity: 10);
      expect(positive.validate(), isEmpty);
    });

    test('recurUntil must be on or after start date', () {
      final draft = ScheduleFormDraft(
        scheduleType: scheduleType,
        title: 'Morning yoga',
        start: DateTime(2026, 5, 10, 9),
        end: DateTime(2026, 5, 10, 10),
        recurUntil: DateTime(2026, 5, 9),
      );
      expect(draft.validate()['recurUntil'], isNotNull);

      final validRecur = draft.copyWith(recurUntil: DateTime(2026, 5, 10));
      expect(validRecur.validate(), isEmpty);

      final futureRecur = draft.copyWith(recurUntil: DateTime(2026, 6, 1));
      expect(futureRecur.validate(), isEmpty);
    });
  });

  group('toCreateInput', () {
    test('maps fields including caller-supplied metadata and recurUntil', () {
      final draft = ScheduleFormDraft(
        scheduleType: ptScheduleType,
        trainer: trainer,
        title: '  1:1 PT  ',
        start: start,
        end: end,
        maxCapacity: 1,
        notes: 'Bring water',
        recurUntil: DateTime(2026, 3, 1),
      );
      final input = draft.toCreateInput(
        idempotencyKey: 'idem-1',
        rowVersion: 3,
      );

      expect(input.scheduleTypeId, ptScheduleType.id);
      expect(input.trainerId, trainer.id.toString());
      expect(input.title, '1:1 PT');
      expect(input.startTime, start);
      expect(input.endTime, end);
      expect(input.maxCapacity, 1);
      expect(input.notes, 'Bring water');
      expect(input.recurUntil, DateTime(2026, 3, 1));
      expect(input.idempotencyKey, 'idem-1');
      expect(input.rowVersion, 3);
    });
  });

  group('copyWith', () {
    test('clear flags null out optional fields', () {
      final draft = ScheduleFormDraft(
        scheduleType: scheduleType,
        facility: const FacilityInfo(id: 'f1', name: 'Main hall', isActive: true),
        trainer: trainer,
        maxCapacity: 5,
        notes: 'note',
        recurUntil: DateTime(2026, 3, 1),
      );

      final cleared = draft.copyWith(
        clearScheduleType: true,
        clearFacility: true,
        clearTrainer: true,
        clearMaxCapacity: true,
        clearNotes: true,
        clearRecurUntil: true,
      );

      expect(cleared.scheduleType, isNull);
      expect(cleared.facility, isNull);
      expect(cleared.trainer, isNull);
      expect(cleared.maxCapacity, isNull);
      expect(cleared.notes, isNull);
      expect(cleared.recurUntil, isNull);
    });
  });
}
