import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_catalog.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/catalog_usecases.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/schedule_type_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListScheduleTypesUseCase extends Mock
    implements ListScheduleTypesUseCase {}

void main() {
  late MockListScheduleTypesUseCase listScheduleTypes;

  const scheduleTypes = [
    ScheduleTypeInfo(id: 't1', name: 'Yoga'),
    ScheduleTypeInfo(id: 't2', name: 'Personal training', requiresTrainer: true),
  ];

  setUpAll(() {
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    listScheduleTypes = MockListScheduleTypesUseCase();
  });

  testWidgets('renders empty state when catalog is empty', (tester) async {
    when(() => listScheduleTypes(any())).thenAnswer((_) async => const Right([]));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScheduleTypePickerField(
            listScheduleTypes: listScheduleTypes,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No session types available.'), findsOneWidget);
  });

  testWidgets('renders schedule types and reports selection', (tester) async {
    when(() => listScheduleTypes(any())).thenAnswer((_) async => const Right(scheduleTypes));
    ScheduleTypeInfo? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScheduleTypePickerField(
            listScheduleTypes: listScheduleTypes,
            onChanged: (type) => selected = type,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('schedule_type_picker_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personal training').last);
    await tester.pumpAndSettle();

    expect(selected, scheduleTypes[1]);
  });

  testWidgets('surfaces load failure', (tester) async {
    when(() => listScheduleTypes(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScheduleTypePickerField(
            listScheduleTypes: listScheduleTypes,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
