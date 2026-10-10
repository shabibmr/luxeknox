import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goals_list_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/progress_hub_screen.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';

class _MockListMemberGoals extends Mock implements ListMemberGoalsUseCase {}

class _MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late _MockListMemberGoals listGoals;
  late _MockSessionCubit sessionCubit;

  setUpAll(() {
    registerFallbackValue(const MemberIdParams('0'));
  });

  setUp(() {
    listGoals = _MockListMemberGoals();
    sessionCubit = _MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionUnauthenticated(),
    );
    getIt.registerSingleton<SessionCubit>(sessionCubit);
    when(() => listGoals(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: [], nextCursor: null, hasMore: false),
      ),
    );
    getIt.registerFactory<GoalsListCubit>(() => GoalsListCubit(listGoals));
  });

  tearDown(() => getIt.reset());

  testWidgets('hub does not show Workout Plan or Diet Plan chips', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/progress',
      routes: [
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressHubScreen(memberId: '10'),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.hubTitle), findsOneWidget);
    expect(find.text(GoalsStrings.overviewLink), findsOneWidget);
    expect(find.text(GoalsStrings.chartsLink), findsOneWidget);
    expect(find.text(GoalsStrings.measurementsLink), findsOneWidget);
    expect(find.text(GoalsStrings.photosLink), findsOneWidget);
    expect(find.text(GoalsStrings.notesLink), findsOneWidget);
    expect(find.text(GoalsStrings.timelineLink), findsNothing);
    expect(find.text('Workout Plan'), findsNothing);
    expect(find.text('Diet Plan'), findsNothing);
  });

  testWidgets('trainer dossier hub shows timeline chip', (tester) async {
    final router = GoRouter(
      initialLocation: '/trainer/members/10/goals',
      routes: [
        GoRoute(
          path: '/trainer/members/:id/goals',
          builder: (context, state) => ProgressHubScreen(
            memberId: state.pathParameters['id'],
            canCreateGoals: true,
            isAssignedTrainer: true,
          ),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text(GoalsStrings.timelineLink), findsOneWidget);
  });

  testWidgets('trainer hub Charts chip opens overview (D2)', (tester) async {
    final router = GoRouter(
      initialLocation: '/trainer/members/10/goals',
      routes: [
        GoRoute(
          path: '/trainer/members/:id/goals',
          builder: (context, state) => ProgressHubScreen(
            memberId: state.pathParameters['id'],
            canCreateGoals: true,
            isAssignedTrainer: true,
          ),
          routes: [
            GoRoute(
              path: 'overview',
              builder: (context, state) => const Scaffold(
                body: Text('overview-stub'),
              ),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text(GoalsStrings.chartsLink));
    await tester.pumpAndSettle();

    expect(find.text('overview-stub'), findsOneWidget);
  });
}
