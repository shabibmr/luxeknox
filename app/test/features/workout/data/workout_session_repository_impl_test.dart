import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/network/error_interceptor.dart';
import 'package:luxeknox/features/workout/data/datasources/workout_session_remote_datasource.dart';
import 'package:luxeknox/features/workout/data/repositories/workout_session_repository_impl.dart';
import 'package:luxeknox/features/workout/domain/entities/performed_set_metrics.dart';
import 'package:luxeknox/features/workout/domain/entities/session_completion.dart';
import 'package:luxeknox/features/workout/domain/repositories/workout_session_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements WorkoutSessionRemoteDataSource {}

api.WorkoutSession _session({int id = 1}) {
  return api.WorkoutSession(
    (b) => b
      ..id = id
      ..memberId = 42
      ..startedAt = DateTime(2026, 1, 1)
      ..sets.replace(const <api.WorkoutSessionExercise>[]),
  );
}

api.WorkoutSessionExercise _set({int id = 1}) {
  return api.WorkoutSessionExercise(
    (b) => b
      ..id = id
      ..workoutSessionId = 1
      ..exerciseId = 2
      ..setNumber = 1
      ..repsCompleted = 10
      ..isCompleted = true,
  );
}

DioException _dioError({required int statusCode, String? message}) {
  final requestOptions = RequestOptions(path: '/');
  final response = Response<Object?>(
    requestOptions: requestOptions,
    statusCode: statusCode,
    data: {
      'code': statusCode == 422 ? 'business_rule' : null,
      'message': message,
    },
  );
  final error = DioException(
    requestOptions: requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
  );
  final failure = mapDioErrorToFailure(error);
  return error.copyWith(error: FailureDioException(failure, error));
}

