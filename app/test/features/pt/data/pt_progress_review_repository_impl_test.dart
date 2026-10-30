import 'dart:typed_data';

import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/pt/data/datasources/pt_progress_review_remote_datasource.dart';
import 'package:luxeknox/features/pt/data/repositories/pt_progress_review_repository_impl.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_progress_review.dart';
import 'package:mocktail/mocktail.dart';

class MockPtProgressReviewRemoteDataSource extends Mock
    implements PtProgressReviewRemoteDataSource {}

api.PtProgressReview _apiReview({
  api.PtProgressReviewStatusEnum status =
      api.PtProgressReviewStatusEnum.draft,
  DateTime? trainerSignedAt,
  DateTime? clientSignedAt,
  DateTime? managerSignedAt,
  int? managerUserId,
}) {
  return api.PtProgressReview(
    (b) => b
      ..id = 7
      ..memberId = 10
      ..trainerId = 4
      ..reviewPeriodStart = api.Date(2026, 1, 1)
      ..reviewPeriodEnd = api.Date(2026, 3, 31)
      ..bodyMetricsSnapshot = ListBuilder<api.BodyMetricSnapshot>([
        api.BodyMetricSnapshot(
          (m) => m
            ..metric = 'Weight_kg'
            ..startVal = 80
            ..currentVal = 76
            ..changeVal = -4
            ..targetVal = 75,
        ),
      ])
      ..performanceMarkersSnapshot =
          ListBuilder<api.PerformanceMarkerSnapshot>([
            api.PerformanceMarkerSnapshot(
              (m) => m
                ..marker = 'bench_press'
                ..startVal = '60kg x 5'
                ..currentVal = '70kg x 5'
                ..changeVal = '+10kg'
                ..targetVal = '80kg x 5',
            ),
          ])
      ..progressHighlights = ListBuilder<String>(['consistency'])
      ..highlightsOtherText = 'Showed up every week'
      ..trainerSummary = 'Strong progress'
      ..clientFeedback = 'Feeling better'
      ..nextPhaseGoal = 'Hit 75kg'
      ..nextPhaseTrainingFocus = 'Hypertrophy'
      ..nextReviewDate = api.Date(2026, 6, 30)
      ..reviewChecklist.replace(
        api.PtReviewChecklist(
          (c) => c
            ..goalsReviewed = true
            ..measurementsReviewed = true
            ..performanceReviewed = false
            ..attendanceReviewed = true
            ..programUpdated = false
            ..nextGoalsAgreed = true,
        ),
      )
      ..finalReviewNotes = 'Keep going'
      ..clientSignedAt = clientSignedAt
      ..trainerSignedAt = trainerSignedAt
      ..managerUserId = managerUserId
      ..managerSignedAt = managerSignedAt
      ..status = status
      ..createdAt = DateTime.utc(2026, 4, 1)
      ..updatedAt = DateTime.utc(2026, 4, 2),
  );
}

PtProgressReviewDraftInput _draftInput({
  DateTime? start,
  DateTime? end,
}) {
  return PtProgressReviewDraftInput(
    memberId: 10,
    reviewPeriodStart: start ?? DateTime(2026, 1, 1),
    reviewPeriodEnd: end ?? DateTime(2026, 3, 31),
    trainerSummary: 'Strong progress',
    clientFeedback: 'Feeling better',
    nextPhaseGoal: 'Hit 75kg',
    nextPhaseTrainingFocus: 'Hypertrophy',
    nextReviewDate: DateTime(2026, 6, 30),
  );
}

Failure _leftOf(dynamic result) =>
    (result as dynamic).swap().getOrElse((_) => throw StateError('right'));

