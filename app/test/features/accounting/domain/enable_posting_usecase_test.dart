import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:luxeknox/features/accounting/domain/usecases/enable_posting_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountingRepository extends Mock implements AccountingRepository {}

void main() {
  late MockAccountingRepository repository;
  late EnablePostingUseCase useCase;

  setUp(() {
    repository = MockAccountingRepository();
    useCase = EnablePostingUseCase(repository);
  });

  final tDate = DateTime.utc(2026, 3, 1);

  test('should delegate to repository.enablePosting with date', () async {
    when(() => repository.enablePosting(goLiveDate: tDate))
        .thenAnswer((_) async => const Right(true));

    final result = await useCase(EnablePostingParams(goLiveDate: tDate));

    expect(result, const Right(true));
    verify(() => repository.enablePosting(goLiveDate: tDate)).called(1);
  });

  test('should delegate to repository.enablePosting with null date', () async {
    when(() => repository.enablePosting(goLiveDate: null))
        .thenAnswer((_) async => const Right(true));

    final result = await useCase(const EnablePostingParams());

    expect(result, const Right(true));
    verify(() => repository.enablePosting(goLiveDate: null)).called(1);
  });

  test('should return Failure when repository fails', () async {
    when(() => repository.enablePosting(goLiveDate: any(named: 'goLiveDate')))
        .thenAnswer((_) async => const Left(BusinessRuleFailure('Preconditions failed')));

    final result = await useCase(const EnablePostingParams());

    expect(result, const Left(BusinessRuleFailure('Preconditions failed')));
  });
}
