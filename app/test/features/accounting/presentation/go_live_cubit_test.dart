import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/go_live.dart';
import 'package:luxeknox/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/go_live_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

void main() {
  late MockAccountingRepository repository;
  late GoLiveCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);
  final tNewDate = DateTime.utc(2026, 10, 20);

  const tPaymentMethod = GoLivePaymentMethodMapping(
    id: 1,
    methodName: 'Cash',
    isActive: true,
    isDigital: false,
    accountId: 10,
    accountCode: '1000',
    accountName: 'Cash on Hand',
  );

  const tUnmappedMethod = GoLivePaymentMethodMapping(
    id: 2,
    methodName: 'UPI',
    isActive: true,
    isDigital: true,
    accountId: null,
  );

  final tChecklistReady = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: false,
    canEnable: true,
    failingReasons: const [],
    openingJournalFound: true,
    openingJournalMatches: true,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '2200.00',
      actual: '2200.00',
      isMatched: true,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '1500.00',
      actual: '1500.00',
      isMatched: true,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [tPaymentMethod],
  );

  final tChecklistFailing = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: false,
    canEnable: false,
    failingReasons: const [
      'Active payment method "UPI" has no mapped accounting account.',
      'No posted opening balance journal found.',
    ],
    openingJournalFound: false,
    openingJournalMatches: false,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '2200.00',
      actual: '0.00',
      isMatched: false,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '1500.00',
      actual: '0.00',
      isMatched: false,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [tPaymentMethod, tUnmappedMethod],
  );

  final tChecklistEnabled = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: true,
    canEnable: false,
    failingReasons: const [],
    openingJournalFound: true,
    openingJournalMatches: true,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '2200.00',
      actual: '2200.00',
      isMatched: true,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '1500.00',
      actual: '1500.00',
      isMatched: true,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [tPaymentMethod],
  );

  setUp(() {
    repository = MockAccountingRepository();
    cubit = GoLiveCubit(repository, initialDate: tDate);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has correct defaults', () {
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.checklist, isNull);
    expect(cubit.state.selectedDate, tDate);
    expect(cubit.state.isActionInProgress, isFalse);
    expect(cubit.state.failure, isNull);
    expect(cubit.state.successMessage, isNull);
  });

  group('load', () {
    blocTest<GoLiveCubit, GoLiveState>(
      'emits [loading, success] when checklist loaded successfully',
      build: () {
        when(() => repository.getGoLiveChecklist(goLiveDate: tDate))
            .thenAnswer((_) async => Right(tChecklistReady));
        return cubit;
      },
      act: (c) => c.load(goLiveDate: tDate),
      expect: () => [
        GoLiveState(
          status: LoadStatus.loading,
          selectedDate: tDate,
          checklist: null,
          isActionInProgress: false,
        ),
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistReady,
          isActionInProgress: false,
        ),
      ],
      verify: (_) {
        verify(() => repository.getGoLiveChecklist(goLiveDate: tDate)).called(1);
      },
    );

    blocTest<GoLiveCubit, GoLiveState>(
      'emits [loading, failure] when checklist repository returns failure',
      build: () {
        when(() => repository.getGoLiveChecklist(goLiveDate: tDate)).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Server error')));
        return cubit;
      },
      act: (c) => c.load(goLiveDate: tDate),
      expect: () => [
        GoLiveState(
          status: LoadStatus.loading,
          selectedDate: tDate,
          checklist: null,
          isActionInProgress: false,
        ),
        GoLiveState(
          status: LoadStatus.failure,
          selectedDate: tDate,
          checklist: null,
          isActionInProgress: false,
          failure: const BusinessRuleFailure('Server error'),
        ),
      ],
    );
  });

  group('changeDate', () {
    blocTest<GoLiveCubit, GoLiveState>(
      'updates selectedDate and triggers load',
      build: () {
        when(() => repository.getGoLiveChecklist(goLiveDate: tNewDate))
            .thenAnswer((_) async => Right(tChecklistReady));
        return cubit;
      },
      act: (c) => c.changeDate(tNewDate),
      expect: () => [
        GoLiveState(
          status: LoadStatus.initial,
          selectedDate: tNewDate,
        ),
        GoLiveState(
          status: LoadStatus.loading,
          selectedDate: tNewDate,
        ),
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate, // From checklist.goLiveDate
          checklist: tChecklistReady,
        ),
      ],
      verify: (_) {
        verify(() => repository.getGoLiveChecklist(goLiveDate: tNewDate))
            .called(1);
      },
    );
  });

  group('mapPaymentMethod', () {
    blocTest<GoLiveCubit, GoLiveState>(
      'maps account and reloads checklist on success',
      build: () {
        when(() => repository.mapPaymentMethodAccount(
              paymentMethodId: 2,
              accountId: 20,
            )).thenAnswer((_) async => const Right(
              GoLivePaymentMethodMapping(
                id: 2,
                methodName: 'UPI',
                isActive: true,
                isDigital: true,
                accountId: 20,
                accountCode: '1020',
                accountName: 'UPI Clearing',
              ),
            ));
        when(() => repository.getGoLiveChecklist(goLiveDate: tDate))
            .thenAnswer((_) async => Right(tChecklistReady));
        return cubit;
      },
      seed: () => GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistFailing,
      ),
      act: (c) => c.mapPaymentMethod(2, 20),
      expect: () => [
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistFailing,
          isActionInProgress: true,
        ),
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistReady,
          isActionInProgress: false,
          successMessage: AccountingStrings.paymentMethodMappedSuccess,
        ),
      ],
      verify: (_) {
        verify(() => repository.mapPaymentMethodAccount(
              paymentMethodId: 2,
              accountId: 20,
            )).called(1);
        verify(() => repository.getGoLiveChecklist(goLiveDate: tDate)).called(1);
      },
    );

    blocTest<GoLiveCubit, GoLiveState>(
      'emits failure on mapping error',
      build: () {
        when(() => repository.mapPaymentMethodAccount(
              paymentMethodId: 2,
              accountId: 20,
            )).thenAnswer((_) async =>
            const Left(ValidationFailure(['Account not found'])));
        return cubit;
      },
      seed: () => GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistFailing,
      ),
      act: (c) => c.mapPaymentMethod(2, 20),
      expect: () => [
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistFailing,
          isActionInProgress: true,
        ),
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistFailing,
          isActionInProgress: false,
          failure: const ValidationFailure(['Account not found']),
        ),
      ],
    );
  });

  group('enablePosting', () {
    blocTest<GoLiveCubit, GoLiveState>(
      'enables posting and reloads checklist on success',
      build: () {
        when(() => repository.enablePosting(goLiveDate: tDate))
            .thenAnswer((_) async => const Right(true));
        when(() => repository.getGoLiveChecklist(goLiveDate: tDate))
            .thenAnswer((_) async => Right(tChecklistEnabled));
        return cubit;
      },
      seed: () => GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistReady,
      ),
      act: (c) => c.enablePosting(),
      expect: () => [
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistReady,
          isActionInProgress: true,
        ),
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistEnabled,
          isActionInProgress: false,
          successMessage: AccountingStrings.postingEnabledSuccess,
        ),
      ],
      verify: (_) {
        verify(() => repository.enablePosting(goLiveDate: tDate)).called(1);
        verify(() => repository.getGoLiveChecklist(goLiveDate: tDate)).called(1);
      },
    );

    blocTest<GoLiveCubit, GoLiveState>(
      'emits failure when enablePosting fails',
      build: () {
        when(() => repository.enablePosting(goLiveDate: tDate)).thenAnswer(
            (_) async => const Left(ValidationFailure(['Prerequisites failed'])));
        return cubit;
      },
      seed: () => GoLiveState(
        status: LoadStatus.success,
        selectedDate: tDate,
        checklist: tChecklistReady,
      ),
      act: (c) => c.enablePosting(),
      expect: () => [
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistReady,
          isActionInProgress: true,
        ),
        GoLiveState(
          status: LoadStatus.success,
          selectedDate: tDate,
          checklist: tChecklistReady,
          isActionInProgress: false,
          failure: const ValidationFailure(['Prerequisites failed']),
        ),
      ],
    );
  });
}
