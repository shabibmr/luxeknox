import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_vendors_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/vendors_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVendorsUseCase extends Mock implements GetVendorsUseCase {}

void main() {
  late MockGetVendorsUseCase mockGetVendors;
  late VendorsCubit cubit;

  const tVendor1 = Vendor(
    id: 'v-1',
    name: 'Acme Fitness Equipments',
    phone: '+1 555-0100',
    contactEmail: 'contact@acme.com',
    taxNumber: 'GSTIN-12345',
    isActive: true,
  );

  const tVendor2 = Vendor(
    id: 'v-2',
    name: 'Beverage Suppliers Ltd',
    phone: '+1 555-0200',
    contactEmail: 'orders@beverages.com',
    taxNumber: 'GSTIN-67890',
    isActive: false,
  );

  const tPage = CursorPage<Vendor>(
    items: [tVendor1, tVendor2],
    nextCursor: 'cur-2',
    hasMore: true,
  );

  const tLastPage = CursorPage<Vendor>(
    items: [tVendor2],
    nextCursor: null,
    hasMore: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetVendorsParams());
  });

  setUp(() {
    mockGetVendors = MockGetVendorsUseCase();
    cubit = VendorsCubit(mockGetVendors, debounceDuration: Duration.zero);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default values', () {
    expect(cubit.state, const VendorsState());
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.vendors, isEmpty);
    expect(cubit.state.hasReachedMax, isFalse);
    expect(cubit.state.offset, 0);
  });

  group('load', () {
    blocTest<VendorsCubit, VendorsState>(
      'emits [loading, success] on successful fetch',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const VendorsState(
          status: LoadStatus.loading,
          vendors: [],
          offset: 0,
          hasReachedMax: false,
        ),
        const VendorsState(
          status: LoadStatus.success,
          vendors: [tVendor1, tVendor2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<VendorsCubit, VendorsState>(
      'emits [loading, failure] when use case returns failure',
      build: () {
        when(() => mockGetVendors(any())).thenAnswer(
            (_) async => const Left(BusinessRuleFailure('Server error')));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const VendorsState(
          status: LoadStatus.loading,
          vendors: [],
          offset: 0,
        ),
        const VendorsState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Server error'),
          vendors: [],
          offset: 0,
        ),
      ],
    );

    blocTest<VendorsCubit, VendorsState>(
      'sets hasReachedMax to true when hasMore is false',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tLastPage));
        return cubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const VendorsState(
          status: LoadStatus.loading,
          vendors: [],
          offset: 0,
        ),
        const VendorsState(
          status: LoadStatus.success,
          vendors: [tVendor2],
          offset: 1,
          hasReachedMax: true,
        ),
      ],
    );
  });

  group('loadNextPage', () {
    blocTest<VendorsCubit, VendorsState>(
      'appends new items on pagination',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tLastPage));
        return cubit;
      },
      seed: () => const VendorsState(
        status: LoadStatus.success,
        vendors: [tVendor1],
        offset: 1,
        hasReachedMax: false,
      ),
      act: (cubit) => cubit.loadNextPage(),
      expect: () => [
        const VendorsState(
          status: LoadStatus.loading,
          vendors: [tVendor1],
          offset: 1,
          hasReachedMax: false,
        ),
        const VendorsState(
          status: LoadStatus.success,
          vendors: [tVendor1, tVendor2],
          offset: 2,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<VendorsCubit, VendorsState>(
      'does nothing when hasReachedMax is true',
      build: () => cubit,
      seed: () => const VendorsState(
        status: LoadStatus.success,
        vendors: [tVendor1],
        hasReachedMax: true,
      ),
      act: (cubit) => cubit.loadNextPage(),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetVendors(any()));
      },
    );
  });

  group('filters and search', () {
    blocTest<VendorsCubit, VendorsState>(
      'searchVendors re-queries from offset 0 after debounce',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      seed: () => const VendorsState(
        status: LoadStatus.success,
        vendors: [tVendor1],
        offset: 1,
        hasReachedMax: false,
      ),
      act: (cubit) async {
        cubit.searchVendors('Acme');
        await Future<void>.delayed(const Duration(milliseconds: 80));
      },
      expect: () => [
        const VendorsState(
          status: LoadStatus.success,
          vendors: [tVendor1],
          offset: 1,
          hasReachedMax: false,
          search: 'Acme',
        ),
        const VendorsState(
          status: LoadStatus.loading,
          search: 'Acme',
          vendors: [],
          offset: 0,
          hasReachedMax: false,
        ),
        const VendorsState(
          status: LoadStatus.success,
          search: 'Acme',
          vendors: [tVendor1, tVendor2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetVendors(
              const GetVendorsParams(
                limit: 50,
                offset: 0,
                search: 'Acme',
                isActive: null,
              ),
            )).called(1);
      },
    );

    test('rapid searchVendors only fires one query after debounce', () async {
      final debounced = VendorsCubit(
        mockGetVendors,
        debounceDuration: const Duration(milliseconds: 50),
      );
      when(() => mockGetVendors(any()))
          .thenAnswer((_) async => const Right(tLastPage));

      debounced.searchVendors('A');
      debounced.searchVendors('Ac');
      debounced.searchVendors('Acme');

      expect(debounced.state.search, 'Acme');
      verifyNever(() => mockGetVendors(any()));

      await Future<void>.delayed(const Duration(milliseconds: 80));

      verify(() => mockGetVendors(
            const GetVendorsParams(
              limit: 50,
              offset: 0,
              search: 'Acme',
              isActive: null,
            ),
          )).called(1);
      await debounced.close();
    });

    test('discards stale search response when a newer load completes first',
        () async {
      final slow =
          Completer<Either<Failure, CursorPage<Vendor>>>();
      const newerPage = CursorPage<Vendor>(
        items: [tVendor1],
        nextCursor: null,
        hasMore: false,
      );
      var calls = 0;
      when(() => mockGetVendors(any())).thenAnswer((_) {
        calls++;
        return calls == 1 ? slow.future : Future.value(const Right(newerPage));
      });

      cubit.searchVendors('Old');
      await Future<void>.delayed(const Duration(milliseconds: 80));

      cubit.searchVendors('New');
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(cubit.state.search, 'New');
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.vendors, [tVendor1]);

      slow.complete(const Right(tPage));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.search, 'New');
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.vendors, [tVendor1]);
      expect(calls, 2);
    });

    blocTest<VendorsCubit, VendorsState>(
      'setSearch alias triggers reload with search string',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.setSearch('Acme'),
      expect: () => [
        const VendorsState(
          search: 'Acme',
        ),
        const VendorsState(
          status: LoadStatus.loading,
          search: 'Acme',
          vendors: [],
          offset: 0,
        ),
        const VendorsState(
          status: LoadStatus.success,
          search: 'Acme',
          vendors: [tVendor1, tVendor2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
    );

    test('rapid searchVendors with real debounce only fires latest query', () async {
      final debouncedCubit = VendorsCubit(
        mockGetVendors,
        debounceDuration: const Duration(milliseconds: 50),
      );
      when(() => mockGetVendors(any()))
          .thenAnswer((_) async => const Right(tPage));

      debouncedCubit.searchVendors('A');
      debouncedCubit.searchVendors('Ac');
      debouncedCubit.searchVendors('Acme');

      expect(debouncedCubit.state.search, 'Acme');
      verifyNever(() => mockGetVendors(any()));

      await Future<void>.delayed(const Duration(milliseconds: 70));

      verify(
        () => mockGetVendors(
          const GetVendorsParams(
            limit: 50,
            offset: 0,
            search: 'Acme',
            isActive: null,
          ),
        ),
      ).called(1);

      await debouncedCubit.close();
    });

    blocTest<VendorsCubit, VendorsState>(
      'filterByActive triggers reload with isActive true',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      act: (cubit) => cubit.filterByActive(true),
      expect: () => [
        const VendorsState(
          status: LoadStatus.loading,
          isActive: true,
          vendors: [],
          offset: 0,
        ),
        const VendorsState(
          status: LoadStatus.success,
          isActive: true,
          vendors: [tVendor1, tVendor2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetVendors(
              const GetVendorsParams(
                limit: 50,
                offset: 0,
                search: null,
                isActive: true,
              ),
            )).called(1);
      },
    );

    blocTest<VendorsCubit, VendorsState>(
      'clearFilters resets both search and isActive',
      build: () {
        when(() => mockGetVendors(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      seed: () => const VendorsState(
        search: 'OldQuery',
        isActive: true,
      ),
      act: (cubit) => cubit.clearFilters(),
      expect: () => [
        const VendorsState(
          status: LoadStatus.loading,
          search: null,
          isActive: null,
          vendors: [],
          offset: 0,
        ),
        const VendorsState(
          status: LoadStatus.success,
          search: null,
          isActive: null,
          vendors: [tVendor1, tVendor2],
          offset: 2,
          hasReachedMax: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetVendors(
              const GetVendorsParams(
                limit: 50,
                offset: 0,
                search: null,
                isActive: null,
              ),
            )).called(1);
      },
    );
  });

  test('copyWith supports setting and clearing nullable values', () {
    const s1 = VendorsState(
      search: 'term',
      isActive: true,
      failure: BusinessRuleFailure('err'),
    );

    final s2 = s1.copyWith(
      search: null,
      isActive: null,
      failure: null,
    );

    expect(s2.search, isNull);
    expect(s2.isActive, isNull);
    expect(s2.failure, isNull);
  });
}
