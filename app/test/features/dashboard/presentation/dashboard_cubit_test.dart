import 'package:app/core/error/failures.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDashboardUseCase extends Mock implements GetDashboardUseCase {}

void main() {
  late MockGetDashboardUseCase mockUseCase;

  const tSnapshot = DashboardSnapshot(
    role: UserType.member,
    member: DashboardMemberWidget(
      membership: DashboardMembershipSummary(
        status: 'active',
        endDate: '2026-10-01',
        daysRemaining: 10,
      ),
    ),
  );

  const tSnapshot2 = DashboardSnapshot(
    role: UserType.member,
    member: DashboardMemberWidget(
      membership: DashboardMembershipSummary(
        status: 'active',
        endDate: '2026-10-01',
        daysRemaining: 9,
      ),
    ),
  );

  setUp(() {
    mockUseCase = MockGetDashboardUseCase();
    registerFallbackValue(const NoParams());
  });

  group('DashboardCubit', () {
    test('initial state has initial status and no snapshot', () {
      final cubit = DashboardCubit(mockUseCase);
      expect(cubit.state.status, DashboardStatus.initial);
      expect(cubit.state.snapshot, isNull);
    });

    blocTest<DashboardCubit, DashboardState>(
      'load() with no prior data emits [loading, success] (DSH-001/002)',
      build: () {
        when(
          () => mockUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right(tSnapshot));
        return DashboardCubit(mockUseCase);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        const DashboardState(
          status: DashboardStatus.success,
          snapshot: tSnapshot,
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'load() failure with no prior data emits [loading, failure]',
      build: () {
        when(
          () => mockUseCase(const NoParams()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return DashboardCubit(mockUseCase);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const DashboardState(status: DashboardStatus.loading),
        const DashboardState(
          status: DashboardStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'refresh() with existing data emits [refreshing, success] not [loading, ...] '
      '(DSH-006/section-loading)',
      build: () {
        when(
          () => mockUseCase(const NoParams()),
        ).thenAnswer((_) async => const Right(tSnapshot2));
        return DashboardCubit(mockUseCase);
      },
      seed: () => const DashboardState(
        status: DashboardStatus.success,
        snapshot: tSnapshot,
      ),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        const DashboardState(
          status: DashboardStatus.refreshing,
          snapshot: tSnapshot,
        ),
        const DashboardState(
          status: DashboardStatus.success,
          snapshot: tSnapshot2,
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'a failed refresh keeps the last successful snapshot visible '
      '(cache-last-successful)',
      build: () {
        when(
          () => mockUseCase(const NoParams()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return DashboardCubit(mockUseCase);
      },
      seed: () => const DashboardState(
        status: DashboardStatus.success,
        snapshot: tSnapshot,
      ),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        const DashboardState(
          status: DashboardStatus.refreshing,
          snapshot: tSnapshot,
        ),
        const DashboardState(
          status: DashboardStatus.failure,
          snapshot: tSnapshot,
          failure: NetworkFailure(),
        ),
      ],
      verify: (cubit) {
        // The stale snapshot is still there for the UI to render behind a banner.
        expect(cubit.state.hasData, isTrue);
      },
    );
  });
}
