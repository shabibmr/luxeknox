import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/fund_transfer.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_fund_transfer_usecase.dart';
import 'package:luxeknox/features/accounting/domain/usecases/post_fund_transfer_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/fund_transfer_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFundTransferUseCase extends Mock
    implements GetFundTransferUseCase {}

class MockPostFundTransferUseCase extends Mock
    implements PostFundTransferUseCase {}

void main() {
  late MockGetFundTransferUseCase mockGetFundTransfer;
  late MockPostFundTransferUseCase mockPostFundTransfer;
  late FundTransferDetailCubit cubit;

  final tDate = DateTime.utc(2026, 10, 15);

  final tDraftTransfer = FundTransfer(
    id: 'ft-100',
    transferNumber: 'TRF-2026-0100',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '1200.00',
    feeAmount: '12.00',
    feeAccountId: '501',
    memo: 'Bank transfer with processor fee',
    status: 'draft',
  );

  final tPostedTransfer = FundTransfer(
    id: 'ft-100',
    transferNumber: 'TRF-2026-0100',
    transferDate: tDate,
    fromAccountId: '101',
    toAccountId: '102',
    amount: '1200.00',
    feeAmount: '12.00',
    feeAccountId: '501',
    memo: 'Bank transfer with processor fee',
    status: 'posted',
    journalEntryId: 'JRN-2026-9999',
  );

  setUp(() {
    mockGetFundTransfer = MockGetFundTransferUseCase();
    mockPostFundTransfer = MockPostFundTransferUseCase();
    cubit = FundTransferDetailCubit(
      mockGetFundTransfer,
      mockPostFundTransfer,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default values', () {
    expect(cubit.state, const FundTransferDetailState());
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.transfer, isNull);
    expect(cubit.state.isPosting, isFalse);
    expect(cubit.state.postSuccess, isFalse);
  });

  group('load', () {
    blocTest<FundTransferDetailCubit, FundTransferDetailState>(
      'emits [loading, success] on successful transfer load',
      build: () {
        when(() => mockGetFundTransfer('ft-100'))
            .thenAnswer((_) async => Right(tDraftTransfer));
        return cubit;
      },
      act: (cubit) => cubit.load('ft-100'),
      expect: () => [
        const FundTransferDetailState(
          status: LoadStatus.loading,
          failure: null,
        ),
        FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tDraftTransfer,
          failure: null,
        ),
      ],
    );

    blocTest<FundTransferDetailCubit, FundTransferDetailState>(
      'emits [loading, failure] when usecase fails',
      build: () {
        when(() => mockGetFundTransfer('ft-100')).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Transfer not found')));
        return cubit;
      },
      act: (cubit) => cubit.load('ft-100'),
      expect: () => [
        const FundTransferDetailState(
          status: LoadStatus.loading,
          failure: null,
        ),
        const FundTransferDetailState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Transfer not found'),
        ),
      ],
    );
  });

  test('setTransfer emits success with the given transfer', () {
    cubit.setTransfer(tDraftTransfer);

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.transfer, tDraftTransfer);
    expect(cubit.state.failure, isNull);
  });

  group('post', () {
    test('returns false without emitting when transfer is null', () async {
      final result = await cubit.post();

      expect(result, isFalse);
      verifyNever(() => mockPostFundTransfer(any()));
    });

    blocTest<FundTransferDetailCubit, FundTransferDetailState>(
      'emits [isPosting: true, success with posted status & journalEntryId] and returns true on success',
      build: () {
        when(() => mockPostFundTransfer('ft-100'))
            .thenAnswer((_) async => Right(tPostedTransfer));
        return cubit;
      },
      seed: () => FundTransferDetailState(
        status: LoadStatus.success,
        transfer: tDraftTransfer,
      ),
      act: (cubit) async => cubit.post(),
      expect: () => [
        FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tDraftTransfer,
          isPosting: true,
          failure: null,
          postSuccess: false,
        ),
        FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tPostedTransfer,
          isPosting: false,
          postSuccess: true,
          failure: null,
        ),
      ],
      verify: (_) {
        verify(() => mockPostFundTransfer('ft-100')).called(1);
      },
    );

    blocTest<FundTransferDetailCubit, FundTransferDetailState>(
      'emits [isPosting: true, failure] and returns false on failure',
      build: () {
        when(() => mockPostFundTransfer('ft-100')).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Posting failed')));
        return cubit;
      },
      seed: () => FundTransferDetailState(
        status: LoadStatus.success,
        transfer: tDraftTransfer,
      ),
      act: (cubit) async => cubit.post(),
      expect: () => [
        FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tDraftTransfer,
          isPosting: true,
          failure: null,
          postSuccess: false,
        ),
        FundTransferDetailState(
          status: LoadStatus.success,
          transfer: tDraftTransfer,
          isPosting: false,
          failure: const BusinessRuleFailure('Posting failed'),
          postSuccess: false,
        ),
      ],
    );
  });

  test('copyWith supports modifying nullable fields', () {
    const s1 = FundTransferDetailState(
      failure: BusinessRuleFailure('err'),
    );

    final s2 = s1.copyWith(
      failure: null,
      transfer: null,
    );

    expect(s2.failure, isNull);
    expect(s2.transfer, isNull);
  });
}
