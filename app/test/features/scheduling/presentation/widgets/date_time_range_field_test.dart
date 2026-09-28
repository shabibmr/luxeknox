import 'package:luxeknox/core/time/gym_timezone_provider.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/date_time_range_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGymTimezoneProvider extends Mock implements GymTimezoneProvider {}

void main() {
  late MockGymTimezoneProvider timezoneProvider;

  setUp(() {
    timezoneProvider = MockGymTimezoneProvider();
    when(() => timezoneProvider.timezone()).thenAnswer((_) async => 'Asia/Kolkata');
  });

  Widget buildApp({DateTime? start, DateTime? end}) {
    return MaterialApp(
      home: Scaffold(
        body: DateTimeRangeField(
          start: start,
          end: end,
          onStartChanged: (_) {},
          onEndChanged: (_) {},
          timezoneProvider: timezoneProvider,
        ),
      ),
    );
  }

  testWidgets('shows placeholders when start/end are unset', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.dateTimePlaceholder), findsNWidgets(2));
  });

  testWidgets('shows the gym timezone caption once loaded', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Times shown in Asia/Kolkata'), findsOneWidget);
  });

  testWidgets('shows a validation error when end is before start', (tester) async {
    final start = DateTime(2026, 1, 1, 10);
    final end = DateTime(2026, 1, 1, 9);

    await tester.pumpWidget(buildApp(start: start, end: end));
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.endBeforeStartError), findsOneWidget);
  });

  testWidgets('shows no validation error for a valid range', (tester) async {
    final start = DateTime(2026, 1, 1, 9);
    final end = DateTime(2026, 1, 1, 10);

    await tester.pumpWidget(buildApp(start: start, end: end));
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.endBeforeStartError), findsNothing);
  });

  test('validateRange is null when either bound is missing', () {
    expect(DateTimeRangeField.validateRange(null, null), isNull);
    expect(DateTimeRangeField.validateRange(DateTime(2026), null), isNull);
  });
}
