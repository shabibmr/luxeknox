import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_trainer_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/edit_trainer_profile_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/edit_trainer_profile_screen.dart';
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

class MockGetTrainerUseCase extends Mock implements GetTrainerUseCase {}

class MockUpdateTrainerUseCase extends Mock implements UpdateTrainerUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockGetTrainerUseCase getTrainer;
  late MockUpdateTrainerUseCase updateTrainer;

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const testProfile = TrainerProfile(
    id: 42,
    userId: 10,
    firstName: 'John',
    lastName: 'Doe',
    bio: 'Fitness Enthusiast',
    specializations: ['Strength', 'HIIT'],
    hourlyRate: '50.00',
    maxClientsCapacity: 15,
    isActive: true,
    phoneNumber: '+1234567890',
  );

  setUpAll(() {
    registerFallbackValue(testProfile);
  });

  setUp(() {
    getTrainer = MockGetTrainerUseCase();
    updateTrainer = MockUpdateTrainerUseCase();

    when(() => getTrainer(42)).thenAnswer(
      (_) async => const Right(testProfile),
    );

    getIt.registerFactory<EditTrainerProfileCubit>(
      () => EditTrainerProfileCubit(getTrainer, updateTrainer),
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

  testWidgets('shows noPermission when isAdmin is true and capability missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const EditTrainerProfileScreen(trainerId: 42, isAdmin: true),
        capabilities: const Capabilities(slugs: []),
      ),
    );

    expect(find.text(PeopleStrings.noPermission), findsOneWidget);
    verifyNever(() => getTrainer(any()));
  });

  testWidgets('renders admin-only fields in admin mode with permission', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const EditTrainerProfileScreen(trainerId: 42, isAdmin: true),
        capabilities: const Capabilities(slugs: ['trainers.update']),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text(PeopleStrings.maxClients), findsOneWidget);
    expect(find.text(PeopleStrings.statusActive), findsOneWidget);
  });

  testWidgets('hides admin-only fields in non-admin (self-edit) mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const EditTrainerProfileScreen(trainerId: 42, isAdmin: false),
        capabilities: const Capabilities(slugs: []),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Doe'), findsOneWidget);
    expect(find.text(PeopleStrings.maxClients), findsNothing);
    expect(find.text(PeopleStrings.statusActive), findsNothing);
  });

  testWidgets('submits updated profile in admin mode after confirming deactivation', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    when(() => updateTrainer(any())).thenAnswer(
      (invocation) async => Right(invocation.positionalArguments.first as TrainerProfile),
    );

    await tester.pumpWidget(
      wrap(
        const EditTrainerProfileScreen(trainerId: 42, isAdmin: true),
        capabilities: const Capabilities(slugs: ['trainers.update']),
      ),
    );

    await tester.pumpAndSettle();

    // Toggle active switch off
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    // Deactivation confirmation dialog should appear
    expect(find.text(PeopleStrings.deactivateTrainerConfirm), findsOneWidget);
    await tester.tap(find.text(PeopleStrings.confirmStatusChange));
    await tester.pumpAndSettle();

    // Ensure save button is visible and tap it
    final saveButton = find.text(PeopleStrings.save);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final captured = verify(() => updateTrainer(captureAny())).captured;
    expect(captured.length, 1);
    final savedProfile = captured.first as TrainerProfile;
    expect(savedProfile.id, 42);
    expect(savedProfile.isActive, false);
  });

  testWidgets('canceling deactivation dialog keeps trainer active', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const EditTrainerProfileScreen(trainerId: 42, isAdmin: true),
        capabilities: const Capabilities(slugs: ['trainers.update']),
      ),
    );

    await tester.pumpAndSettle();

    // Toggle active switch off
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.deactivateTrainerConfirm), findsOneWidget);
    await tester.tap(find.text(PeopleStrings.cancel));
    await tester.pumpAndSettle();

    // Switch should still be checked (true)
    final switchTile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(switchTile.value, true);
  });

  testWidgets('shows unsaved changes dialog when attempting to pop dirty form', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const EditTrainerProfileScreen(trainerId: 42, isAdmin: true),
        capabilities: const Capabilities(slugs: ['trainers.update']),
      ),
    );

    await tester.pumpAndSettle();

    // Modify a text field to make form dirty
    await tester.enterText(find.widgetWithText(TextField, 'John'), 'Johnny');
    await tester.pumpAndSettle();

    // Simulate system pop
    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();
    await tester.pumpAndSettle();

    // Unsaved changes dialog should be visible
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
