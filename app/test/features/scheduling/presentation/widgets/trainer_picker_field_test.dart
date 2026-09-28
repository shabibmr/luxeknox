import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/list_trainers_usecase.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:luxeknox/features/scheduling/presentation/widgets/trainer_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListTrainersUseCase extends Mock implements ListTrainersUseCase {}

void main() {
  late MockListTrainersUseCase listTrainers;

  const trainerA = TrainerSummary(id: 1, userId: 10, fullName: 'Alex Trainer');
  const trainerB = TrainerSummary(id: 2, userId: 11, fullName: 'Bo Trainer');

  setUpAll(() {
    registerFallbackValue(const ListTrainersParams());
  });

  setUp(() {
    listTrainers = MockListTrainersUseCase();
  });

  Widget buildApp({TrainerSummary? value}) {
    return MaterialApp(
      home: Scaffold(
        body: TrainerPickerField(
          listTrainers: listTrainers,
          value: value,
          onChanged: (_) {},
        ),
      ),
    );
  }

  testWidgets('shows placeholder when nothing selected', (tester) async {
    await tester.pumpWidget(buildApp());
    expect(find.text(SchedulingStrings.trainerFieldPlaceholder), findsOneWidget);
  });

  testWidgets('shows selected trainer name', (tester) async {
    await tester.pumpWidget(buildApp(value: trainerA));
    expect(find.text('Alex Trainer'), findsOneWidget);
  });

  testWidgets('opens search sheet and selects a trainer', (tester) async {
    when(() => listTrainers(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<TrainerSummary>(
          items: [trainerA, trainerB],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    TrainerSummary? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TrainerPickerField(
            listTrainers: listTrainers,
            onChanged: (trainer) => selected = trainer,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('trainer_picker_field')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('trainer_search_field')), findsOneWidget);
    expect(find.text('Bo Trainer'), findsOneWidget);

    await tester.tap(find.byKey(const Key('trainer_option_2')));
    await tester.pumpAndSettle();

    expect(selected, trainerB);
  });

  testWidgets('debounces search input before querying', (tester) async {
    when(() => listTrainers(const ListTrainersParams())).thenAnswer(
      (_) async => const Right(
        CursorPage<TrainerSummary>(
          items: [trainerA, trainerB],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(() => listTrainers(const ListTrainersParams(query: 'bo'))).thenAnswer(
      (_) async => const Right(
        CursorPage<TrainerSummary>(
          items: [trainerB],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.tap(find.byKey(const Key('trainer_picker_field')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('trainer_search_field')), 'bo');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    verify(() => listTrainers(const ListTrainersParams(query: 'bo'))).called(1);
    expect(find.text('Alex Trainer'), findsNothing);
    expect(find.text('Bo Trainer'), findsOneWidget);
  });

  testWidgets('shows empty state when no trainers match', (tester) async {
    when(() => listTrainers(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<TrainerSummary>(items: [], nextCursor: null, hasMore: false),
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.tap(find.byKey(const Key('trainer_picker_field')));
    await tester.pumpAndSettle();

    expect(find.text(SchedulingStrings.trainerFieldEmpty), findsOneWidget);
  });

  testWidgets('shows failure message on load error', (tester) async {
    when(() => listTrainers(any())).thenAnswer((_) async => const Left(NetworkFailure()));

    await tester.pumpWidget(buildApp());
    await tester.tap(find.byKey(const Key('trainer_picker_field')));
    await tester.pumpAndSettle();

    expect(find.byType(TextButton), findsOneWidget);
  });
}
