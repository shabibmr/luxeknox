import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_items_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/items_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetItemsUseCase extends Mock implements GetItemsUseCase {}

void main() {
  late MockGetItemsUseCase mockGetItems;
  late ItemsCubit cubit;

  const tItem1 = Item(
    id: 1,
    name: 'Protein Bar',
    kind: 'goods',
    sku: 'PB-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '50.00',
    inventoryTracked: true,
    isActive: true,
  );

  const tItem2 = Item(
    id: 2,
    name: 'PT Session',
    kind: 'service',
    sku: 'PT-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '1500.00',
    inventoryTracked: false,
    isActive: false,
  );

  const tPage = CursorPage<Item>(
    items: [tItem1, tItem2],
    nextCursor: '2',
    hasMore: true,
  );

  const tLastPage = CursorPage<Item>(
    items: [tItem2],
    nextCursor: null,
    hasMore: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetItemsParams());
  });

  setUp(() {
    mockGetItems = MockGetItemsUseCase();
    cubit = ItemsCubit(
      mockGetItems,
      debounceDuration: const Duration(milliseconds: 50),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has default values', () {
    expect(cubit.state, const ItemsState());
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.items, isEmpty);
    expect(cubit.state.hasMore, isFalse);
    expect(cubit.state.offset, 0);
    expect(cubit.state.kind, isNull);
    expect(cubit.state.isActive, isNull);
    expect(cubit.state.inventoryTracked, isNull);
  });

  group('load', () {
    blocTest<ItemsCubit, ItemsState>(
      'emits [loading, success] on successful fetch',
      build: () {
        when(() => mockGetItems(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        const ItemsState(status: LoadStatus.loading),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem1, tItem2],
          offset: 2,
          hasMore: true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetItems(
            const GetItemsParams(limit: 50, offset: 0),
          ),
        ).called(1);
      },
    );

    blocTest<ItemsCubit, ItemsState>(
      'on error keeps the old list',
      build: () {
        when(() => mockGetItems(any())).thenAnswer(
          (_) async => const Left(BusinessRuleFailure('Server error')),
        );
        return cubit;
      },
      seed: () => const ItemsState(
        status: LoadStatus.success,
        items: [tItem1],
        offset: 1,
        hasMore: false,
      ),
      act: (c) => c.load(),
      expect: () => [
        const ItemsState(
          status: LoadStatus.loading,
          items: [tItem1],
          offset: 0,
          hasMore: false,
        ),
        const ItemsState(
          status: LoadStatus.failure,
          failure: BusinessRuleFailure('Server error'),
          items: [tItem1],
          offset: 0,
          hasMore: false,
        ),
      ],
    );
  });

  group('loadMore', () {
    blocTest<ItemsCubit, ItemsState>(
      'appends items on load-more',
      build: () {
        when(
          () => mockGetItems(
            const GetItemsParams(limit: 50, offset: 1),
          ),
        ).thenAnswer((_) async => const Right(tLastPage));
        return cubit;
      },
      seed: () => const ItemsState(
        status: LoadStatus.success,
        items: [tItem1],
        offset: 1,
        hasMore: true,
      ),
      act: (c) => c.loadMore(),
      expect: () => [
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem1],
          offset: 1,
          hasMore: true,
          isLoadingMore: true,
        ),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem1, tItem2],
          offset: 2,
          hasMore: false,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<ItemsCubit, ItemsState>(
      'does nothing when hasMore is false',
      build: () => cubit,
      seed: () => const ItemsState(
        status: LoadStatus.success,
        items: [tItem1],
        hasMore: false,
      ),
      act: (c) => c.loadMore(),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetItems(any()));
      },
    );
  });

  group('search', () {
    blocTest<ItemsCubit, ItemsState>(
      'search re-queries from offset 0 after debounce',
      build: () {
        when(() => mockGetItems(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      seed: () => const ItemsState(
        status: LoadStatus.success,
        items: [tItem1],
        offset: 1,
        hasMore: false,
      ),
      act: (c) async {
        c.searchItems('Protein');
        await Future<void>.delayed(const Duration(milliseconds: 80));
      },
      expect: () => [
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem1],
          offset: 1,
          hasMore: false,
          search: 'Protein',
        ),
        const ItemsState(
          status: LoadStatus.loading,
          items: [tItem1],
          offset: 0,
          hasMore: false,
          search: 'Protein',
        ),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem1, tItem2],
          offset: 2,
          hasMore: true,
          search: 'Protein',
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetItems(
            const GetItemsParams(
              limit: 50,
              offset: 0,
              search: 'Protein',
            ),
          ),
        ).called(1);
      },
    );

    test('rapid searchItems only fires one query after debounce', () async {
      when(() => mockGetItems(any()))
          .thenAnswer((_) async => const Right(tLastPage));

      cubit.searchItems('P');
      cubit.searchItems('Pr');
      cubit.searchItems('Pro');

      expect(cubit.state.search, 'Pro');
      verifyNever(() => mockGetItems(any()));

      await Future<void>.delayed(const Duration(milliseconds: 80));

      verify(
        () => mockGetItems(
          const GetItemsParams(
            limit: 50,
            offset: 0,
            search: 'Pro',
          ),
        ),
      ).called(1);
    });
  });

  group('filters', () {
    blocTest<ItemsCubit, ItemsState>(
      'filterByKind resets page to offset 0',
      build: () {
        when(() => mockGetItems(any()))
            .thenAnswer((_) async => const Right(tLastPage));
        return cubit;
      },
      seed: () => const ItemsState(
        status: LoadStatus.success,
        items: [tItem1, tItem2],
        offset: 2,
        hasMore: true,
      ),
      act: (c) => c.filterByKind('goods'),
      expect: () => [
        const ItemsState(
          status: LoadStatus.loading,
          items: [tItem1, tItem2],
          offset: 0,
          hasMore: true,
          kind: 'goods',
        ),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem2],
          offset: 1,
          hasMore: false,
          kind: 'goods',
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetItems(
            const GetItemsParams(
              limit: 50,
              offset: 0,
              kind: 'goods',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ItemsCubit, ItemsState>(
      'filterByActive resets page to offset 0',
      build: () {
        when(() => mockGetItems(any()))
            .thenAnswer((_) async => const Right(tLastPage));
        return cubit;
      },
      act: (c) => c.filterByActive(true),
      expect: () => [
        const ItemsState(
          status: LoadStatus.loading,
          isActive: true,
        ),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem2],
          offset: 1,
          hasMore: false,
          isActive: true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetItems(
            const GetItemsParams(
              limit: 50,
              offset: 0,
              isActive: true,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ItemsCubit, ItemsState>(
      'filterByTracked resets page to offset 0',
      build: () {
        when(() => mockGetItems(any()))
            .thenAnswer((_) async => const Right(tLastPage));
        return cubit;
      },
      act: (c) => c.filterByTracked(true),
      expect: () => [
        const ItemsState(
          status: LoadStatus.loading,
          inventoryTracked: true,
        ),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem2],
          offset: 1,
          hasMore: false,
          inventoryTracked: true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetItems(
            const GetItemsParams(
              limit: 50,
              offset: 0,
              inventoryTracked: true,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ItemsCubit, ItemsState>(
      'clearFilters resets search and all filters',
      build: () {
        when(() => mockGetItems(any()))
            .thenAnswer((_) async => const Right(tPage));
        return cubit;
      },
      seed: () => const ItemsState(
        search: 'Old',
        kind: 'goods',
        isActive: true,
        inventoryTracked: false,
      ),
      act: (c) => c.clearFilters(),
      expect: () => [
        const ItemsState(status: LoadStatus.loading),
        const ItemsState(
          status: LoadStatus.success,
          items: [tItem1, tItem2],
          offset: 2,
          hasMore: true,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetItems(
            const GetItemsParams(limit: 50, offset: 0),
          ),
        ).called(1);
      },
    );
  });
}