void main() {
  late MockRemote remote;
  late WorkoutSessionRepository repository;

  setUpAll(() {
    registerFallbackValue(api.WorkoutSetUpdate((b) => b..repsCompleted = 1));
    registerFallbackValue(
      api.WorkoutSetWrite(
        (b) => b
          ..exerciseId = 1
          ..setNumber = 1,
      ),
    );
    registerFallbackValue(const SessionCompletion());
  });

  setUp(() {
    remote = MockRemote();
    repository = WorkoutSessionRepositoryImpl(remote);
  });

  group('getActiveSession', () {
    test('returns null on 404, not a Failure', () async {
      when(
        () => remote.getActiveSession(memberId: any(named: 'memberId')),
      ).thenThrow(_dioError(statusCode: 404));

      final result = await repository.getActiveSession('42');

      result.fold(
        (f) => fail('expected Right(null), got Left($f)'),
        (session) => expect(session, isNull),
      );
    });

    test('maps session with sets', () async {
      when(
        () => remote.getActiveSession(memberId: any(named: 'memberId')),
      ).thenAnswer((_) async => _session());

      final result = await repository.getActiveSession('42');

      result.fold((f) => fail('expected Right, got Left($f)'), (session) {
        expect(session, isNotNull);
        expect(session!.id, '1');
        expect(session.memberId, '42');
      });
    });
  });

  group('logSet', () {
    test(
      'forwards performed metrics and NEVER targets (Issue #54)',
      () async {
        when(() => remote.logSet(any(), any())).thenAnswer((_) async => _set());

        await repository.logSet(
          '1',
          exerciseId: '2',
          setNumber: 1,
          metrics: const PerformedSetMetrics(
            repsCompleted: 10,
            weightLiftedKg: 80,
            rpeScore: 8,
            actualRir: 1.5,
            actualDurationSeconds: 35,
            notes: 'Felt strong',
          ),
        );

        final captured = verify(() => remote.logSet(1, captureAny())).captured;
        final write = captured[0] as api.WorkoutSetWrite;
        expect(write.targetRir, isNull, reason: 'Targets must never be sent in set write');
        expect(write.targetDurationSeconds, isNull, reason: 'Targets must never be sent in set write');
        expect(write.actualRir, 1.5);
        expect(write.actualDurationSeconds, 35);
        expect(write.notes, 'Felt strong');
      },
    );

    test('validates actual RIR in range (0-10)', () async {
      final result = await repository.logSet(
        '1',
        exerciseId: '2',
        setNumber: 1,
        metrics: const PerformedSetMetrics(actualRir: 12),
      );

      result.fold((f) {
        expect(f, isA<ValidationFailure>());
        expect((f as ValidationFailure).details, contains('RIR must be 0–10'));
      }, (_) => fail('expected Left'));
    });

    test('validates actual duration seconds non-negative', () async {
      final result = await repository.logSet(
        '1',
        exerciseId: '2',
        setNumber: 1,
        metrics: const PerformedSetMetrics(actualDurationSeconds: -5),
      );

      result.fold((f) {
        expect(f, isA<ValidationFailure>());
        expect(
          (f as ValidationFailure).details,
          contains('Duration seconds must be non-negative'),
        );
      }, (_) => fail('expected Left'));
    });
  });

  group('updateSet', () {
    test('sends only provided fields and NEVER targets (Issue #54)', () async {
      when(
        () => remote.updateSet(any(), any(), any()),
      ).thenAnswer((_) async => _set());

      await repository.updateSet(
        '1',
        '1',
        metrics: const PerformedSetMetrics(
          repsCompleted: 8,
          actualRir: 1,
          actualDurationSeconds: 45,
        ),
      );

      final captured = verify(
        () => remote.updateSet(any(), any(), captureAny()),
      ).captured;
      final update = captured[0] as api.WorkoutSetUpdate;
      expect(update.repsCompleted, 8);
      expect(update.targetRir, isNull, reason: 'Targets must never be sent in set update');
      expect(update.targetDurationSeconds, isNull, reason: 'Targets must never be sent in set update');
      expect(update.actualRir, 1);
      expect(update.actualDurationSeconds, 45);
      expect(update.weightLiftedKg, isNull);
      expect(update.rpeScore, isNull);
    });

    test('validates updated RIR in range (0-10)', () async {
      final result = await repository.updateSet(
        '1',
        '1',
        metrics: const PerformedSetMetrics(actualRir: -1),
      );

      result.fold(
        (f) => expect(
          (f as ValidationFailure).details,
          contains('RIR must be 0–10'),
        ),
        (_) => fail('expected Left'),
      );
    });
  });

  group('completeSession', () {
    test(
      'forwards SessionCompletion with NO client-supplied timestamps (Issue #54)',
      () async {
        when(
          () => remote.completeSession(
            any(),
            completion: any(named: 'completion'),
          ),
        ).thenAnswer((_) async => _session());

        const completion = SessionCompletion(
          notes: 'Great workout',
          clientFeedbackRating: 5,
          effortRating: 9,
          satisfactionRating: 8,
          painDiscomfortScore: 2,
          painNotes: 'Minor tightness',
          trainerNotes: 'Increase load next week',
          nextSessionPlan: 'Volume day',
          sessionFocus: 'Lower Strength',
          warmupProtocol: 'Dynamic mobility',
          cooldownProtocol: 'Stretching',
          clientSigned: true,
          trainerSigned: true,
        );

        final result = await repository.completeSession(
          '1',
          completion: completion,
        );

        verify(
          () => remote.completeSession(
            1,
            completion: completion,
          ),
        ).called(1);

        expect(result.isRight(), isTrue);
      },
    );

    test('accepts ratings at API bounds (Issue #54)', () async {
      when(
        () => remote.completeSession(
          any(),
          completion: any(named: 'completion'),
        ),
      ).thenAnswer((_) async => _session());

      // Lower bounds: feedback: 1, effort: 1, satisfaction: 1, pain: 0
      final lowerResult = await repository.completeSession(
        '1',
        completion: const SessionCompletion(
          clientFeedbackRating: 1,
          effortRating: 1,
          satisfactionRating: 1,
          painDiscomfortScore: 0,
        ),
      );
      expect(lowerResult.isRight(), isTrue);

      // Upper bounds: feedback: 5, effort: 10, satisfaction: 10, pain: 10
      final upperResult = await repository.completeSession(
        '1',
        completion: const SessionCompletion(
          clientFeedbackRating: 5,
          effortRating: 10,
          satisfactionRating: 10,
          painDiscomfortScore: 10,
        ),
      );
      expect(upperResult.isRight(), isTrue);
    });

    test('validates clientFeedbackRating outside range (1-5)', () async {
      final low = await repository.completeSession(
        '1',
        completion: const SessionCompletion(clientFeedbackRating: 0),
      );
      low.fold(
        (f) => expect((f as ValidationFailure).details, contains('Rating must be 1–5')),
        (_) => fail('expected Left'),
      );

      final high = await repository.completeSession(
        '1',
        completion: const SessionCompletion(clientFeedbackRating: 6),
      );
      high.fold(
        (f) => expect((f as ValidationFailure).details, contains('Rating must be 1–5')),
        (_) => fail('expected Left'),
      );
    });

    test('validates effortRating range (1-10)', () async {
      final result = await repository.completeSession(
        '1',
        completion: const SessionCompletion(effortRating: 11),
      );
      result.fold(
        (f) => expect(
          (f as ValidationFailure).details,
          contains('Effort rating must be 1–10'),
        ),
        (_) => fail('expected Left'),
      );
    });

    test('validates satisfactionRating range (1-10)', () async {
      final result = await repository.completeSession(
        '1',
        completion: const SessionCompletion(satisfactionRating: 0),
      );
      result.fold(
        (f) => expect(
          (f as ValidationFailure).details,
          contains('Satisfaction rating must be 1–10'),
        ),
        (_) => fail('expected Left'),
      );
    });

    test('validates painDiscomfortScore range (0-10)', () async {
      final result = await repository.completeSession(
        '1',
        completion: const SessionCompletion(painDiscomfortScore: 11),
      );
      result.fold(
        (f) => expect(
          (f as ValidationFailure).details,
          contains('Pain / discomfort score must be 0–10'),
        ),
        (_) => fail('expected Left'),
      );
    });
  });

  group('deleteSet', () {
    test('maps 422 to Failure carrying server message', () async {
      when(() => remote.deleteSet(any(), any())).thenThrow(
        _dioError(
          statusCode: 422,
          message:
              'Read-only: an active Personal Training subscription is required to modify this member',
        ),
      );

      final result = await repository.deleteSet('1', '1');

      result.fold((f) {
        expect(f, isA<BusinessRuleFailure>());
        expect(
          (f as BusinessRuleFailure).message,
          'Read-only: an active Personal Training subscription is required to modify this member',
        );
      }, (_) => fail('expected Left'));
    });
  });

  group('getExerciseHistory', () {
    test('calls remote.getExerciseHistory and maps items', () async {
      when(
        () => remote.getExerciseHistory(
          memberId: any(named: 'memberId'),
          exerciseId: any(named: 'exerciseId'),
        ),
      ).thenAnswer(
        (_) async => [
          api.ExerciseHistorySession(
            (b) => b
              ..sessionId = 1
              ..startedAt = DateTime(2026, 1, 1)
              ..sets.replace([
                api.WorkoutSessionExercise(
                  (b) => b
                    ..id = 1
                    ..workoutSessionId = 1
                    ..exerciseId = 2
                    ..setNumber = 1
                    ..repsCompleted = 10
                    ..weightLiftedKg = 60
                    ..isCompleted = true
                    ..notes = 'Solid reps',
                ),
              ]),
          ),
        ],
      );

      final result = await repository.getExerciseHistory(
        memberId: '42',
        exerciseId: '2',
      );

      result.fold((f) => fail('expected Right, got Left($f)'), (sessions) {
        expect(sessions.length, 1);
        expect(sessions.first.sessionId, '1');
        expect(sessions.first.sets.length, 1);
        expect(sessions.first.sets.first.notes, 'Solid reps');
      });
    });
  });
}
