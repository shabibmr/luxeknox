import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/journal.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_journal_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/reverse_journal_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/journal_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetJournalUseCase extends Mock implements GetJournalUseCase {}

class MockReverseJournalUseCase extends Mock implements ReverseJournalUseCase {}

void main() {
  late MockGetJournalUseCase mockGetJournal;
  late MockReverseJournalUseCase mockReverseJournal;
  late JournalDetailCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tJournal = Journal(
    id: 'j-1',
    journalNumber: 'JRN-2026-0001',
    entryDate: tDate,
    sourceType: 'manual',
    sourceId: 'src-1',
    memo: 'Initial deposit',
    status: 'posted',
    lines: const [
      JournalLine(
        id: 'jl-1',
        journalId: 'j-1',
        accountId: 'acc-1',
        accountCode: '1000',
        accountName: 'Cash',
        debit: '100.00',
        credit: '0.00',
        description: 'Cash deposit',
      ),
      JournalLine(
        id: 'jl-2',
        journalId: 'j-1',
        accountId: 'acc-2',
        accountCode: '3000',
        accountName: 'Capital',
        debit: '0.00',
        credit: '100.00',
        description: 'Capital contribution',
      ),
    ],
  );

  final tReversedJournal = Journal(
    id: 'j-2',
    journalNumber: 'JRN-2026-0002',
    entryDate: tDate,
    sourceType: 'manual',
    sourceId: 'src-1',
    memo: 'Reversal of JRN-2026-0001',
    status: 'reversed',
    reversesJournalId: 'j-1',
    lines: const [
      JournalLine(
        id: 'jl-3',
        journalId: 'j-2',
        accountId: 'acc-1',
        accountCode: '1000',
        accountName: 'Cash',
        debit: '0.00',
        credit: '100.00',
        description: 'Reversal line',
      ),
      JournalLine(
        id: 'jl-4',
        journalId: 'j-2',
        accountId: 'acc-2',
        accountCode: '3000',
        accountName: 'Capital',
        debit: '100.00',
        credit: '0.00',
        description: 'Reversal line',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const GetJournalParams(id: 'dummy'));
    registerFallbackValue(const ReverseJournalParams(id: 'dummy'));
  });

  setUp(() {
    mockGetJournal = MockGetJournalUseCase();
    mockReverseJournal = MockReverseJournalUseCase();
    cubit = JournalDetailCubit(
      mockGetJournal,
      mockReverseJournal,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('is JournalDetailState with default initial values', () {
      expect(cubit.state, const JournalDetailState());
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.journal, isNull);
      expect(cubit.state.isReversing, isFalse);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.reversalSuccess, isNull);
    });
  });

  group('load', () {
    blocTest<JournalDetailCubit, JournalDetailState>(
      'emits [loading, success] when getJournal succeeds',
      build: () {
        when(() => mockGetJournal(any()))
            .thenAnswer((_) async => Right(tJournal));
        return cubit;
      },
      act: (cubit) => cubit.load('j-1'),
      expect: () => [
        const JournalDetailState(status: LoadStatus.loading),
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
        ),
      ],
      verify: (_) {
        verify(() => mockGetJournal(const GetJournalParams(id: 'j-1')))
            .called(1);
      },
    );

    blocTest<JournalDetailCubit, JournalDetailState>(
      'emits [loading, failure] when getJournal fails',
      build: () {
        when(() => mockGetJournal(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load('j-1'),
      expect: () => [
        const JournalDetailState(status: LoadStatus.loading),
        const JournalDetailState(
          status: LoadStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
      verify: (_) {
        verify(() => mockGetJournal(const GetJournalParams(id: 'j-1')))
            .called(1);
      },
    );

    blocTest<JournalDetailCubit, JournalDetailState>(
      'clears previous failure when loading starts',
      seed: () => const JournalDetailState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
      build: () {
        when(() => mockGetJournal(any()))
            .thenAnswer((_) async => Right(tJournal));
        return cubit;
      },
      act: (cubit) => cubit.load('j-1'),
      expect: () => [
        const JournalDetailState(
          status: LoadStatus.loading,
          failure: null,
        ),
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
          failure: null,
        ),
      ],
    );
  });

  group('setJournal', () {
    blocTest<JournalDetailCubit, JournalDetailState>(
      'emits [success] with the provided journal',
      build: () => cubit,
      act: (cubit) => cubit.setJournal(tJournal),
      expect: () => [
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
        ),
      ],
    );
  });

  group('reverse', () {
    test('returns false without emitting if state.journal is null', () async {
      final result = await cubit.reverse();
      expect(result, isFalse);
      verifyZeroInteractions(mockReverseJournal);
    });

    blocTest<JournalDetailCubit, JournalDetailState>(
      'emits [isReversing: true, reversalSuccess] and returns true on success',
      seed: () => JournalDetailState(
        status: LoadStatus.success,
        journal: tJournal,
      ),
      build: () {
        when(() => mockReverseJournal(any()))
            .thenAnswer((_) async => Right(tReversedJournal));
        return cubit;
      },
      act: (cubit) => cubit.reverse(
        entryDate: tDate,
        memo: 'Reversal memo test',
      ),
      expect: () => [
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
          isReversing: true,
          failure: null,
          reversalSuccess: null,
        ),
        JournalDetailState(
          status: LoadStatus.success,
          journal: tReversedJournal,
          isReversing: false,
          reversalSuccess: tReversedJournal,
          failure: null,
        ),
      ],
      verify: (_) {
        verify(
          () => mockReverseJournal(
            ReverseJournalParams(
              id: 'j-1',
              entryDate: tDate,
              memo: 'Reversal memo test',
            ),
          ),
        ).called(1);
      },
    );

    test('returns true on reverse success', () async {
      cubit.setJournal(tJournal);
      when(() => mockReverseJournal(any()))
          .thenAnswer((_) async => Right(tReversedJournal));

      final result = await cubit.reverse(
        entryDate: tDate,
        memo: 'Reversal memo test',
      );

      expect(result, isTrue);
    });

    blocTest<JournalDetailCubit, JournalDetailState>(
      'emits [isReversing: true, failure] and returns false on failure',
      seed: () => JournalDetailState(
        status: LoadStatus.success,
        journal: tJournal,
      ),
      build: () {
        when(() => mockReverseJournal(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Period locked')),
        );
        return cubit;
      },
      act: (cubit) => cubit.reverse(),
      expect: () => [
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
          isReversing: true,
          failure: null,
          reversalSuccess: null,
        ),
        JournalDetailState(
          status: LoadStatus.success,
          journal: tJournal,
          isReversing: false,
          failure: const BusinessRuleFailure('Period locked'),
          reversalSuccess: null,
        ),
      ],
      verify: (_) {
        verify(
          () => mockReverseJournal(
            const ReverseJournalParams(
              id: 'j-1',
            ),
          ),
        ).called(1);
      },
    );

    test('returns false on reverse failure', () async {
      cubit.setJournal(tJournal);
      when(() => mockReverseJournal(any())).thenAnswer(
        (_) async => const Left(BusinessRuleFailure('Period locked')),
      );

      final result = await cubit.reverse();

      expect(result, isFalse);
    });
  });

  group('JournalDetailState copyWith', () {
    test('supports setting and clearing nullable failure and reversalSuccess', () {
      final state = JournalDetailState(
        status: LoadStatus.failure,
        journal: tJournal,
        failure: const NetworkFailure(),
        reversalSuccess: tReversedJournal,
        isReversing: true,
      );

      final updated = state.copyWith(
        status: LoadStatus.success,
        failure: null,
        reversalSuccess: null,
        isReversing: false,
      );

      expect(updated.status, LoadStatus.success);
      expect(updated.journal, tJournal);
      expect(updated.failure, isNull);
      expect(updated.reversalSuccess, isNull);
      expect(updated.isReversing, isFalse);

      final clearedJournal = updated.copyWith(journal: null);
      expect(clearedJournal.journal, isNull);
    });
  });
}
