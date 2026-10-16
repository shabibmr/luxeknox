import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_item_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/cubit/item_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetItemUseCase extends Mock implements GetItemUseCase {}

void main() {
  late MockGetItemUseCase mockGetItem;

  const tCached = Item(
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

  const tFresh = Item(
    id: 1,
    name: 'Protein Bar',
    kind: 'goods',
    sku: 'PB-001',
    uomId: 10,
    uomCode: 'PCS',
    uomDecimalPlaces: 0,
    incomeAccountId: 100,
    expenseAccountId: 200,
    saleRate: '55.00',
    inventoryTracked: true,
    isActive: true,
  );

  setUp(() {
    mockGetItem = MockGetItemUseCase();
  });

  blocTest<ItemDetailCubit, ItemDetailState>(
    'emits the initial item before the fetch resolves, then the fresh item',
    build: () {
      when(() => mockGetItem(1)).thenAnswer((_) async => Right(tFresh));
      return ItemDetailCubit(mockGetItem);
    },
    act: (cubit) => cubit.load(1, initialItem: tCached),
    expect: () => [
      const ItemDetailState(status: LoadStatus.success, item: tCached),
      const ItemDetailState(status: LoadStatus.success, item: tFresh),
    ],
  );

  blocTest<ItemDetailCubit, ItemDetailState>(
    'keeps the cached item and sets a failure when the refresh fails',
    build: () {
      when(() => mockGetItem(1)).thenAnswer(
        (_) async => const Left(BusinessRuleFailure('boom')),
      );
      return ItemDetailCubit(mockGetItem);
    },
    act: (cubit) => cubit.load(1, initialItem: tCached),
    expect: () => [
      const ItemDetailState(status: LoadStatus.success, item: tCached),
      const ItemDetailState(
        status: LoadStatus.failure,
        item: tCached,
        failure: BusinessRuleFailure('boom'),
      ),
    ],
  );

  blocTest<ItemDetailCubit, ItemDetailState>(
    'without an initial item emits loading then success',
    build: () {
      when(() => mockGetItem(1)).thenAnswer((_) async => Right(tFresh));
      return ItemDetailCubit(mockGetItem);
    },
    act: (cubit) => cubit.load(1),
    expect: () => [
      const ItemDetailState(status: LoadStatus.loading),
      const ItemDetailState(status: LoadStatus.success, item: tFresh),
    ],
  );
}
