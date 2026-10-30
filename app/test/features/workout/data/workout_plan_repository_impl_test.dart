import 'package:api_client/api_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/workout/data/datasources/workout_plan_remote_datasource.dart';
import 'package:luxeknox/features/workout/data/repositories/workout_plan_repository_impl.dart';
import 'package:luxeknox/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements WorkoutPlanRemoteDataSource {}

api.WorkoutPlan _samplePlan({int id = 10}) {
  return api.WorkoutPlan(
    (b) => b
      ..id = id
      ..title = 'Sample Plan'
      ..isTemplate = false
      ..status = api.WorkoutPlanStatusEnum.active
      ..rowVersion = 1
      ..primaryObjective12w = 'Bench 100kg'
      ..milestone4w = 'Bench 85kg'
      ..sessionsPerWeek = 4
      ..targetSessionDurationMinutes = 60
      ..splitType = 'Upper / Lower'
      ..cardioProtocol = 'Zone 2 30m'
      ..mobilityProtocol = 'Hip mobility'
      ..progressionMethods.replace([api.WorkoutPlanProgressionMethodsEnum.load])
      ..mainSuccessMeasure = '1RM Bench'
      ..trainerProgrammingNotes = 'Warmup thoroughly',
  );
}

void main() {
  late MockRemote remote;
  late WorkoutPlanRepository repository;

  setUpAll(() {
    registerFallbackValue(api.WorkoutPlanWrite((b) => b..title = 'fallback'));
  });

  setUp(() {
    remote = MockRemote();
    repository = WorkoutPlanRepositoryImpl(remote);
  });

  group('WorkoutPlanRepositoryImpl blueprint support', () {
    test('createPlan forwards blueprint fields to remote data source', () async {
      when(() => remote.createPlan(any())).thenAnswer((_) async => _samplePlan());

      final result = await repository.createPlan(
        title: 'New Program',
        primaryObjective12w: 'Bench 100kg',
        milestone4w: 'Bench 85kg',
        sessionsPerWeek: 4,
        targetSessionDurationMinutes: 60,
        splitType: 'Upper / Lower',
        cardioProtocol: 'Zone 2 30m',
        mobilityProtocol: 'Hip mobility',
        progressionMethods: ['load'],
        mainSuccessMeasure: '1RM Bench',
        trainerProgrammingNotes: 'Warmup thoroughly',
      );

      final captured = verify(() => remote.createPlan(captureAny())).captured;
      final write = captured.first as api.WorkoutPlanWrite;
      expect(write.title, 'New Program');
      expect(write.primaryObjective12w, 'Bench 100kg');
      expect(write.milestone4w, 'Bench 85kg');
      expect(write.sessionsPerWeek, 4);
      expect(write.targetSessionDurationMinutes, 60);
      expect(write.splitType, 'Upper / Lower');
      expect(write.cardioProtocol, 'Zone 2 30m');
      expect(write.mobilityProtocol, 'Hip mobility');
      expect(
        write.progressionMethods?.map((e) => e.name).toList(),
        ['load'],
      );
      expect(write.mainSuccessMeasure, '1RM Bench');
      expect(write.trainerProgrammingNotes, 'Warmup thoroughly');

      result.fold(
        (f) => fail('expected Right, got $f'),
        (plan) {
          expect(plan.id, '10');
          expect(plan.primaryObjective12w, 'Bench 100kg');
          expect(plan.sessionsPerWeek, 4);
        },
      );
    });

    test('updatePlan forwards blueprint fields and rowVersion', () async {
      when(() => remote.updatePlan(any(), any()))
          .thenAnswer((_) async => _samplePlan(id: 15));

      final result = await repository.updatePlan(
        '15',
        rowVersion: 3,
        title: 'Updated Plan',
        primaryObjective12w: 'Squat 140kg',
        sessionsPerWeek: 3,
        targetSessionDurationMinutes: 75,
      );

      final captured =
          verify(() => remote.updatePlan(15, captureAny())).captured;
      final write = captured.first as api.WorkoutPlanWrite;
      expect(write.title, 'Updated Plan');
      expect(write.rowVersion, 3);
      expect(write.primaryObjective12w, 'Squat 140kg');
      expect(write.sessionsPerWeek, 3);
      expect(write.targetSessionDurationMinutes, 75);

      result.fold(
        (f) => fail('expected Right, got $f'),
        (plan) => expect(plan.id, '15'),
      );
    });

    test('validates sessionsPerWeek range (1-14)', () async {
      final result = await repository.createPlan(
        title: 'Invalid Frequency',
        sessionsPerWeek: 15,
      );

      result.fold(
        (f) {
          expect(f, isA<ValidationFailure>());
          expect((f as ValidationFailure).details, contains('Sessions per week must be 1–14'));
        },
        (_) => fail('expected Left'),
      );
      verifyNever(() => remote.createPlan(any()));
    });

    test('validates targetSessionDurationMinutes range (15-180)', () async {
      final result = await repository.createPlan(
        title: 'Too Short',
        targetSessionDurationMinutes: 10,
      );

      result.fold(
        (f) {
          expect(f, isA<ValidationFailure>());
          expect(
            (f as ValidationFailure).details,
            contains('Session duration must be 15–180 minutes'),
          );
        },
        (_) => fail('expected Left'),
      );
      verifyNever(() => remote.createPlan(any()));
    });
  });
}
