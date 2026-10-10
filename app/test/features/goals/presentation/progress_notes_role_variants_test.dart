import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note_type.dart';
import 'package:luxeknox/features/goals/domain/usecases/progress_notes_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/progress_notes_cubit.dart';
import 'package:luxeknox/features/goals/presentation/goals_strings.dart';
import 'package:luxeknox/features/goals/presentation/screens/progress_notes_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';

class _MockListNotes extends Mock implements ListProgressNotesUseCase {}

class _MockCreateNote extends Mock implements CreateProgressNoteUseCase {}

class _MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  const memberId = 'p-member';

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: memberId,
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p-trainer',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p-admin',
  );

  late _MockListNotes listNotes;
  late _MockCreateNote createNote;

  setUpAll(() {
    registerFallbackValue(const ListProgressNotesParams(memberId: '0'));
    registerFallbackValue(
      const CreateProgressNoteParams(
        memberId: '0',
        noteText: 'x',
        noteType: ProgressNoteType.memberNote,
      ),
    );
  });

  setUp(() {
    listNotes = _MockListNotes();
    createNote = _MockCreateNote();
    when(() => listNotes(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: <ProgressNote>[], nextCursor: null, hasMore: false),
      ),
    );
    getIt.registerFactory<ProgressNotesCubit>(
      () => ProgressNotesCubit(listNotes, createNote),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpRole(
    WidgetTester tester, {
    required Principal principal,
    required String location,
  }) async {
    final session = _MockSessionCubit();
    whenListen(
      session,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: const Capabilities(slugs: ['goals.remarks']),
      ),
    );
    getIt.registerSingleton<SessionCubit>(session);

    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(
          path: '/progress/notes',
          builder: (context, state) =>
              const ProgressNotesScreen(memberId: memberId),
        ),
        GoRoute(
          path: '/trainer/members/:id/goals/notes',
          builder: (context, state) =>
              ProgressNotesScreen(memberId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/admin/members/:id/goals/notes',
          builder: (context, state) =>
              ProgressNotesScreen(memberId: state.pathParameters['id']),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  Future<void> openCompose(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('progress-notes-compose')));
    await tester.pumpAndSettle();
  }

  testWidgets('member compose offers member_note only', (tester) async {
    await pumpRole(
      tester,
      principal: memberPrincipal,
      location: '/progress/notes',
    );
    await openCompose(tester);

    expect(find.byKey(const Key('progress-notes-type-locked')), findsOneWidget);
    expect(find.text(GoalsStrings.noteTypeMember), findsOneWidget);
    expect(find.text(GoalsStrings.noteTypeTrainer), findsNothing);
    expect(find.byKey(const Key('progress-notes-type')), findsNothing);
  });

  testWidgets('trainer compose offers trainer_assessment only', (tester) async {
    await pumpRole(
      tester,
      principal: trainerPrincipal,
      location: '/trainer/members/$memberId/goals/notes',
    );
    await openCompose(tester);

    expect(find.byKey(const Key('progress-notes-type-locked')), findsOneWidget);
    expect(find.text(GoalsStrings.noteTypeTrainer), findsOneWidget);
    expect(find.text(GoalsStrings.noteTypeMember), findsNothing);
    expect(find.byKey(const Key('progress-notes-type')), findsNothing);
  });

  testWidgets('admin compose offers both note types', (tester) async {
    await pumpRole(
      tester,
      principal: adminPrincipal,
      location: '/admin/members/$memberId/goals/notes',
    );
    await openCompose(tester);

    expect(find.byKey(const Key('progress-notes-type')), findsOneWidget);
    expect(find.byKey(const Key('progress-notes-type-locked')), findsNothing);

    // Open the dropdown to assert both items exist.
    await tester.tap(find.byKey(const Key('progress-notes-type')));
    await tester.pumpAndSettle();
    expect(find.text(GoalsStrings.noteTypeTrainer).hitTestable(), findsWidgets);
    expect(find.text(GoalsStrings.noteTypeMember).hitTestable(), findsOneWidget);
  });
}
