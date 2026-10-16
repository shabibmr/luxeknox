import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/accounting/domain/entities/go_live.dart';
import 'package:luxeknox/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_go_live_checklist_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

void main() {
  late MockAccountingRepository repository;
  late GetGoLiveChecklistUseCase useCase;

  setUp(() {
    repository = MockAccountingRepository();
    useCase = GetGoLiveChecklistUseCase(repository);
  });

  final tDate = DateTime.utc(2026, 3, 1);
  final tChecklist = GoLiveChecklist(
    goLiveDate: tDate,
    isPostingEnabled: false,
    canEnable: false,
    failingReasons: const ['No opening balance journal found.'],
    openingJournalFound: false,
    openingJournalMatches: false,
    membershipUnearned: const GoLiveUnearnedComparison(
      preview: '1000.00',
      actual: '0.00',
      isMatched: false,
    ),
    ptUnearned: const GoLiveUnearnedComparison(
      preview: '500.00',
      actual: '0.00',
      isMatched: false,
    ),
    taxMatch: const GoLiveTaxComparison(
      gymRate: '18.00',
      defaultCode: 'gst_18',
      defaultRate: '18.00',
      isMatched: true,
    ),
    paymentMethods: const [
      GoLivePaymentMethodMapping(
        id: 1,
        methodName: 'Cash',
        isActive: true,
        isDigital: false,
        accountId: 10,
        accountName: 'Cash on Hand',
      ),
    ],
  );

  test('should delegate to repository.getGoLiveChecklist with provided goLiveDate',
      () async {
    when(() => repository.getGoLiveChecklist(goLiveDate: tDate))
        .thenAnswer((_) async => Right(tChecklist));

    final result = await useCase(GetGoLiveChecklistParams(goLiveDate: tDate));

    expect(result, Right(tChecklist));
    verify(() => repository.getGoLiveChecklist(goLiveDate: tDate)).called(1);
  });

  test('should return Failure when repository fails', () async {
    when(() => repository.getGoLiveChecklist(goLiveDate: null))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await useCase(const GetGoLiveChecklistParams());

    expect(result, const Left(NetworkFailure()));
    verify(() => repository.getGoLiveChecklist(goLiveDate: null)).called(1);
  });
}
