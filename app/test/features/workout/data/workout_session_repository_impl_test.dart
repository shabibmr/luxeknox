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

  group('updateSet', () {
    test('sends only provided fields', () async {
      when(
        () => remote.updateSet(any(), any(), any()),
      ).thenAnswer((_) async => _set());

      await repository.updateSet('1', '1', reps: 8);

      final captured = verify(
        () => remote.updateSet(any(), any(), captureAny()),
      ).captured;
      final update = captured[0] as api.WorkoutSetUpdate;
      expect(update.repsCompleted, 8);
      expect(update.weightLiftedKg, isNull);
      expect(update.rpeScore, isNull);
      expect(update.isCompleted, isNull);
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
}
