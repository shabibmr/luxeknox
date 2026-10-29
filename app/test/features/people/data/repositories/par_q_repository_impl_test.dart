import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/data/datasources/par_q_remote_datasource.dart';
import 'package:luxeknox/features/people/data/repositories/par_q_repository_impl.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_inputs.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:mocktail/mocktail.dart';

class MockParQRemoteDataSource extends Mock implements ParQRemoteDataSource {}

api.ParQScreening _apiScreening({
  api.ParQScreeningClearanceStatusEnum status =
      api.ParQScreeningClearanceStatusEnum.pendingClearance,
}) {
  return api.ParQScreening(
    (b) => b
      ..id = 5
      ..memberId = 10
      ..version = 'PAR-Q+ 2024'
      ..q1HeartCondition = true
      ..q1Details = 'Mild arrhythmia'
      ..q2ChestPainActivity = false
      ..q3ChestPainRest = false
      ..q4DizzinessConsciousness = false
      ..q5BoneJointProblem = true
      ..q5Details = 'Left knee'
      ..q6MedicationCondition = false
      ..q7OtherReason = false
      ..hasPositiveAnswer = true
      ..trainerScreeningNotes = 'Refer to GP'
      ..referralRequired = true
      ..referralReason = 'Cardiac history'
      ..declarationAccepted = true
      ..clientSignedAt = DateTime.utc(2026, 3, 1)
      ..clearanceStatus = status
      ..createdAt = DateTime.utc(2026, 3, 1),
  );
}

void main() {
  late MockParQRemoteDataSource remote;
  late ParQRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      api.ParQSubmit(
        (b) => b
          ..q1HeartCondition = false
          ..q2ChestPainActivity = false
          ..q3ChestPainRest = false
          ..q4DizzinessConsciousness = false
          ..q5BoneJointProblem = false
          ..q6MedicationCondition = false
          ..q7OtherReason = false
          ..declarationAccepted = api.ParQSubmitDeclarationAcceptedEnum.true_,
      ),
    );
    registerFallbackValue(
      api.ParQTrainerReview(
        (b) => b
          ..trainerScreeningNotes = ''
          ..referralRequired = false,
      ),
    );
    registerFallbackValue(
      api.ParQClearance((b) => b..decision = api.ParQClearanceDecisionEnum.cleared),
    );
  });

  setUp(() {
    remote = MockParQRemoteDataSource();
    repository = ParQRepositoryImpl(remote);
  });

  final submission = ParQSubmission(
    memberId: 10,
    declarationAccepted: true,
    answers: const [
      ParQAnswer(yes: true, details: 'Mild arrhythmia'),
      ParQAnswer.no,
      ParQAnswer.no,
      ParQAnswer.no,
      ParQAnswer(yes: true, details: 'Left knee'),
      ParQAnswer.no,
      ParQAnswer.no,
    ],
  );

  group('submit', () {
    test(
      'maps the seven answers onto the write body and the screening back',
      () async {
        when(
          () => remote.submit(any(), any()),
        ).thenAnswer((_) async => _apiScreening());

        final result = await repository.submit(submission);

        final body =
            verify(() => remote.submit(10, captureAny())).captured.single
                as api.ParQSubmit;
        expect(body.q1HeartCondition, isTrue);
        expect(body.q1Details, 'Mild arrhythmia');
        expect(body.q2ChestPainActivity, isFalse);
        expect(body.q5BoneJointProblem, isTrue);
        expect(body.q5Details, 'Left knee');
        expect(body.q7OtherReason, isFalse);
        expect(
          body.declarationAccepted,
          api.ParQSubmitDeclarationAcceptedEnum.true_,
        );

        final screening = result.getOrElse((_) => fail('Expected Right'));
        expect(screening.id, 5);
        expect(screening.answers, hasLength(7));
        expect(
          screening.answers[0],
          const ParQAnswer(yes: true, details: 'Mild arrhythmia'),
        );
        expect(screening.answers[1], ParQAnswer.no);
        expect(screening.hasPositiveAnswer, isTrue);
        expect(screening.clearanceStatus, ParQClearanceStatus.pendingClearance);
        expect(screening.isPendingClearance, isTrue);
        expect(screening.referralReason, 'Cardiac history');
      },
    );

    test(
      'refuses an unaccepted declaration without calling the server',
      () async {
        final result = await repository.submit(
          ParQSubmission(
            memberId: 10,
            declarationAccepted: false,
            answers: List.filled(7, ParQAnswer.no),
          ),
        );

        expect(result.isLeft(), isTrue);
        expect(
          result.swap().getOrElse((_) => fail('Expected Left')),
          isA<ValidationFailure>(),
        );
        verifyNever(() => remote.submit(any(), any()));
      },
    );

    test('returns a Failure when the server call throws', () async {
      when(() => remote.submit(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/members/10/par-q'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.submit(submission);

      expect(
        result.swap().getOrElse((_) => fail('Expected Left')),
        isA<NetworkFailure>(),
      );
    });
  });

  group('trainerReview', () {
    test('sends notes and referral decision', () async {
      when(
        () => remote.review(any(), any()),
      ).thenAnswer((_) async => _apiScreening());

      final result = await repository.trainerReview(
        const ParQTrainerReviewInput(
          memberId: 10,
          trainerScreeningNotes: 'Refer to GP',
          referralRequired: true,
          referralReason: 'Cardiac history',
        ),
      );

      final body =
          verify(() => remote.review(10, captureAny())).captured.single
              as api.ParQTrainerReview;
      expect(body.trainerScreeningNotes, 'Refer to GP');
      expect(body.referralRequired, isTrue);
      expect(body.referralReason, 'Cardiac history');
      expect(result.isRight(), isTrue);
    });
  });

  group('clear', () {
    test('sends the decision and maps the cleared status', () async {
      when(() => remote.clear(any(), any())).thenAnswer(
        (_) async => _apiScreening(
          status: api.ParQScreeningClearanceStatusEnum.cleared,
        ),
      );

      final result = await repository.clear(
        const ParQClearanceInput(
          memberId: 10,
          decision: ParQClearanceDecision.cleared,
        ),
      );

      final body =
          verify(() => remote.clear(10, captureAny())).captured.single
              as api.ParQClearance;
      expect(body.decision, api.ParQClearanceDecisionEnum.cleared);
      final screening = result.getOrElse((_) => fail('Expected Right'));
      expect(screening.clearanceStatus, ParQClearanceStatus.cleared);
      expect(screening.isPendingClearance, isFalse);
    });

    test('maps a rejected decision', () async {
      when(() => remote.clear(any(), any())).thenAnswer(
        (_) async => _apiScreening(
          status: api.ParQScreeningClearanceStatusEnum.rejected,
        ),
      );

      await repository.clear(
        const ParQClearanceInput(
          memberId: 10,
          decision: ParQClearanceDecision.rejected,
        ),
      );

      final body =
          verify(() => remote.clear(10, captureAny())).captured.single
              as api.ParQClearance;
      expect(body.decision, api.ParQClearanceDecisionEnum.rejected);
    });
  });
}
