import 'package:luxeknox/features/scheduling/domain/entities/open_slot.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/open_slots_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final days = [
    DateTime(2026, 9, 21),
    DateTime(2026, 9, 22),
    DateTime(2026, 9, 23),
  ];

  final slots = [
    BookableOpenSlot(
      scheduleId: '10',
      start: DateTime(2026, 9, 21, 9),
      end: DateTime(2026, 9, 21, 10),
      title: 'PT',
    ),
    BookableOpenSlot(
      scheduleId: '11',
      start: DateTime(2026, 9, 21, 11),
      end: DateTime(2026, 9, 21, 12),
      title: 'PT',
    ),
  ];

  Widget buildApp({
    DateTime? selectedDay,
    List<BookableOpenSlot> slotsForDay = const [],
    String? selectedScheduleId,
    ValueChanged<DateTime>? onDaySelected,
    ValueChanged<BookableOpenSlot>? onSlotSelected,
  }) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: Scaffold(
        body: OpenSlotsPicker(
          days: days,
          selectedDay: selectedDay ?? days.first,
          slotsForDay: slotsForDay,
          selectedScheduleId: selectedScheduleId,
          onDaySelected: onDaySelected ?? (_) {},
          onSlotSelected: onSlotSelected ?? (_) {},
        ),
      ),
    );
  }

  testWidgets('renders day strip chips', (tester) async {
    await tester.pumpWidget(buildApp());
    expect(find.byKey(const Key('open_slots_day_2026_9_21')), findsOneWidget);
    expect(find.byKey(const Key('open_slots_day_2026_9_22')), findsOneWidget);
  });

  testWidgets('shows empty copy when day has no slots', (tester) async {
    await tester.pumpWidget(buildApp(slotsForDay: const []));
    expect(find.text(SchedulingStrings.openSlotsEmptyDay), findsOneWidget);
  });

  testWidgets('tapping a slot chip notifies selection', (tester) async {
    BookableOpenSlot? picked;
    await tester.pumpWidget(
      buildApp(
        slotsForDay: slots,
        onSlotSelected: (s) => picked = s,
      ),
    );

    await tester.tap(find.byKey(const Key('open_slot_chip_10')));
    await tester.pump();

    expect(picked?.scheduleId, '10');
  });

  testWidgets('tapping a day chip notifies day change', (tester) async {
    DateTime? picked;
    await tester.pumpWidget(
      buildApp(
        slotsForDay: slots,
        onDaySelected: (d) => picked = d,
      ),
    );

    await tester.tap(find.byKey(const Key('open_slots_day_2026_9_22')));
    await tester.pump();

    expect(picked, DateTime(2026, 9, 22));
  });
}
