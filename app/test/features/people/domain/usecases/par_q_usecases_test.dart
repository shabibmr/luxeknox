import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_inputs.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:luxeknox/features/people/domain/repositories/par_q_repository.dart';
import 'package:luxeknox/features/people/domain/usecases/clear_par_q_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/review_par_q_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/submit_par_q_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockParQRepository extends Mock implements ParQRepository {}

void main() {
  late MockParQRepository repository;

  final screening = ParQScreening(
    id: 1,
    memberId: 10,
    version: 'PAR-Q+ 2024',
    answers: List.filled(7, ParQAnswer.no),
    hasPositiveAnswer: false,
    referralRequired: false,
    declarationAccepted: true,
    clearanceStatus: ParQClearanceStatus.passed,
    createdAt: DateTime.utc(2026, 3, 1),
  );
  final submission = ParQSubmission(
    memberId: 10,
    declarationAccepted: true,
    clientSignature: 'ink',
    answers: List.filled(7, ParQAnswer.no),
  );
  const review = ParQTrainerReviewInput(
    memberId: 10,
    trainerScreeningNotes: 'ok',
    referralRequired: false,
  );
  const clearance = ParQClearanceInput(
    memberId: 10,
    decision: ParQClearanceDecision.cleared,
  );

  setUp(() => repository = MockParQRepository());

  test('SubmitParQUseCase delegates to the repository', () async {
    when(
      () => repository.submit(submission),
    ).thenAnswer((_) async => Right(screening));
    expect(await SubmitParQUseCase(repository)(submission), Right(screening));
  });

  test('ReviewParQUseCase delegates to the repository', () async {
    when(
      () => repository.trainerReview(review),
    ).thenAnswer((_) async => Right(screening));
    expect(await ReviewParQUseCase(repository)(review), Right(screening));
  });

  test('ClearParQUseCase propagates repository failures', () async {
    const failure = BusinessRuleFailure('boom');
    when(
      () => repository.clear(clearance),
    ).thenAnswer((_) async => const Left(failure));
    expect(await ClearParQUseCase(repository)(clearance), const Left(failure));
  });
}
