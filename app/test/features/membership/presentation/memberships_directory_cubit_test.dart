import 'package:app/features/membership/domain/entities/membership.dart';
import 'package:app/features/membership/domain/entities/membership_status.dart';
import 'package:app/features/membership/domain/usecases/get_memberships_usecase.dart';
import 'package:app/features/membership/presentation/cubit/memberships_directory_cubit.dart';
import 'package:app/core/error/failures.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetMemberships extends Mock implements GetMembershipsUseCase {}

void main() {
  late _MockGetMemberships getMemberships;

  setUp(() {
    getMemberships = _MockGetMemberships();
    registerFallbackValue(const GetMembershipsParams());
  });

  Membership membership({
    required String id,
    required MembershipStatus status,
    int daysUntilExpiry = 60,
  }) {
    final end = DateTime.now().add(Duration(days: daysUntilExpiry));
    return Membership(
      id: id,
      memberId: '1',
      productId: '10',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: end,
      remainingPtSessions: 0,
      status: status,
      rowVersion: 1,
    );
  }

  blocTest<MembershipsDirectoryCubit, MembershipsDirectoryState>(
    'loads memberships and applies expiring-soon client filter',
    build: () {
      when(() => getMemberships(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [
              membership(id: 'a', status: MembershipStatus.active, daysUntilExpiry: 5),
              membership(id: 'b', status: MembershipStatus.active, daysUntilExpiry: 90),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return MembershipsDirectoryCubit(getMemberships);
    },
    act: (cubit) => cubit.load(filter: MembershipDirectoryFilter.expiringSoon),
    expect: () => [
      isA<MembershipsDirectoryLoading>(),
      isA<MembershipsDirectoryLoaded>().having(
        (s) => s.items.map((m) => m.id).toList(),
        'ids',
        ['a'],
      ),
    ],
  );

  blocTest<MembershipsDirectoryCubit, MembershipsDirectoryState>(
    'emits failure on repository error',
    build: () {
      when(() => getMemberships(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );
      return MembershipsDirectoryCubit(getMemberships);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<MembershipsDirectoryLoading>(),
      isA<MembershipsDirectoryFailure>(),
    ],
  );
}
