import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goals_list_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/progress_hub_screen.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/people/domain/usecases/assign_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_member_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/member_dossier_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/member_dossier_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMemberUseCase extends Mock implements GetMemberUseCase {}

class MockUpdateMemberUseCase extends Mock implements UpdateMemberUseCase {}

class MockAssignTrainerUseCase extends Mock implements AssignTrainerUseCase {}

class MockListMemberGoalsUseCase extends Mock
    implements ListMemberGoalsUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockGetMemberUseCase getMember;
  late MockUpdateMemberUseCase updateMember;
  late MockAssignTrainerUseCase assignTrainer;
  late MockListMemberGoalsUseCase listMemberGoals;
  late MockSessionCubit sessionCubit;

  const testPerson = Person(
    id: 42,
    userId: 101,
    membershipNumber: 'MEM-042',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
  );

  const trainerPrincipal = Principal(
    userId: '1',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 't1',
  );

  setUpAll(() {
    registerFallbackValue(const MemberIdParams('42'));
  });

  setUp(() {
    getMember = MockGetMemberUseCase();
    updateMember = MockUpdateMemberUseCase();
    assignTrainer = MockAssignTrainerUseCase();
    listMemberGoals = MockListMemberGoalsUseCase();
    sessionCubit = MockSessionCubit();

    when(() => getMember(42)).thenAnswer((_) async => const Right(testPerson));
    when(
      () => listMemberGoals(any()),
    ).thenAnswer(
      (_) async => const Right(
        CursorPage<MemberGoal>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    when(() => sessionCubit.state).thenReturn(
      const SessionAuthenticated(
        principal: trainerPrincipal,
        capabilities: Capabilities(
          slugs: ['goals.read', 'goals.write', 'goals.create', 'goals.update'],
        ),
      ),
    );

    getIt.registerFactory<MemberDossierCubit>(
      () => MemberDossierCubit(getMember, updateMember, assignTrainer),
    );
    getIt.registerFactory<GoalsListCubit>(
      () => GoalsListCubit(listMemberGoals),
    );
    getIt.registerSingleton<SessionCubit>(sessionCubit);
  });

  tearDown(() => getIt.reset());

  testWidgets('renders member dossier with Goals tile', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: MemberDossierScreen(memberId: 42),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text(PeopleStrings.goals), findsOneWidget);
  });

  testWidgets('tapping Goals tile navigates to ProgressHubScreen with goal creation enabled for trainer', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: MemberDossierScreen(memberId: 42),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(PeopleStrings.goals));
    await tester.pumpAndSettle();

    expect(find.byType(ProgressHubScreen), findsOneWidget);
    expect(find.text(GoalsStrings.hubTitle), findsOneWidget);
    // Floating action button for goal creation should be visible for trainer with goals.create
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
