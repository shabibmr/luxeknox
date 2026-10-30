import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/people/domain/entities/profile_summary.dart';
import 'package:luxeknox/features/people/domain/usecases/list_members_usecase.dart';
import 'package:luxeknox/features/people/presentation/bloc/members_directory_bloc.dart';
import 'package:luxeknox/features/people/presentation/screens/members_directory_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockListMembersUseCase extends Mock implements ListMembersUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockListMembersUseCase listMembers;

  const adminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  const initialMembers = <ProfileSummary>[
    ProfileSummary(
      id: 1,
      fullName: 'Alice Smith',
      membershipNumber: 'M00000001',
      membershipStatus: 'active',
    ),
  ];

  const updatedMembers = <ProfileSummary>[
    ProfileSummary(
      id: 1,
      fullName: 'Alice Smith',
      membershipNumber: 'M00000001',
      membershipStatus: 'active',
    ),
    ProfileSummary(
      id: 2,
      fullName: 'Bob New',
      membershipNumber: 'M00000002',
      membershipStatus: 'pending',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const ListMembersParams());
  });

  setUp(() {
    listMembers = MockListMembersUseCase();
    var callCount = 0;
    when(() => listMembers(any())).thenAnswer((_) async {
      callCount++;
      return Right(
        CursorPage(
          items: callCount > 1 ? updatedMembers : initialMembers,
          hasMore: false,
          nextCursor: null,
        ),
      );
    });

    getIt.registerFactory<MembersDirectoryBloc>(
      () => MembersDirectoryBloc(listMembers),
    );
  });

  tearDown(() => getIt.reset());

  Widget buildApp() {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: Capabilities(slugs: ['members.create', 'members.read']),
      ),
    );

    final router = GoRouter(
      initialLocation: '/admin/members',
      routes: [
        GoRoute(
          path: '/admin/members',
          builder: (context, state) =>
              const MembersDirectoryScreen(addMemberPath: '/admin/members/add'),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => context.pop(2),
                    child: const Text('Simulate Create Member'),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => Scaffold(
                appBar: AppBar(
                  title: Text('Dossier ${state.pathParameters['id']}'),
                ),
                body: const Center(child: Text('Dossier Body')),
              ),
            ),
          ],
        ),
      ],
    );

    return BlocProvider<SessionCubit>.value(
      value: sessionCubit,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets(
    'after adding member and navigating back from dossier, member appears in list',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Initially only Alice Smith is present
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Bob New'), findsNothing);

      // Tap FAB to add member
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Now on Add Member Screen, simulate successful creation
      expect(find.text('Simulate Create Member'), findsOneWidget);
      await tester.tap(find.text('Simulate Create Member'));
      await tester.pumpAndSettle();

      // Navigated to Dossier for newly created member id=2
      expect(find.text('Dossier 2'), findsOneWidget);

      // Tap back button from Dossier
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Back on Members Directory Screen, Bob New is now present!
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Bob New'), findsOneWidget);
    },
  );
}
