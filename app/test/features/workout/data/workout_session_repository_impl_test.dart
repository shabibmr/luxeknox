import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/network/error_interceptor.dart';
import 'package:luxeknox/features/workout/data/datasources/workout_session_remote_datasource.dart';
import 'package:luxeknox/features/workout/data/repositories/workout_session_repository_impl.dart';
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
    test('forwards targetRir, actualRir, targetDurationSeconds, actualDurationSeconds', () async {
      when(
        () => remote.logSet(any(), any()),
      ).thenAnswer((_) async => _set());

      await repository.logSet(
        '1',
        exerciseId: '2',
        setNumber: 1,
        repsCompleted: 10,
        weightLiftedKg: 80,
        rpeScore: 8,
        targetRir: 2,
        actualRir: 1.5,
        targetDurationSeconds: 30,
        actualDurationSeconds: 35,
        notes: 'Felt strong',
      );

      final captured = verify(
        () => remote.logSet(1, captureAny()),
      ).captured;
      final write = captured[0] as api.WorkoutSetWrite;
      expect(write.targetRir, 2);
      expect(write.actualRir, 1.5);
      expect(write.targetDurationSeconds, 30);
      expect(write.actualDurationSeconds, 35);
      expect(write.notes, 'Felt strong');
    });

    test('validates RIR in range (0-10)', () async {
      final result = await repository.logSet(
        '1',
        exerciseId: '2',
        setNumber: 1,
        targetRir: 12,
      );

      result.fold(
        (f) {
          expect(f, isA<ValidationFailure>());
          expect((f as ValidationFailure).details, contains('RIR must be 0–10'));
        },
        (_) => fail('expected Left'),
      );
    });

    test('validates duration seconds non-negative', () async {
      final result = await repository.logSet(
        '1',
        exerciseId: '2',
        setNumber: 1,
        targetDurationSeconds: -5,
      );

      result.fold(
        (f) {
          expect(f, isA<ValidationFailure>());
          expect(
            (f as ValidationFailure).details,
            contains('Duration seconds must be non-negative'),
          );
        },
        (_) => fail('expected Left'),
      );
    });
  });

  group('updateSet', () {
    test('sends only provided fields including RIR and duration', () async {
      when(
        () => remote.updateSet(any(), any(), any()),
      ).thenAnswer((_) async => _set());

      await repository.updateSet(
        '1',
        '1',
        reps: 8,
        targetRir: 2,
        actualRir: 1,
        targetDurationSeconds: 40,
        actualDurationSeconds: 45,
      );

      final captured = verify(
        () => remote.updateSet(any(), any(), captureAny()),
      ).captured;
      final update = captured[0] as api.WorkoutSetUpdate;
      expect(update.repsCompleted, 8);
      expect(update.targetRir, 2);
      expect(update.actualRir, 1);
      expect(update.targetDurationSeconds, 40);
      expect(update.actualDurationSeconds, 45);
      expect(update.weightLiftedKg, isNull);
      expect(update.rpeScore, isNull);
    });

    test('validates updated RIR in range (0-10)', () async {
      final result = await repository.updateSet('1', '1', actualRir: -1);

      result.fold(
        (f) => expect((f as ValidationFailure).details, contains('RIR must be 0–10')),
        (_) => fail('expected Left'),
      );
    });
  });

  group('completeSession', () {
    test('forwards multi-metric ratings, protocols, signatures, notes', () async {
      final signedAt = DateTime(2026, 3, 1, 11, 0);
      when(
        () => remote.completeSession(
          any(),
          notes: any(named: 'notes'),
          clientFeedbackRating: any(named: 'clientFeedbackRating'),
          effortRating: any(named: 'effortRating'),
          satisfactionRating: any(named: 'satisfactionRating'),
          painDiscomfortScore: any(named: 'painDiscomfortScore'),
          painNotes: any(named: 'painNotes'),
          trainerNotes: any(named: 'trainerNotes'),
          nextSessionPlan: any(named: 'nextSessionPlan'),
          sessionFocus: any(named: 'sessionFocus'),
          warmupProtocol: any(named: 'warmupProtocol'),
          cooldownProtocol: any(named: 'cooldownProtocol'),
          clientSigned: any(named: 'clientSigned'),
          trainerSigned: any(named: 'trainerSigned'),
          clientSignedAt: any(named: 'clientSignedAt'),
          trainerSignedAt: any(named: 'trainerSignedAt'),
        ),
      ).thenAnswer((_) async => _session());

      final result = await repository.completeSession(
        '1',
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
        clientSignedAt: signedAt,
        trainerSignedAt: signedAt,
      );

      verify(
        () => remote.completeSession(
          1,
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
          clientSignedAt: signedAt,
          trainerSignedAt: signedAt,
        ),
      ).called(1);

      expect(result.isRight(), isTrue);
    });

    test('validates effortRating range (1-10)', () async {
      final result = await repository.completeSession('1', effortRating: 11);
      result.fold(
        (f) => expect(
          (f as ValidationFailure).details,
          contains('Effort rating must be 1–10'),
        ),
        (_) => fail('expected Left'),
      );
    });

    test('validates satisfactionRating range (1-10)', () async {
      final result = await repository.completeSession('1', satisfactionRating: 0);
      result.fold(
        (f) => expect(
          (f as ValidationFailure).details,
          contains('Satisfaction rating must be 1–10'),
        ),
        (_) => fail('expected Left'),
      );
    });

    test('validates painDiscomfortScore range (0-10)', () async {
      final result = await repository.completeSession('1', painDiscomfortScore: 11);
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

      result.fold(
        (f) => fail('expected Right, got Left($f)'),
        (sessions) {
          expect(sessions.length, 1);
          expect(sessions.first.sessionId, '1');
          expect(sessions.first.sets.length, 1);
          expect(sessions.first.sets.first.notes, 'Solid reps');
        },
      );
    });
  });
}