void main() {
  late MockPtProgressReviewRemoteDataSource remote;
  late PtProgressReviewRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      api.PtProgressReviewDraft(
        (b) => b
          ..reviewPeriodStart = api.Date(2026, 1, 1)
          ..reviewPeriodEnd = api.Date(2026, 3, 31),
      ),
    );
  });

  setUp(() {
    remote = MockPtProgressReviewRemoteDataSource();
    repository = PtProgressReviewRepositoryImpl(remote);
  });

  group('createDraft', () {
    test('maps the created review including snapshots and checklist', () async {
      when(
        () => remote.createDraft(any(), any()),
      ).thenAnswer((_) async => _apiReview());

      final review = (await repository.createDraft(
        _draftInput(),
      )).getOrElse((_) => throw StateError('left'));

      expect(review.id, 7);
      expect(review.memberId, 10);
      expect(review.trainerId, 4);
      expect(review.reviewPeriodStart, DateTime(2026, 1, 1));
      expect(review.reviewPeriodEnd, DateTime(2026, 3, 31));
      expect(review.status, PtProgressReviewStatus.draft);
      expect(review.bodyMetricsSnapshot.single.metric, 'Weight_kg');
      expect(review.bodyMetricsSnapshot.single.changeVal, -4);
      expect(review.performanceMarkersSnapshot.single.marker, 'bench_press');
      expect(review.progressHighlights, ['consistency']);
      expect(review.highlightsOtherText, 'Showed up every week');
      expect(review.trainerSummary, 'Strong progress');
      expect(review.nextReviewDate, DateTime(2026, 6, 30));
      expect(review.reviewChecklist!.goalsReviewed, isTrue);
      expect(review.reviewChecklist!.performanceReviewed, isFalse);
      expect(review.finalReviewNotes, 'Keep going');

      final body =
          verify(() => remote.createDraft(10, captureAny())).captured.single
              as api.PtProgressReviewDraft;
      expect(body.reviewPeriodStart, api.Date(2026, 1, 1));
      expect(body.reviewPeriodEnd, api.Date(2026, 3, 31));
      expect(body.trainerSummary, 'Strong progress');
      expect(body.nextPhaseGoal, 'Hit 75kg');
      expect(body.nextReviewDate, api.Date(2026, 6, 30));
    });

    test('refuses an end date before the start without a server call', () async {
      final result = await repository.createDraft(
        _draftInput(
          start: DateTime(2026, 3, 31),
          end: DateTime(2026, 1, 1),
        ),
      );

      expect(_leftOf(result), isA<ValidationFailure>());
      verifyNever(() => remote.createDraft(any(), any()));
    });

    test('allows equal start and end dates', () async {
      when(
        () => remote.createDraft(any(), any()),
      ).thenAnswer((_) async => _apiReview());

      final result = await repository.createDraft(
        _draftInput(
          start: DateTime(2026, 2, 1),
          end: DateTime(2026, 2, 1),
        ),
      );

      expect(result.isRight(), isTrue);
    });

    test('returns a Failure when the server call throws', () async {
      when(() => remote.createDraft(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.createDraft(_draftInput());

      expect(result.isLeft(), isTrue);
    });
  });

  group('get', () {
    test('maps the review by id', () async {
      when(() => remote.get(7)).thenAnswer((_) async => _apiReview());

      final review = (await repository.get(
        7,
      )).getOrElse((_) => throw StateError('left'));

      expect(review.id, 7);
      expect(review.status, PtProgressReviewStatus.draft);
    });

    test('maps archived status', () async {
      when(() => remote.get(7)).thenAnswer(
        (_) async =>
            _apiReview(status: api.PtProgressReviewStatusEnum.archived),
      );

      final review = (await repository.get(
        7,
      )).getOrElse((_) => throw StateError('left'));

      expect(review.status, PtProgressReviewStatus.archived);
    });

    test('returns NotFoundFailure when the review is missing', () async {
      final request = RequestOptions();
      when(() => remote.get(7)).thenThrow(
        DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: request, statusCode: 404),
        ),
      );

      final result = await repository.get(7);

      expect(result.isLeft(), isTrue);
    });
  });

  group('sign-off', () {
    test('trainerSign maps pending_client_sign', () async {
      when(() => remote.trainerSign(7)).thenAnswer(
        (_) async => _apiReview(
          status: api.PtProgressReviewStatusEnum.pendingClientSign,
          trainerSignedAt: DateTime.utc(2026, 4, 3),
        ),
      );

      final review = (await repository.trainerSign(
        7,
      )).getOrElse((_) => throw StateError('left'));

      expect(review.status, PtProgressReviewStatus.pendingClientSign);
      expect(review.trainerSignedAt, DateTime.utc(2026, 4, 3));
    });

    test('clientSign maps pending_manager_approval', () async {
      when(() => remote.clientSign(7)).thenAnswer(
        (_) async => _apiReview(
          status: api.PtProgressReviewStatusEnum.pendingManagerApproval,
          clientSignedAt: DateTime.utc(2026, 4, 4),
        ),
      );

      final review = (await repository.clientSign(
        7,
      )).getOrElse((_) => throw StateError('left'));

      expect(review.status, PtProgressReviewStatus.pendingManagerApproval);
      expect(review.clientSignedAt, DateTime.utc(2026, 4, 4));
    });

    test('managerApprove maps approved', () async {
      when(() => remote.managerApprove(7)).thenAnswer(
        (_) async => _apiReview(
          status: api.PtProgressReviewStatusEnum.approved,
          managerUserId: 99,
          managerSignedAt: DateTime.utc(2026, 4, 5),
        ),
      );

      final review = (await repository.managerApprove(
        7,
      )).getOrElse((_) => throw StateError('left'));

      expect(review.status, PtProgressReviewStatus.approved);
      expect(review.managerUserId, 99);
      expect(review.managerSignedAt, DateTime.utc(2026, 4, 5));
    });
  });

  group('exportPdf', () {
    test('returns the PDF bytes', () async {
      final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]); // %PDF
      when(() => remote.exportPdf(7)).thenAnswer((_) async => bytes);

      final result = (await repository.exportPdf(
        7,
      )).getOrElse((_) => throw StateError('left'));

      expect(result, bytes);
    });

    test('returns a Failure when export throws', () async {
      when(() => remote.exportPdf(7)).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 422,
          ),
        ),
      );

      final result = await repository.exportPdf(7);

      expect(result.isLeft(), isTrue);
    });
  });
}
