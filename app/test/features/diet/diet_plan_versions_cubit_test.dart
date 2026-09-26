import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/diet/domain/entities/diet_plan_version.dart';
import 'package:luxeknox/features/diet/domain/usecases/list_diet_plan_versions_usecase.dart';
import 'package:luxeknox/features/diet/presentation/cubit/diet_plan_versions_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockListVersions extends Mock implements ListDietPlanVersionsUseCase {}

void main() {
  late _MockListVersions listVersions;

  DietPlanVersion version({
    required String id,
    int number = 1,
  }) {
    return DietPlanVersion(
      id: id,
      dietPlanId: '1',
      versionNumber: number,
      changelog: 'v$number changelog',
    );
  }

  setUp(() {
    listVersions = _MockListVersions();
  });

  blocTest<DietPlanVersionsCubit, DietPlanVersionsState>(
    'loads versions',
    build: () {
      when(() => listVersions('1')).thenAnswer(
        (_) async => Right([
          version(id: 'v1', number: 1),
          version(id: 'v2', number: 2),
        ]),
      );
      return DietPlanVersionsCubit(listVersions);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<DietPlanVersionsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<DietPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.versions.length, 'count', 2),
    ],
  );

  blocTest<DietPlanVersionsCubit, DietPlanVersionsState>(
    'toggles expanded version',
    build: () {
      when(() => listVersions('1')).thenAnswer(
        (_) async => Right([version(id: 'v1')]),
      );
      return DietPlanVersionsCubit(listVersions);
    },
    act: (cubit) async {
      await cubit.load('1');
      cubit.toggleExpanded('v1');
      cubit.toggleExpanded('v1');
    },
    expect: () => [
      isA<DietPlanVersionsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<DietPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.expandedId, 'expanded', isNull),
      isA<DietPlanVersionsState>()
          .having((s) => s.expandedId, 'expanded', 'v1'),
      isA<DietPlanVersionsState>()
          .having((s) => s.expandedId, 'expanded', isNull),
    ],
  );

  blocTest<DietPlanVersionsCubit, DietPlanVersionsState>(
    'load failure',
    build: () {
      when(() => listVersions('1')).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return DietPlanVersionsCubit(listVersions);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<DietPlanVersionsState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<DietPlanVersionsState>()
          .having((s) => s.status, 'status', LoadStatus.failure)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>())
          .having((s) => s.versions, 'versions', isEmpty),
    ],
  );
}
