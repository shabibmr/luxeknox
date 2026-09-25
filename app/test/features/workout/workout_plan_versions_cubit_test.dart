import 'package:app/core/error/failures.dart';
import 'package:app/core/presentation/load_status.dart';
import 'package:app/features/workout/domain/entities/workout_plan_version.dart';
import 'package:app/features/workout/domain/usecases/list_workout_plan_versions_usecase.dart';
import 'package:app/features/workout/presentation/cubit/workout_plan_versions_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListVersions extends Mock
    implements ListWorkoutPlanVersionsUseCase {}

void main() {
  late _MockListVersions listVersions;

  WorkoutPlanVersion version({
    required String id,
    int number = 1,
  }) {
    return WorkoutPlanVersion(
      id: id,
      planId: '1',
      versionNumber: number,
      changelog: 'v$number',
    );
  }

  setUp(() {
    listVersions = _MockListVersions();
  });

  blocTest<WorkoutPlanVersionsCubit, WorkoutPlanVersionsState>(
    'loads versions',
    build: () {
      when(() => listVersions('1')).thenAnswer(
        (_) async => Right([
          version(id: 'v1', number: 1),
          version(id: 'v2', number: 2),
        ]),
      );
      return WorkoutPlanVersionsCubit(listVersions);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<WorkoutPlanVersionsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<WorkoutPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.versions.length, 'count', 2),
    ],
  );

  blocTest<WorkoutPlanVersionsCubit, WorkoutPlanVersionsState>(
    'toggles expanded version',
    build: () {
      when(() => listVersions('1')).thenAnswer(
        (_) async => Right([version(id: 'v1')]),
      );
      return WorkoutPlanVersionsCubit(listVersions);
    },
    act: (cubit) async {
      await cubit.load('1');
      cubit.toggleExpanded('v1');
      cubit.toggleExpanded('v1');
    },
    expect: () => [
      isA<WorkoutPlanVersionsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<WorkoutPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.expandedId, 'expanded', isNull),
      isA<WorkoutPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.expandedId, 'expanded', 'v1'),
      isA<WorkoutPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.expandedId, 'expanded', isNull),
    ],
  );

  blocTest<WorkoutPlanVersionsCubit, WorkoutPlanVersionsState>(
    'load failure',
    build: () {
      when(() => listVersions('1')).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return WorkoutPlanVersionsCubit(listVersions);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<WorkoutPlanVersionsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<WorkoutPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );
}
