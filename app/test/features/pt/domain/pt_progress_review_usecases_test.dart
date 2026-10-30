import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_progress_review.dart';
import 'package:luxeknox/features/pt/domain/repositories/pt_progress_review_repository.dart';
import 'package:luxeknox/features/pt/domain/usecases/client_sign_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/create_pt_progress_review_draft_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/export_pt_progress_review_pdf_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/get_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/manager_approve_pt_progress_review_usecase.dart';
import 'package:luxeknox/features/pt/domain/usecases/trainer_sign_pt_progress_review_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPtProgressReviewRepository extends Mock
    implements PtProgressReviewRepository {}

void main() {
  late MockPtProgressReviewRepository repository;

  final review = PtProgressReview(
    id: 7,
    memberId: 10,
    trainerId: 4,
    reviewPeriodStart: DateTime(2026, 1, 1),
    reviewPeriodEnd: DateTime(2026, 3, 31),
    status: PtProgressReviewStatus.draft,
    createdAt: DateTime.utc(2026, 4, 1),
  );

  final draftInput = PtProgressReviewDraftInput(
    memberId: 10,
    reviewPeriodStart: DateTime(2026, 1, 1),
    reviewPeriodEnd: DateTime(2026, 3, 31),
    trainerSummary: 'Strong progress',
  );

  setUp(() {
    repository = MockPtProgressReviewRepository();
  });

  test('CreatePtProgressReviewDraftUseCase forwards the draft input', () async {
    when(
      () => repository.createDraft(draftInput),
    ).thenAnswer((_) async => Right(review));

    final result = await CreatePtProgressReviewDraftUseCase(repository)(
      draftInput,
    );

    expect(result, Right<Failure, PtProgressReview>(review));
    verify(() => repository.createDraft(draftInput)).called(1);
  });

  test('GetPtProgressReviewUseCase fetches by review id', () async {
    when(() => repository.get(7)).thenAnswer((_) async => Right(review));

    final result = await GetPtProgressReviewUseCase(repository)(7);

    expect(result, Right<Failure, PtProgressReview>(review));
  });

  test('TrainerSignPtProgressReviewUseCase forwards the id', () async {
    when(
      () => repository.trainerSign(7),
    ).thenAnswer((_) async => Right(review));

    final result = await TrainerSignPtProgressReviewUseCase(repository)(7);

    expect(result.isRight(), isTrue);
    verify(() => repository.trainerSign(7)).called(1);
  });

  test('ClientSignPtProgressReviewUseCase forwards the id', () async {
    when(() => repository.clientSign(7)).thenAnswer((_) async => Right(review));

    final result = await ClientSignPtProgressReviewUseCase(repository)(7);

    expect(result.isRight(), isTrue);
    verify(() => repository.clientSign(7)).called(1);
  });

  test('ManagerApprovePtProgressReviewUseCase forwards the id', () async {
    when(
      () => repository.managerApprove(7),
    ).thenAnswer((_) async => Right(review));

    final result = await ManagerApprovePtProgressReviewUseCase(repository)(7);

    expect(result.isRight(), isTrue);
    verify(() => repository.managerApprove(7)).called(1);
  });

  test('ExportPtProgressReviewPdfUseCase returns PDF bytes', () async {
    final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
    when(() => repository.exportPdf(7)).thenAnswer((_) async => Right(bytes));

    final result = await ExportPtProgressReviewPdfUseCase(repository)(7);

    expect(result, Right<Failure, Uint8List>(bytes));
  });

  test('propagates a failure from the repository', () async {
    when(
      () => repository.get(7),
    ).thenAnswer((_) async => const Left(NotFoundFailure()));

    final result = await GetPtProgressReviewUseCase(repository)(7);

    expect(result.isLeft(), isTrue);
  });
}
