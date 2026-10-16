import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/journal.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/journal_entry_form_cubit.dart';
import 'package:luxeknox/features/accounting/presentation/screens/journal_entry_form_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalEntryFormCubit extends MockCubit<JournalEntryFormState>
    implements JournalEntryFormCubit {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockJournalEntryFormCubit mockJournalEntryFormCubit;

  const tAdminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  const tWriteCapabilities = Capabilities(
    slugs: ['accounting.journals_write'],
  );

  const tNoCapabilities = Capabilities(
    slugs: [],
  );

  const tAccount1 = Account(
    id: 'acc-1',
    name: 'Cash',
    type: 'asset',
    isActive: true,
  );

  const tAccount2 = Account(
    id: 'acc-2',
    name: 'Accounts Payable',
    type: 'liability',
    isActive: true,
  );

  final tJournal = Journal(
    id: 'j-1',
    journalNumber: 'J-001',
    entryDate: DateTime(2026, 3, 15),
    status: 'posted',
    lines: const [],
  );

  setUp(() {
    mockJournalEntryFormCubit = MockJournalEntryFormCubit();
    when(() => mockJournalEntryFormCubit.state)
        .thenReturn(JournalEntryFormState());
    when(() => mockJournalEntryFormCubit.submit())
        .thenAnswer((_) async => true);

    if (getIt.isRegistered<JournalEntryFormCubit>()) {
      getIt.unregister<JournalEntryFormCubit>();
    }
    getIt.registerFactory<JournalEntryFormCubit>(
      () => mockJournalEntryFormCubit,
    );
  });

  tearDown(() {
    if (getIt.isRegistered<JournalEntryFormCubit>()) {
      getIt.unregister<JournalEntryFormCubit>();
    }
  });

  Widget wrap(
    Widget child, {
    Capabilities capabilities = tWriteCapabilities,
  }) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tAdminPrincipal,
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

  Widget wrapPushed(
    Widget child, {
    Capabilities capabilities = tWriteCapabilities,
    void Function(dynamic result)? onResult,
  }) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: tAdminPrincipal,
        capabilities: capabilities,
      ),
    );

    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<dynamic>(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<SessionCubit>.value(
                      value: sessionCubit,
                      child: child,
                    ),
                  ),
                );
                onResult?.call(result);
              },
              child: const Text('Open Screen'),
            ),
          ),
        ),
      ),
    );
  }

  group('JournalEntryFormScreen - Permission Guard', () {
    testWidgets('shows noPermission when capability is missing', (tester) async {
      await tester.pumpWidget(
        wrap(
          JournalEntryFormScreen(cubit: mockJournalEntryFormCubit),
          capabilities: tNoCapabilities,
        ),
      );

      expect(find.text(AccountingStrings.noPermission), findsOneWidget);
      expect(find.byKey(const Key('submit_journal_button')), findsNothing);
    });
  });

  group('JournalEntryFormScreen - Initial Rendering', () {
    testWidgets('renders entry date, source type, memo, and initial 2 lines',
        (tester) async {
      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.createJournalTitle), findsOneWidget);
      expect(find.text(AccountingStrings.entryDateLabel), findsOneWidget);
      expect(find.text(AccountingStrings.sourceTypeLabel), findsOneWidget);
      expect(find.text(AccountingStrings.memoLabel), findsOneWidget);
      expect(find.text('Journal Lines (2)'), findsOneWidget);
      expect(find.byKey(const Key('add_line_button')), findsOneWidget);

      expect(find.byKey(const Key('debit_field_0')), findsOneWidget);
      expect(find.byKey(const Key('credit_field_0')), findsOneWidget);
      expect(find.byKey(const Key('line_memo_field_0')), findsOneWidget);
      expect(find.byKey(const Key('debit_field_1')), findsOneWidget);
      expect(find.byKey(const Key('credit_field_1')), findsOneWidget);
      expect(find.byKey(const Key('line_memo_field_1')), findsOneWidget);

      // Delete button on lines should be disabled when lines.length == 2
      final removeBtn0 = tester.widget<IconButton>(
        find.byKey(const Key('remove_line_button_0')),
      );
      expect(removeBtn0.onPressed, isNull);

      final removeBtn1 = tester.widget<IconButton>(
        find.byKey(const Key('remove_line_button_1')),
      );
      expect(removeBtn1.onPressed, isNull);
    });

    testWidgets('uses getIt when cubit parameter is omitted', (tester) async {
      await tester.pumpWidget(
        wrap(const JournalEntryFormScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.createJournalTitle), findsOneWidget);
      expect(find.byKey(const Key('submit_journal_button')), findsOneWidget);
    });
  });

  group('JournalEntryFormScreen - ACC-094 Validation & Submit State', () {
    testWidgets('CRITICAL ACC-094: submit button is disabled when entries are unbalanced',
        (tester) async {
      // Unbalanced state: debit 100 on line 0, credit 50 on line 1
      final unbalancedState = JournalEntryFormState(
        lines: const [
          JournalLineDraft(account: tAccount1, debit: '100.00'),
          JournalLineDraft(account: tAccount2, credit: '50.00'),
        ],
      );
      when(() => mockJournalEntryFormCubit.state).thenReturn(unbalancedState);

      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      // Should show unbalanced warning
      expect(find.text(AccountingStrings.unbalancedEntryError), findsOneWidget);
      expect(find.text('Unbalanced by \$50.00'), findsOneWidget);
      expect(find.text(AccountingStrings.balancedStatus), findsNothing);

      // Submit button MUST be disabled
      final submitButtonFinder = find.byKey(const Key('submit_journal_button'));
      await tester.ensureVisible(submitButtonFinder);
      final submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
      expect(submitButton.onPressed, isNull);

      // Tapping disabled button should not call submit
      await tester.tap(submitButtonFinder, warnIfMissed: false);
      await tester.pump();
      verifyNever(() => mockJournalEntryFormCubit.submit());
    });

    testWidgets('submit button is enabled when balanced lines are provided',
        (tester) async {
      final balancedState = JournalEntryFormState(
        lines: const [
          JournalLineDraft(account: tAccount1, debit: '100.00'),
          JournalLineDraft(account: tAccount2, credit: '100.00'),
        ],
      );
      when(() => mockJournalEntryFormCubit.state).thenReturn(balancedState);

      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      // Should show balanced badge
      expect(find.text(AccountingStrings.balancedStatus), findsOneWidget);
      expect(find.text(AccountingStrings.unbalancedEntryError), findsNothing);

      // Submit button MUST be enabled
      final submitButtonFinder = find.byKey(const Key('submit_journal_button'));
      await tester.ensureVisible(submitButtonFinder);
      final submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
      expect(submitButton.onPressed, isNotNull);

      // Tapping submit calls cubit.submit()
      await tester.tap(submitButtonFinder);
      await tester.pump();
      verify(() => mockJournalEntryFormCubit.submit()).called(1);
    });

    testWidgets('shows CircularProgressIndicator when isSubmitting is true',
        (tester) async {
      final submittingState = JournalEntryFormState(
        isSubmitting: true,
        lines: const [
          JournalLineDraft(account: tAccount1, debit: '100.00'),
          JournalLineDraft(account: tAccount2, credit: '100.00'),
        ],
      );
      when(() => mockJournalEntryFormCubit.state).thenReturn(submittingState);

      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pump();

      await tester.ensureVisible(find.byType(CircularProgressIndicator));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final submitButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('submit_journal_button')),
      );
      expect(submitButton.onPressed, isNull);
    });
  });

  group('JournalEntryFormScreen - Line Operations', () {
    testWidgets('add line button calls cubit.addLine()', (tester) async {
      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('add_line_button')));
      await tester.pump();

      verify(() => mockJournalEntryFormCubit.addLine()).called(1);
    });

    testWidgets('delete line button is enabled and calls removeLine when lines > 2',
        (tester) async {
      final threeLinesState = JournalEntryFormState(
        lines: const [
          JournalLineDraft(account: tAccount1, debit: '100.00'),
          JournalLineDraft(account: tAccount2, credit: '50.00'),
          JournalLineDraft(credit: '50.00'),
        ],
      );
      when(() => mockJournalEntryFormCubit.state).thenReturn(threeLinesState);

      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Journal Lines (3)'), findsOneWidget);

      final deleteFinder = find.byKey(const Key('remove_line_button_2'));
      await tester.ensureVisible(deleteFinder);

      final deleteBtn = tester.widget<IconButton>(deleteFinder);
      expect(deleteBtn.onPressed, isNotNull);

      await tester.tap(deleteFinder);
      await tester.pump();

      verify(() => mockJournalEntryFormCubit.removeLine(2)).called(1);
    });

    testWidgets('entering memo updates cubit', (tester) async {
      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('memo_field')),
        'Monthly reconciliation',
      );
      await tester.pump();

      verify(
        () => mockJournalEntryFormCubit.setMemo('Monthly reconciliation'),
      ).called(1);
    });

    testWidgets('changing source type dropdown calls cubit.setSourceType',
        (tester) async {
      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('source_type_field')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Opening Balance').last);
      await tester.pumpAndSettle();

      verify(
        () => mockJournalEntryFormCubit.setSourceType('opening_balance'),
      ).called(1);
    });
  });

  group('JournalEntryFormScreen - Listener Effects', () {
    testWidgets('shows success snackbar and pops navigator on success',
        (tester) async {
      final stateController = StreamController<JournalEntryFormState>.broadcast();

      whenListen(
        mockJournalEntryFormCubit,
        stateController.stream,
        initialState: JournalEntryFormState(),
      );

      dynamic popResult;
      await tester.pumpWidget(
        wrapPushed(
          JournalEntryFormScreen(cubit: mockJournalEntryFormCubit),
          onResult: (res) => popResult = res,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Screen'));
      await tester.pumpAndSettle();

      // Emit success state
      stateController.add(
        JournalEntryFormState(
          status: LoadStatus.success,
          createdJournal: tJournal,
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.journalCreatedSuccess), findsOneWidget);
      expect(popResult, tJournal);

      await stateController.close();
    });

    testWidgets('shows failure snackbar on submission failure', (tester) async {
      final stateController = StreamController<JournalEntryFormState>.broadcast();

      whenListen(
        mockJournalEntryFormCubit,
        stateController.stream,
        initialState: JournalEntryFormState(),
      );

      await tester.pumpWidget(
        wrap(JournalEntryFormScreen(cubit: mockJournalEntryFormCubit)),
      );
      await tester.pumpAndSettle();

      stateController.add(
        JournalEntryFormState(
          status: LoadStatus.failure,
          failure: const BusinessRuleFailure('Duplicate journal number'),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Duplicate journal number'), findsOneWidget);

      await stateController.close();
    });
  });
}
