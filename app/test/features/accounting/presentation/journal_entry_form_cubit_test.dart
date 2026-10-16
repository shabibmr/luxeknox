import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/entities/journal.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_journal_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/journal_entry_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateJournalUseCase extends Mock implements CreateJournalUseCase {}

void main() {
  late MockCreateJournalUseCase mockCreateJournal;
  late JournalEntryFormCubit cubit;

  final tDate = DateTime(2026, 3, 15);

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
    entryDate: tDate,
    status: 'posted',
    lines: const [],
  );

  setUpAll(() {
    registerFallbackValue(
      CreateJournalParams(
        entryDate: DateTime(2026, 1, 1),
        sourceType: 'manual',
        lines: const [],
      ),
    );
  });

  setUp(() {
    mockCreateJournal = MockCreateJournalUseCase();
    cubit = JournalEntryFormCubit(mockCreateJournal);
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('has 2 empty lines and cannot submit', () {
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.lines.length, 2);
      expect(cubit.state.lines[0], const JournalLineDraft());
      expect(cubit.state.lines[1], const JournalLineDraft());
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.createdJournal, isNull);
      expect(cubit.state.sourceType, 'manual');
      expect(cubit.state.memo, isNull);
      expect(cubit.state.totalDebit, 0.0);
      expect(cubit.state.totalCredit, 0.0);
      expect(cubit.state.difference, 0.0);
      expect(cubit.state.isBalanced, isFalse);
      expect(cubit.state.hasValidLines, isFalse);
      expect(cubit.state.canSubmit, isFalse);
    });
  });

  group('adding and removing lines', () {
    test('addLine adds an empty JournalLineDraft', () {
      cubit.addLine();
      expect(cubit.state.lines.length, 3);
      expect(cubit.state.lines[2], const JournalLineDraft());

      cubit.addLine();
      expect(cubit.state.lines.length, 4);
    });

    test('removeLine removes line at index when lines.length > 2', () {
      cubit.addLine(); // length 3
      cubit.updateLine(2, description: 'Line 3');
      expect(cubit.state.lines.length, 3);

      cubit.removeLine(1);
      expect(cubit.state.lines.length, 2);
      expect(cubit.state.lines[1].description, 'Line 3');
    });

    test('removeLine cannot remove below 2 lines', () {
      expect(cubit.state.lines.length, 2);
      cubit.removeLine(0);
      expect(cubit.state.lines.length, 2);

      cubit.removeLine(1);
      expect(cubit.state.lines.length, 2);
    });

    test('removeLine ignores out of range indices', () {
      cubit.addLine(); // length 3
      cubit.removeLine(-1);
      expect(cubit.state.lines.length, 3);

      cubit.removeLine(10);
      expect(cubit.state.lines.length, 3);
    });
  });

  group('updating lines', () {
    test('updates account, debit, credit, description', () {
      cubit.updateLine(
        0,
        account: tAccount1,
        debit: '100.50',
        description: 'First line',
      );

      final line0 = cubit.state.lines[0];
      expect(line0.account, tAccount1);
      expect(line0.debit, '100.50');
      expect(line0.credit, '');
      expect(line0.description, 'First line');
    });

    test('entering debit > 0 clears credit on that line', () {
      cubit.updateLine(0, credit: '50.00');
      expect(cubit.state.lines[0].credit, '50.00');

      cubit.updateLine(0, debit: '100.00');
      expect(cubit.state.lines[0].debit, '100.00');
      expect(cubit.state.lines[0].credit, '');
    });

    test('entering credit > 0 clears debit on that line', () {
      cubit.updateLine(0, debit: '100.00');
      expect(cubit.state.lines[0].debit, '100.00');

      cubit.updateLine(0, credit: '100.00');
      expect(cubit.state.lines[0].credit, '100.00');
      expect(cubit.state.lines[0].debit, '');
    });

    test('can update both debit and credit explicitly if passed together', () {
      cubit.updateLine(0, debit: '20', credit: '20');
      expect(cubit.state.lines[0].debit, '20');
      expect(cubit.state.lines[0].credit, '20');
    });

    test('ignores out of bounds updateLine index', () {
      cubit.updateLine(-1, debit: '100');
      cubit.updateLine(99, debit: '100');
      expect(cubit.state.lines[0].debit, '');
    });
  });

  group('setEntryDate, setSourceType, setMemo', () {
    test('setEntryDate updates state', () {
      final newDate = DateTime(2026, 4, 1);
      cubit.setEntryDate(newDate);
      expect(cubit.state.entryDate, newDate);
    });

    test('setSourceType updates state', () {
      cubit.setSourceType('opening_balance');
      expect(cubit.state.sourceType, 'opening_balance');
    });

    test('setMemo updates state', () {
      cubit.setMemo('Adjusting entry');
      expect(cubit.state.memo, 'Adjusting entry');

      cubit.setMemo(null);
      expect(cubit.state.memo, isNull);
    });
  });

  group('isBalanced', () {
    test('is false when totalDebit or totalCredit is zero', () {
      expect(cubit.state.isBalanced, isFalse);

      cubit.updateLine(0, debit: '100');
      expect(cubit.state.totalDebit, 100.0);
      expect(cubit.state.totalCredit, 0.0);
      expect(cubit.state.isBalanced, isFalse);

      cubit.updateLine(0, debit: '0');
      cubit.updateLine(1, credit: '100');
      expect(cubit.state.totalDebit, 0.0);
      expect(cubit.state.totalCredit, 100.0);
      expect(cubit.state.isBalanced, isFalse);
    });

    test('is false when debits != credits', () {
      cubit.updateLine(0, debit: '100.00');
      cubit.updateLine(1, credit: '99.50');
      expect(cubit.state.difference, closeTo(0.50, 0.0001));
      expect(cubit.state.isBalanced, isFalse);
    });

    test('is true when debits == credits > 0', () {
      cubit.updateLine(0, debit: '150.25');
      cubit.updateLine(1, credit: '150.25');
      expect(cubit.state.difference, closeTo(0.0, 0.0001));
      expect(cubit.state.isBalanced, isTrue);
    });
  });

  group('canSubmit and hasValidLines', () {
    test('canSubmit is false when unbalanced even if lines have accounts', () {
      cubit.updateLine(0, account: tAccount1, debit: '100.00');
      cubit.updateLine(1, account: tAccount2, credit: '50.00');

      expect(cubit.state.hasValidLines, isTrue);
      expect(cubit.state.isBalanced, isFalse);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('canSubmit is false when balanced but lines lack accounts', () {
      cubit.updateLine(0, debit: '100.00');
      cubit.updateLine(1, credit: '100.00');

      expect(cubit.state.isBalanced, isTrue);
      expect(cubit.state.hasValidLines, isFalse);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('canSubmit is false when a line has both debit and credit > 0', () {
      cubit.updateLine(0, account: tAccount1, debit: '100.00', credit: '100.00');
      cubit.updateLine(1, account: tAccount2, credit: '100.00');

      expect(cubit.state.hasValidLines, isFalse);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('canSubmit is true when lines have accounts and are balanced', () {
      cubit.updateLine(0, account: tAccount1, debit: '100.00');
      cubit.updateLine(1, account: tAccount2, credit: '100.00');

      expect(cubit.state.hasValidLines, isTrue);
      expect(cubit.state.isBalanced, isTrue);
      expect(cubit.state.canSubmit, isTrue);
    });

    test('canSubmit is false when isSubmitting is true', () {
      cubit.updateLine(0, account: tAccount1, debit: '100.00');
      cubit.updateLine(1, account: tAccount2, credit: '100.00');
      expect(cubit.state.canSubmit, isTrue);

      final submittingState = cubit.state.copyWith(isSubmitting: true);
      expect(submittingState.canSubmit, isFalse);
    });
  });

  group('submit (ACC-094)', () {
    test('ACC-094: submit() is rejected when unbalanced and does not call use case', () async {
      cubit.updateLine(0, account: tAccount1, debit: '100.00');
      cubit.updateLine(1, account: tAccount2, credit: '50.00');

      expect(cubit.state.canSubmit, isFalse);

      final success = await cubit.submit();

      expect(success, isFalse);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.status, LoadStatus.initial);
      verifyNever(() => mockCreateJournal(any()));
    });

    test('ACC-094: submit() is rejected when accounts are missing', () async {
      cubit.updateLine(0, debit: '100.00');
      cubit.updateLine(1, credit: '100.00');

      expect(cubit.state.canSubmit, isFalse);

      final success = await cubit.submit();

      expect(success, isFalse);
      verifyNever(() => mockCreateJournal(any()));
    });

    test('calls CreateJournalUseCase when balanced and succeeds', () async {
      cubit.setEntryDate(tDate);
      cubit.setSourceType('manual');
      cubit.setMemo('Test Journal Entry');
      cubit.updateLine(
        0,
        account: tAccount1,
        debit: '100.00',
        description: 'Line 1 Cash',
      );
      cubit.updateLine(
        1,
        account: tAccount2,
        credit: '100.00',
        description: 'Line 2 AP',
      );

      expect(cubit.state.canSubmit, isTrue);

      when(
        () => mockCreateJournal(any()),
      ).thenAnswer((_) async => Right(tJournal));

      final success = await cubit.submit();

      expect(success, isTrue);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.createdJournal, tJournal);
      expect(cubit.state.failure, isNull);

      final captured = verify(
        () => mockCreateJournal(captureAny()),
      ).captured.single as CreateJournalParams;

      expect(captured.entryDate, tDate);
      expect(captured.sourceType, 'manual');
      expect(captured.memo, 'Test Journal Entry');
      expect(captured.lines.length, 2);
      expect(captured.lines[0].accountId, tAccount1.id);
      expect(captured.lines[0].debit, '100.00');
      expect(captured.lines[0].credit, '0');
      expect(captured.lines[0].description, 'Line 1 Cash');
      expect(captured.lines[1].accountId, tAccount2.id);
      expect(captured.lines[1].debit, '0');
      expect(captured.lines[1].credit, '100.00');
      expect(captured.lines[1].description, 'Line 2 AP');
    });

    test('handles failure from CreateJournalUseCase', () async {
      cubit.setEntryDate(tDate);
      cubit.updateLine(0, account: tAccount1, debit: '100.00');
      cubit.updateLine(1, account: tAccount2, credit: '100.00');

      const tFailure = BusinessRuleFailure('Fiscal period is closed');
      when(
        () => mockCreateJournal(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final success = await cubit.submit();

      expect(success, isFalse);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, tFailure);
    });
  });

  group('blocTest transitions for submit', () {
    blocTest<JournalEntryFormCubit, JournalEntryFormState>(
      'emits [isSubmitting: true, success] on successful submit',
      seed: () {
        final state = JournalEntryFormState(entryDate: tDate);
        return state.copyWith(
          lines: const [
            JournalLineDraft(account: tAccount1, debit: '50'),
            JournalLineDraft(account: tAccount2, credit: '50'),
          ],
        );
      },
      build: () {
        when(
          () => mockCreateJournal(any()),
        ).thenAnswer((_) async => Right(tJournal));
        return cubit;
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        predicate<JournalEntryFormState>(
          (s) => s.isSubmitting == true && s.failure == null,
        ),
        predicate<JournalEntryFormState>(
          (s) =>
              s.isSubmitting == false &&
              s.status == LoadStatus.success &&
              s.createdJournal == tJournal,
        ),
      ],
    );

    blocTest<JournalEntryFormCubit, JournalEntryFormState>(
      'emits [isSubmitting: true, failure] on failed submit',
      seed: () {
        final state = JournalEntryFormState(entryDate: tDate);
        return state.copyWith(
          lines: const [
            JournalLineDraft(account: tAccount1, debit: '50'),
            JournalLineDraft(account: tAccount2, credit: '50'),
          ],
        );
      },
      build: () {
        when(
          () => mockCreateJournal(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        predicate<JournalEntryFormState>(
          (s) => s.isSubmitting == true && s.failure == null,
        ),
        predicate<JournalEntryFormState>(
          (s) =>
              s.isSubmitting == false &&
              s.status == LoadStatus.failure &&
              s.failure is NetworkFailure,
        ),
      ],
    );
  });

  group('JournalLineDraft & JournalEntryFormState copyWith', () {
    test('JournalLineDraft copyWith updates and preserves fields', () {
      const draft = JournalLineDraft(
        account: tAccount1,
        debit: '10',
        credit: '0',
        description: 'memo',
      );

      final updated = draft.copyWith(
        account: tAccount2,
        debit: '20',
      );
      expect(updated.account, tAccount2);
      expect(updated.debit, '20');
      expect(updated.credit, '0');
      expect(updated.description, 'memo');

      final clearedAccount = updated.copyWith(account: null);
      expect(clearedAccount.account, isNull);
    });

    test('JournalEntryFormState copyWith clears and updates fields', () {
      final initial = JournalEntryFormState(
        status: LoadStatus.failure,
        failure: const NetworkFailure(),
        createdJournal: tJournal,
        memo: 'Old memo',
      );

      final updated = initial.copyWith(
        status: LoadStatus.success,
        failure: null,
        createdJournal: null,
        memo: null,
      );

      expect(updated.status, LoadStatus.success);
      expect(updated.failure, isNull);
      expect(updated.createdJournal, isNull);
      expect(updated.memo, isNull);
    });
  });
}
