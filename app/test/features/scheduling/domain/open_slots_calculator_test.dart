import 'package:luxeknox/features/scheduling/domain/entities/open_slot.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_catalog.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/open_slots_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpenSlotsCalculator', () {
    test('parses HH:MM:SS time strings', () {
      expect(OpenSlotsCalculator.parseTimeToMinutes('06:00:00'), 360);
      expect(OpenSlotsCalculator.parseTimeToMinutes('09:30'), 570);
    });

    test('builds recurring availability for a weekday', () {
      // 2026-09-21 is a Monday → dayOfWeek Sunday0 = 1
      final windows = OpenSlotsCalculator.buildDayAvailabilityWindows(
        dateIso: '2026-09-21',
        availability: const [
          TrainerAvailabilitySlot(
            id: '1',
            trainerId: '3',
            dayOfWeek: 1,
            startTime: '09:00:00',
            endTime: '12:00:00',
            isRecurring: true,
            isAvailable: true,
          ),
        ],
      );

      expect(windows, hasLength(1));
      expect(windows.first.start, DateTime(2026, 9, 21, 9));
      expect(windows.first.end, DateTime(2026, 9, 21, 12));
    });

    test('applies date overrides before recurring windows', () {
      final windows = OpenSlotsCalculator.buildDayAvailabilityWindows(
        dateIso: '2026-09-21',
        availability: [
          const TrainerAvailabilitySlot(
            id: '1',
            trainerId: '3',
            dayOfWeek: 1,
            startTime: '09:00:00',
            endTime: '17:00:00',
            isRecurring: true,
            isAvailable: true,
          ),
          TrainerAvailabilitySlot(
            id: '2',
            trainerId: '3',
            startTime: '10:00:00',
            endTime: '11:00:00',
            isRecurring: false,
            overrideDate: DateTime(2026, 9, 21),
            isAvailable: false,
          ),
        ],
      );

      expect(windows, hasLength(2));
      expect(windows[0].end, DateTime(2026, 9, 21, 10));
      expect(windows[1].start, DateTime(2026, 9, 21, 11));
    });

    test('subtracts busy intervals from availability', () {
      final open = OpenSlotsCalculator.subtractBusyIntervals(
        [
          OpenSlot(
            start: DateTime(2026, 9, 21, 9),
            end: DateTime(2026, 9, 21, 12),
          ),
        ],
        [
          OpenSlot(
            start: DateTime(2026, 9, 21, 10),
            end: DateTime(2026, 9, 21, 10, 30),
          ),
        ],
      );

      expect(open, hasLength(2));
      expect(open[0].end, DateTime(2026, 9, 21, 10));
      expect(open[1].start, DateTime(2026, 9, 21, 10, 30));
    });

    test('computes bookable slots from availability minus busy blocks', () {
      final slots = OpenSlotsCalculator.computeOpenSlots(
        dateIso: '2026-09-21',
        availability: const [
          TrainerAvailabilitySlot(
            id: '1',
            trainerId: '3',
            dayOfWeek: 1,
            startTime: '09:00:00',
            endTime: '11:00:00',
            isRecurring: true,
            isAvailable: true,
          ),
        ],
        busy: [
          OpenSlot(
            start: DateTime(2026, 9, 21, 9),
            end: DateTime(2026, 9, 21, 9, 30),
          ),
        ],
        slotDurationMinutes: 60,
      );

      expect(slots, hasLength(1));
      expect(slots.first.start, DateTime(2026, 9, 21, 9, 30));
      expect(slots.first.end, DateTime(2026, 9, 21, 10, 30));
    });

    test('matchBookableSessions keeps empty PT seats inside availability', () {
      final availability = const [
        TrainerAvailabilitySlot(
          id: '1',
          trainerId: '3',
          dayOfWeek: 1,
          startTime: '09:00:00',
          endTime: '12:00:00',
          isRecurring: true,
          isAvailable: true,
        ),
      ];
      final openSession = ScheduleSession(
        id: '10',
        scheduleTypeId: '1',
        trainerId: '3',
        title: 'PT',
        startTime: DateTime(2026, 9, 21, 9),
        endTime: DateTime(2026, 9, 21, 10),
        maxCapacity: 1,
        status: ScheduleSessionStatus.scheduled,
        rowVersion: 1,
      );
      final fullSession = ScheduleSession(
        id: '11',
        scheduleTypeId: '1',
        trainerId: '3',
        title: 'PT full',
        startTime: DateTime(2026, 9, 21, 10),
        endTime: DateTime(2026, 9, 21, 11),
        maxCapacity: 1,
        status: ScheduleSessionStatus.scheduled,
        rowVersion: 1,
        participants: const [
          ScheduleParticipantEntry(
            id: 'p1',
            scheduleId: '11',
            memberId: '5',
            bookingStatus: BookingStatus.booked,
          ),
        ],
      );

      final matched = OpenSlotsCalculator.matchBookableSessions(
        availability: availability,
        sessions: [openSession, fullSession],
        trainerId: '3',
      );

      expect(matched, hasLength(1));
      expect(matched.first.scheduleId, '10');
    });

    test('matchSessionsToComputedSlots requires exact start/end', () {
      final openSlots = [
        OpenSlot(
          start: DateTime(2026, 9, 21, 9),
          end: DateTime(2026, 9, 21, 10),
        ),
      ];
      final session = ScheduleSession(
        id: '10',
        scheduleTypeId: '1',
        trainerId: '3',
        title: 'PT',
        startTime: DateTime(2026, 9, 21, 9),
        endTime: DateTime(2026, 9, 21, 10),
        maxCapacity: 1,
        status: ScheduleSessionStatus.scheduled,
        rowVersion: 1,
      );

      final matched = OpenSlotsCalculator.matchSessionsToComputedSlots(
        openSlots: openSlots,
        sessions: [session],
      );
      expect(matched, hasLength(1));
      expect(matched.first.scheduleId, '10');
    });
  });
}
