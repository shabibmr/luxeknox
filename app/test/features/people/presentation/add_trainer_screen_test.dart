import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/people/domain/entities/new_trainer_input.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/create_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_trainers_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/trainer_form_cubit.dart';
import 'package:luxeknox/features/people/presentation/cubit/trainers_directory_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/add_trainer_screen.dart';
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

class MockCreateTrainerUseCase extends Mock implements CreateTrainerUseCase {}

class MockListTrainersUseCase extends Mock implements ListTrainersUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockCreateTrainerUseCase createTrainer;
  late MockListTrainersUseCase listTrainers;

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  setUpAll(() {
    registerFallbackValue(const NewTrainerInput(email: 'a@b.c'));
    registerFallbackValue(const ListTrainersParams());
  });

  setUp(() {
    createTrainer = MockCreateTrainerUseCase();
    listTrainers = MockListTrainersUseCase();

    when(() => listTrainers(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<TrainerSummary>(
          items: [],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );

    getIt.registerFactory<TrainerFormCubit>(
      () => TrainerFormCubit(createTrainer),
    );
    getIt.registerFactory<TrainersDirectoryCubit>(
      () => TrainersDirectoryCubit(listTrainers),
    );
  });

  tearDown(() => getIt.reset());

  Widget wrap(Widget child, {required Capabilities capabilities}) {
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

  testWidgets('renders create form fields', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const AddTrainerScreen(),
        capabilities: const Capabilities(
          slugs: ['trainers.create', 'trainers.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.addTrainerTitle), findsOneWidget);
    expect(find.text(PeopleStrings.firstName), findsOneWidget);
    expect(find.text(PeopleStrings.email), findsOneWidget);
    expect(find.text(PeopleStrings.password), findsOneWidget);
    expect(find.text(PeopleStrings.specializations), findsOneWidget);
    expect(find.text(PeopleStrings.maxClients), findsOneWidget);
    expect(find.text(PeopleStrings.createTrainer), findsOneWidget);
  });

  testWidgets('shows validation snackbar when required fields missing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const AddTrainerScreen(),
        capabilities: const Capabilities(
          slugs: ['trainers.create', 'trainers.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(PeopleStrings.createTrainer));
    await tester.pump();

    expect(find.text(PeopleStrings.firstNameRequired), findsOneWidget);
    verifyNever(() => createTrainer(any()));
  });

  testWidgets('directory FAB gated on trainers.create', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TrainersDirectoryScreen(),
        capabilities: const Capabilities(slugs: ['trainers.read']),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.pumpWidget(
      wrap(
        const TrainersDirectoryScreen(),
        capabilities: const Capabilities(
          slugs: ['trainers.read', 'trainers.create'],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byTooltip(PeopleStrings.addTrainerTitle), findsOneWidget);
  });
}
