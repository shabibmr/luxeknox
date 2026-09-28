import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/time/gym_timezone_provider.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_trainers_usecase.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_catalog.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/repositories/scheduling_repository.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/catalog_usecases.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/schedule_form_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/screens/schedule_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateScheduleUseCase extends Mock
    implements CreateScheduleUseCase {}

class MockUpdateScheduleUseCase extends Mock
    implements UpdateScheduleUseCase {}

class MockGetScheduleUseCase extends Mock implements GetScheduleUseCase {}

class MockListScheduleTypesUseCase extends Mock
    implements ListScheduleTypesUseCase {}

class MockListFacilitiesUseCase extends Mock implements ListFacilitiesUseCase {}

class MockListTrainersUseCase extends Mock implements ListTrainersUseCase {}

class MockGetTrainerUseCase extends Mock implements GetTrainerUseCase {}

class MockGymTimezoneProvider extends Mock implements GymTimezoneProvider {}

class FakeCreateScheduleInput extends Fake implements CreateScheduleInput {}

class FakeUpdateScheduleParams extends Fake implements UpdateScheduleParams {}

class FakeListTrainersParams extends Fake implements ListTrainersParams {}

void main() {
  late MockCreateScheduleUseCase createSchedule;
  late MockUpdateScheduleUseCase updateSchedule;
  late MockGetScheduleUseCase getSchedule;
  late MockListScheduleTypesUseCase listScheduleTypes;
  late MockListFacilitiesUseCase listFacilities;
  late MockListTrainersUseCase listTrainers;
  late MockGetTrainerUseCase getTrainer;
  late MockGymTimezoneProvider timezoneProvider;
  late ScheduleFormCubit cubit;

  final sampleSession = ScheduleSession(
    id: 's1',
    scheduleTypeId: 'st1',
    facilityId: 'f1',
    trainerId: '10',
    title: 'Morning Yoga',
    startTime: DateTime(2026, 10, 1, 9, 0),
    endTime: DateTime(2026, 10, 1, 10, 0),
    maxCapacity: 15,
    status: ScheduleSessionStatus.scheduled,
    notes: 'Bring a mat',
    rowVersion: 1,
  );

  const sampleTypes = [
    ScheduleTypeInfo(id: 'st1', name: 'Yoga'),
    ScheduleTypeInfo(id: 'st2', name: 'HIIT'),
  ];

  const sampleFacilities = [
    FacilityInfo(id: 'f1', name: 'Studio A', isActive: true),
  ];

  const sampleTrainer = TrainerProfile(
    id: 10,
    userId: 100,
    firstName: 'John',
    lastName: 'Doe',
    specializations: ['Yoga'],
    hourlyRate: '50.0',
    maxClientsCapacity: 10,
    isActive: true,
  );

  const sampleTrainerSummary = TrainerSummary(
    id: 10,
    userId: 100,
    fullName: 'John Doe',
    specializations: ['Yoga'],
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateScheduleInput());
    registerFallbackValue(FakeUpdateScheduleParams());
    registerFallbackValue(FakeListTrainersParams());
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    createSchedule = MockCreateScheduleUseCase();
    updateSchedule = MockUpdateScheduleUseCase();
    getSchedule = MockGetScheduleUseCase();
    listScheduleTypes = MockListScheduleTypesUseCase();
    listFacilities = MockListFacilitiesUseCase();
    listTrainers = MockListTrainersUseCase();
    getTrainer = MockGetTrainerUseCase();
    timezoneProvider = MockGymTimezoneProvider();

    when(() => listScheduleTypes(any()))
        .thenAnswer((_) async => const Right(sampleTypes));
    when(() => listFacilities(any()))
        .thenAnswer((_) async => const Right(sampleFacilities));
    when(() => listTrainers(any()))
        .thenAnswer((_) async => const Right(CursorPage(items: [sampleTrainerSummary], nextCursor: null, hasMore: false)));
    when(() => getTrainer(any()))
        .thenAnswer((_) async => const Right(sampleTrainer));
    when(() => timezoneProvider.timezone()).thenAnswer((_) async => 'UTC');

    getIt.registerLazySingleton<ListScheduleTypesUseCase>(() => listScheduleTypes);
    getIt.registerLazySingleton<ListFacilitiesUseCase>(() => listFacilities);
    getIt.registerLazySingleton<ListTrainersUseCase>(() => listTrainers);
    getIt.registerLazySingleton<GymTimezoneProvider>(() => timezoneProvider);

    cubit = ScheduleFormCubit(
      createSchedule,
      updateSchedule,
      getSchedule,
      listScheduleTypes,
      listFacilities,
      getTrainer,
    );
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  Widget buildWidget(ScheduleFormScreen screen) {
    return MaterialApp(
      home: screen,
    );
  }

  testWidgets('renders create mode title and form inputs', (tester) async {
    await tester.pumpWidget(
      buildWidget(ScheduleFormScreen.create(cubit: cubit)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create schedule'), findsOneWidget);
    expect(find.byKey(const Key('schedule_title_field')), findsOneWidget);
    expect(find.byKey(const Key('schedule_recur_until_field')), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('schedule_capacity_field')), findsOneWidget);
    expect(find.byKey(const Key('schedule_notes_field')), findsOneWidget);
  });

  testWidgets('submits create mode form successfully with recurUntil', (tester) async {
    when(() => createSchedule(any()))
        .thenAnswer((_) async => Right(sampleSession));

    await tester.pumpWidget(
      buildWidget(ScheduleFormScreen.create(cubit: cubit)),
    );
    await tester.pumpAndSettle();

    // Select schedule type
    await tester.tap(find.byKey(const Key('schedule_type_picker_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yoga').last);
    await tester.pumpAndSettle();

    // Enter title
    await tester.enterText(
      find.byKey(const Key('schedule_title_field')),
      'Morning Yoga',
    );
    await tester.pumpAndSettle();

    // Set recurUntil directly on cubit draft
    cubit.updateDraft((d) => d.copyWith(recurUntil: DateTime(2026, 12, 31)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('schedule_recur_until_clear_button')), findsOneWidget);

    // Submit
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('schedule_form_submit_button')));
    await tester.pumpAndSettle();

    final captured = verify(() => createSchedule(captureAny())).captured.single
        as CreateScheduleInput;
    expect(captured.recurUntil, DateTime(2026, 12, 31));
  });

  testWidgets('clears recurUntil when clear button is tapped', (tester) async {
    await tester.pumpWidget(
      buildWidget(ScheduleFormScreen.create(cubit: cubit)),
    );
    await tester.pumpAndSettle();

    cubit.updateDraft((d) => d.copyWith(recurUntil: DateTime(2026, 12, 31)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('schedule_recur_until_clear_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('schedule_recur_until_clear_button')));
    await tester.pumpAndSettle();

    expect(cubit.state.draft.recurUntil, isNull);
    expect(find.byKey(const Key('schedule_recur_until_clear_button')), findsNothing);
  });

  testWidgets('renders edit mode with prefilled values and recurring banner', (tester) async {
    final recurringSession = ScheduleSession(
      id: 's1',
      seriesId: 'series-123',
      scheduleTypeId: 'st1',
      facilityId: 'f1',
      trainerId: '10',
      title: 'Morning Yoga',
      startTime: DateTime(2026, 10, 1, 9, 0),
      endTime: DateTime(2026, 10, 1, 10, 0),
      maxCapacity: 15,
      status: ScheduleSessionStatus.scheduled,
      notes: 'Bring a mat',
      rowVersion: 1,
    );

    when(() => getSchedule('s1'))
        .thenAnswer((_) async => Right(recurringSession));

    await tester.pumpWidget(
      buildWidget(ScheduleFormScreen.edit(scheduleId: 's1', cubit: cubit)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit schedule'), findsOneWidget);
    expect(find.text('Morning Yoga'), findsOneWidget);
    expect(find.byKey(const Key('recurring_session_edit_banner')), findsOneWidget);
    expect(find.byKey(const Key('schedule_recur_until_field')), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Bring a mat'), findsOneWidget);
  });

  testWidgets('handles rowVersion conflict on edit submit', (tester) async {
    when(() => getSchedule('s1'))
        .thenAnswer((_) async => Right(sampleSession));
    when(() => updateSchedule(any()))
        .thenAnswer((_) async => const Left(ConflictFailure()));

    await tester.pumpWidget(
      buildWidget(ScheduleFormScreen.edit(scheduleId: 's1', cubit: cubit)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('schedule_title_field')),
      'Updated Yoga',
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('schedule_form_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'This session changed since you opened it. Reloaded — review the times and try again.',
      ),
      findsOneWidget,
    );
  });
}
