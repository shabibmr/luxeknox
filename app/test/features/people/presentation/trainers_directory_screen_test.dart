import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_trainers_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_trainer_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/edit_trainer_profile_cubit.dart';
import 'package:luxeknox/features/people/presentation/cubit/trainers_directory_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/trainers_directory_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListTrainersUseCase extends Mock implements ListTrainersUseCase {}

class MockGetTrainerUseCase extends Mock implements GetTrainerUseCase {}

class MockUpdateTrainerUseCase extends Mock implements UpdateTrainerUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockListTrainersUseCase listTrainers;
  late MockGetTrainerUseCase getTrainer;
  late MockUpdateTrainerUseCase updateTrainer;

  const adminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  const testTrainers = <TrainerSummary>[
    TrainerSummary(
      id: 1,
      userId: 101,
      fullName: 'Alice Smith',
      specializations: ['Cardio', 'Pilates'],
      rating: 4.8,
      isActive: true,
    ),
    TrainerSummary(
      id: 2,
      userId: 102,
      fullName: 'Bob Jones',
      specializations: ['Strength'],
      rating: 4.5,
      isActive: false,
    ),
  ];

  const testProfile = TrainerProfile(
    id: 1,
    userId: 101,
    firstName: 'Alice',
    lastName: 'Smith',
    bio: 'Experienced cardio coach',
    specializations: ['Cardio', 'Pilates'],
    hourlyRate: '60.00',
    maxClientsCapacity: 20,
    isActive: true,
    phoneNumber: '+111222333',
  );

  setUpAll(() {
    registerFallbackValue(const ListTrainersParams());
    registerFallbackValue(testProfile);
  });

  setUp(() {
    listTrainers = MockListTrainersUseCase();
    getTrainer = MockGetTrainerUseCase();
    updateTrainer = MockUpdateTrainerUseCase();

    when(() => listTrainers(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(
          items: testTrainers,
          hasMore: false,
          nextCursor: null,
        ),
      ),
    );

    when(() => getTrainer(any())).thenAnswer(
      (_) async => const Right(testProfile),
    );

    getIt.registerFactory<TrainersDirectoryCubit>(
      () => TrainersDirectoryCubit(listTrainers),
    );
    getIt.registerFactory<EditTrainerProfileCubit>(
      () => EditTrainerProfileCubit(getTrainer, updateTrainer),
    );
  });

  tearDown(() => getIt.reset());

  Widget wrap(
    Widget child, {
    Capabilities capabilities = const Capabilities(
      slugs: ['trainers.read', 'trainers.create', 'trainers.update'],
    ),
  }) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: child,
      ),
    );
  }

  testWidgets('renders trainers list and status filter chips', (tester) async {
    await tester.pumpWidget(wrap(const TrainersDirectoryScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Alice Smith'), findsOneWidget);
    expect(find.text('Bob Jones'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, PeopleStrings.filterAll), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, PeopleStrings.filterActive), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, PeopleStrings.filterInactive), findsOneWidget);
  });

  testWidgets('tapping filter chips queries with status filter', (tester) async {
    await tester.pumpWidget(wrap(const TrainersDirectoryScreen()));
    await tester.pumpAndSettle();

    // Tap Active chip
    await tester.tap(find.widgetWithText(ChoiceChip, PeopleStrings.filterActive));
    await tester.pumpAndSettle();

    verify(
      () => listTrainers(
        const ListTrainersParams(query: null, status: 'active'),
      ),
    ).called(1);

    // Tap Inactive chip
    await tester.tap(find.widgetWithText(ChoiceChip, PeopleStrings.filterInactive));
    await tester.pumpAndSettle();

    verify(
      () => listTrainers(
        const ListTrainersParams(query: null, status: 'inactive'),
      ),
    ).called(1);
  });

  testWidgets('triggers loadMore when scrolling within 200px of bottom', (
    tester,
  ) async {
    final manyTrainers = List<TrainerSummary>.generate(
      20,
      (i) => TrainerSummary(
        id: i + 1,
        userId: 100 + i,
        fullName: 'Trainer $i',
        specializations: const ['Fitness'],
        isActive: true,
      ),
    );

    when(() => listTrainers(const ListTrainersParams())).thenAnswer(
      (_) async => Right(
        CursorPage(
          items: manyTrainers,
          hasMore: true,
          nextCursor: '20',
        ),
      ),
    );

    when(
      () => listTrainers(const ListTrainersParams(cursor: '20')),
    ).thenAnswer(
      (_) async => const Right(
        CursorPage(
          items: [
            TrainerSummary(
              id: 21,
              userId: 121,
              fullName: 'Trainer 21',
              specializations: ['Fitness'],
              isActive: true,
            ),
          ],
          hasMore: false,
          nextCursor: null,
        ),
      ),
    );

    await tester.pumpWidget(wrap(const TrainersDirectoryScreen()));
    await tester.pumpAndSettle();

    // Scroll to near bottom
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();

    verify(
      () => listTrainers(const ListTrainersParams(cursor: '20')),
    ).called(1);
  });

  testWidgets('renders master-detail split layout on wide screens (>= 840dp)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const TrainersDirectoryScreen()));
    await tester.pumpAndSettle();

    // In wide mode, right pane initially displays placeholder prompt
    expect(find.text(PeopleStrings.selectTrainerPrompt), findsOneWidget);

    // Tap Alice Smith
    await tester.tap(find.text('Alice Smith'));
    await tester.pumpAndSettle();

    // Detail pane loads EditTrainerProfileScreen for Alice
    expect(find.text('Experienced cardio coach'), findsOneWidget);
    verify(() => getTrainer(1)).called(1);
  });
}
