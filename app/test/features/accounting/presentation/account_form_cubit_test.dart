import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/account.dart';
import 'package:luxeknox/features/accounting/domain/usecases/create_account_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_account_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/update_account_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/account_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class MockCreateAccountUseCase extends Mock implements CreateAccountUseCase {}

class MockUpdateAccountUseCase extends Mock implements UpdateAccountUseCase {}

void main() {
  late MockGetAccountUseCase mockGetAccount;
  late MockCreateAccountUseCase mockCreateAccount;
  late MockUpdateAccountUseCase mockUpdateAccount;
  late AccountFormCubit cubit;

  const tAccount = Account(
    id: 'acc-1',
    code: '1000',
    name: 'Cash on Hand',
    type: 'asset',
    isActive: true,
    isBank: false,
    isControl: false,
  );

  const tCreatedAccount = Account(
    id: 'acc-2',
    code: '1010',
    name: 'Petty Cash',
    type: 'asset',
    isActive: true,
    isBank: true,
    isControl: false,
    description: null,
  );

  const tUpdatedAccount = Account(
    id: 'acc-1',
    code: '1000',
    name: 'Cash on Hand Updated',
    type: 'asset',
    isActive: false,
    isBank: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetAccountParams(id: 'dummy'));
    registerFallbackValue(
      const CreateAccountParams(
        code: 'dummy',
        name: 'dummy',
        accountType: 'asset',
      ),
    );
    registerFallbackValue(const UpdateAccountParams(id: 'dummy'));
  });

  setUp(() {
    mockGetAccount = MockGetAccountUseCase();
    mockCreateAccount = MockCreateAccountUseCase();
    mockUpdateAccount = MockUpdateAccountUseCase();
    cubit = AccountFormCubit(
      mockGetAccount,
      mockCreateAccount,
      mockUpdateAccount,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('initial state', () {
    test('is AccountFormState with initial values', () {
      expect(cubit.state, const AccountFormState());
      expect(cubit.state.status, LoadStatus.initial);
      expect(cubit.state.account, isNull);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.isSubmitting, isFalse);
    });
  });

  group('load', () {
    blocTest<AccountFormCubit, AccountFormState>(
      'emits [loading, success] when getAccount succeeds',
      build: () {
        when(
          () => mockGetAccount(any()),
        ).thenAnswer((_) async => const Right(tAccount));
        return cubit;
      },
      act: (cubit) => cubit.load('acc-1'),
      expect: () => [
        const AccountFormState(status: LoadStatus.loading),
        const AccountFormState(
          status: LoadStatus.success,
          account: tAccount,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetAccount(const GetAccountParams(id: 'acc-1')),
        ).called(1);
      },
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'emits [loading, failure] when getAccount returns failure',
      build: () {
        when(
          () => mockGetAccount(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.load('acc-1'),
      expect: () => [
        const AccountFormState(status: LoadStatus.loading),
        const AccountFormState(
          status: LoadStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetAccount(const GetAccountParams(id: 'acc-1')),
        ).called(1);
      },
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'clears previous failure when loading starts',
      seed: () => const AccountFormState(
        status: LoadStatus.failure,
        failure: NetworkFailure(),
      ),
      build: () {
        when(
          () => mockGetAccount(any()),
        ).thenAnswer((_) async => const Right(tAccount));
        return cubit;
      },
      act: (cubit) => cubit.load('acc-1'),
      expect: () => [
        const AccountFormState(
          status: LoadStatus.loading,
          failure: null,
        ),
        const AccountFormState(
          status: LoadStatus.success,
          account: tAccount,
          failure: null,
        ),
      ],
    );
  });

  group('create', () {
    const createParams = CreateAccountParams(
      name: 'Petty Cash',
      accountType: 'asset',
      parentId: 'acc-1',
      isActive: true,
      isBank: true,
      isControl: false,
      controlRole: null,
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'emits [submitting, success] when create succeeds',
      build: () {
        when(
          () => mockCreateAccount(any()),
        ).thenAnswer((_) async => const Right(tCreatedAccount));
        return cubit;
      },
      act: (cubit) => cubit.create(
        name: 'Petty Cash',
        accountType: 'asset',
        parentId: 'acc-1',
        isActive: true,
        isBank: true,
        isControl: false,
        controlRole: null,
      ),
      expect: () => [
        const AccountFormState(isSubmitting: true),
        const AccountFormState(
          status: LoadStatus.success,
          account: tCreatedAccount,
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(() => mockCreateAccount(createParams)).called(1);
      },
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'emits [submitting, failure] when create returns failure',
      build: () {
        when(
          () => mockCreateAccount(any()),
        ).thenAnswer((_) async => const Left(BusinessRuleFailure('Create failed')));
        return cubit;
      },
      act: (cubit) => cubit.create(
        name: 'Petty Cash',
        accountType: 'asset',
      ),
      expect: () => [
        const AccountFormState(isSubmitting: true),
        const AccountFormState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Create failed'),
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(
          () => mockCreateAccount(
            const CreateAccountParams(
              name: 'Petty Cash',
              accountType: 'asset',
            ),
          ),
        ).called(1);
      },
    );

    test('returns true on success', () async {
      when(
        () => mockCreateAccount(any()),
      ).thenAnswer((_) async => const Right(tCreatedAccount));

      final result = await cubit.create(
        name: 'Petty Cash',
        accountType: 'asset',
      );

      expect(result, isTrue);
    });

    test('returns false on failure', () async {
      when(
        () => mockCreateAccount(any()),
      ).thenAnswer((_) async => const Left(BusinessRuleFailure('Create failed')));

      final result = await cubit.create(
        name: 'Petty Cash',
        accountType: 'asset',
      );

      expect(result, isFalse);
    });
  });

  group('update', () {
    const updateParams = UpdateAccountParams(
      id: 'acc-1',
      name: 'Cash on Hand Updated',
      parentId: 'parent-1',
      isActive: false,
      isBank: false,
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'emits [submitting, success] when update succeeds',
      build: () {
        when(
          () => mockUpdateAccount(any()),
        ).thenAnswer((_) async => const Right(tUpdatedAccount));
        return cubit;
      },
      act: (cubit) => cubit.update(
        id: 'acc-1',
        name: 'Cash on Hand Updated',
        parentId: 'parent-1',
        isActive: false,
        isBank: false,
      ),
      expect: () => [
        const AccountFormState(isSubmitting: true),
        const AccountFormState(
          status: LoadStatus.success,
          account: tUpdatedAccount,
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(() => mockUpdateAccount(updateParams)).called(1);
      },
    );

    blocTest<AccountFormCubit, AccountFormState>(
      'emits [submitting, failure] when update returns failure',
      build: () {
        when(
          () => mockUpdateAccount(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.update(
        id: 'acc-1',
        name: 'Cash on Hand Updated',
      ),
      expect: () => [
        const AccountFormState(isSubmitting: true),
        const AccountFormState(
          status: LoadStatus.failure,
          failure: NetworkFailure(),
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(
          () => mockUpdateAccount(
            const UpdateAccountParams(
              id: 'acc-1',
              name: 'Cash on Hand Updated',
            ),
          ),
        ).called(1);
      },
    );

    test('returns true on success', () async {
      when(
        () => mockUpdateAccount(any()),
      ).thenAnswer((_) async => const Right(tUpdatedAccount));

      final result = await cubit.update(
        id: 'acc-1',
        name: 'Cash on Hand Updated',
      );

      expect(result, isTrue);
    });

    test('returns false on failure', () async {
      when(
        () => mockUpdateAccount(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await cubit.update(
        id: 'acc-1',
        name: 'Cash on Hand Updated',
      );

      expect(result, isFalse);
    });
  });

  group('deactivate', () {
    test('calls update with isActive: false and returns true on success', () async {
      when(
        () => mockUpdateAccount(any()),
      ).thenAnswer((_) async => const Right(tUpdatedAccount));

      final result = await cubit.deactivate('acc-1');

      expect(result, isTrue);
      verify(
        () => mockUpdateAccount(
          const UpdateAccountParams(
            id: 'acc-1',
            isActive: false,
          ),
        ),
      ).called(1);
    });

    test('calls update with isActive: false and returns false on failure', () async {
      when(
        () => mockUpdateAccount(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await cubit.deactivate('acc-1');

      expect(result, isFalse);
      verify(
        () => mockUpdateAccount(
          const UpdateAccountParams(
            id: 'acc-1',
            isActive: false,
          ),
        ),
      ).called(1);
    });
  });

  group('AccountFormState copyWith', () {
    test('supports setting and clearing nullable failure and account', () {
      const state = AccountFormState(
        status: LoadStatus.failure,
        account: tAccount,
        failure: NetworkFailure(),
        isSubmitting: true,
      );

      final updated = state.copyWith(
        status: LoadStatus.success,
        failure: null,
        isSubmitting: false,
      );

      expect(updated.status, LoadStatus.success);
      expect(updated.account, tAccount);
      expect(updated.failure, isNull);
      expect(updated.isSubmitting, isFalse);

      final clearedAccount = updated.copyWith(account: null);
      expect(clearedAccount.account, isNull);
    });
  });
}
