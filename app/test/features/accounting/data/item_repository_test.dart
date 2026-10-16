import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/network/error_interceptor.dart';
import 'package:luxeknox/features/accounting/data/datasources/accounting_remote_datasource.dart';
import 'package:luxeknox/features/accounting/data/models/accounting_mappers.dart';
import 'package:luxeknox/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:luxeknox/features/accounting/domain/entities/item.dart';
import 'package:mocktail/mocktail.dart';

class MockDataSource extends Mock implements AccountingRemoteDataSource {}

api.InventoryItem _invItem({
  int id = 7,
  bool tracked = false,
  String? sku = 'SKU-1',
}) => api.InventoryItem(
  (b) => b
    ..id = id
    ..name = 'Whey'
    ..sku = sku
    ..itemKind = api.ItemKind.goods
    ..uomId = 2
    ..uomCode = 'KG'
    ..uomDecimalPlaces = 3
    ..saleRate = '100.00'
    ..incomeAccountId = 10
    ..expenseAccountId = 11
    ..inventoryAccountId = tracked ? 12 : null
    ..cogsAccountId = tracked ? 13 : null
    ..inventoryTracked = tracked
    ..hasMovements = tracked
    ..isActive = true
    ..rowVersion = 3
    ..createdAt = DateTime.utc(2026, 1, 1),
);

api.PageMeta _meta({bool hasMore = false}) => api.PageMeta(
  (b) => b
    ..limit = 20
    ..offset = 0
    ..total = 1
    ..hasMore = hasMore,
);

api.Item _written(int id) => api.Item(
  (b) => b
    ..id = id
    ..name = 'Whey'
    ..itemKind = api.ItemKind.goods
    ..uomId = 2
    ..inventoryTracked = false
    ..incomeAccountId = 10
    ..expenseAccountId = 11
    ..isActive = true
    ..rowVersion = 1
    ..createdAt = DateTime.utc(2026, 1, 1),
);

const _draft = ItemDraft(
  name: ' Whey ',
  kind: 'goods',
  uomId: 2,
  incomeAccountId: 10,
  expenseAccountId: 11,
);

DioException _unprocessable() {
  final req = RequestOptions(path: '/accounting/items');
  final dio = DioException(requestOptions: req);
  return DioException(
    requestOptions: req,
    error: FailureDioException(
      const BusinessRuleFailure('Tracking is locked'),
      dio,
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_fakeCreate());
    registerFallbackValue(api.ItemUpdate((b) => b..name = 'x'));
  });

  group('item mappers', () {
    test('blank SKU and HSN become null; rates are fixed to 2 decimals', () {
      final out = toItemCreate(
        const ItemDraft(
          name: ' Whey ',
          kind: 'goods',
          uomId: 2,
          incomeAccountId: 10,
          expenseAccountId: 11,
          sku: '  ',
          hsnSac: '',
          saleRate: '12.5',
          purchaseRate: '',
          reorderLevel: '4',
        ),
      );
      expect(out.name, 'Whey');
      expect(out.sku, isNull);
      expect(out.hsnSac, isNull);
      expect(out.saleRate, '12.50');
      expect(out.purchaseRate, isNull);
      expect(out.reorderLevel, '4.000');
    });

    test('non-numeric rate is passed through for server validation', () {
      final out = toItemCreate(
        const ItemDraft(
          name: 'x',
          kind: 'service',
          uomId: 1,
          incomeAccountId: 1,
          expenseAccountId: 2,
          saleRate: 'abc',
        ),
      );
      expect(out.saleRate, 'abc');
      expect(out.itemKind, api.ItemKind.service);
    });

    test('tracked draft keeps inventory and COGS account ids', () {
      const d = ItemDraft(
        name: 'x',
        kind: 'goods',
        uomId: 1,
        incomeAccountId: 1,
        expenseAccountId: 2,
        inventoryTracked: true,
        inventoryAccountId: 12,
        cogsAccountId: 13,
      );
      final c = toItemCreate(d);
      final u = toItemUpdate(d);
      expect(c.inventoryTracked, isTrue);
      expect(c.inventoryAccountId, 12);
      expect(c.cogsAccountId, 13);
      expect(u.inventoryAccountId, 12);
      expect(u.cogsAccountId, 13);
    });

    test('InventoryItem maps to domain', () {
      final item = _invItem(tracked: true).toDomain();
      expect(item.id, 7);
      expect(item.kind, 'goods');
      expect(item.uomCode, 'KG');
      expect(item.uomDecimalPlaces, 3);
      expect(item.inventoryAccountId, 12);
      expect(item.hasMovements, isTrue);
      expect(item.rowVersion, 3);
    });

    test('root category with null parent maps', () {
      final c = api.ItemCategory(
        (b) => b
          ..id = 1
          ..name = 'Supplements'
          ..isActive = true,
      ).toDomain();
      expect(c.parentId, isNull);
    });
  });

  group('item repository', () {
    late MockDataSource ds;
    late AccountingRepositoryImpl repo;

    setUp(() {
      ds = MockDataSource();
      repo = AccountingRepositoryImpl(ds);
    });

    void stubList(api.InventoryItemPage page) {
      when(
        () => ds.listItems(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          itemKind: any(named: 'itemKind'),
          categoryId: any(named: 'categoryId'),
          isActive: any(named: 'isActive'),
          inventoryTracked: any(named: 'inventoryTracked'),
          search: any(named: 'search'),
        ),
      ).thenAnswer((_) async => page);
    }

    test('getItems maps a page', () async {
      stubList(
        api.InventoryItemPage(
          (b) => b
            ..data.replace([_invItem()])
            ..meta.replace(_meta()),
        ),
      );
      final r = await repo.getItems(limit: 20, kind: 'goods');
      final page = r.getOrElse((_) => fail('expected right'));
      expect(page.items.single.name, 'Whey');
      expect(page.hasMore, isFalse);
      verify(
        () => ds.listItems(
          limit: 20,
          offset: null,
          itemKind: api.ItemKind.goods,
          categoryId: null,
          isActive: null,
          inventoryTracked: null,
          search: null,
        ),
      ).called(1);
    });

    test('getItems returns an empty page', () async {
      stubList(
        api.InventoryItemPage(
          (b) => b
            ..data.replace([])
            ..meta.replace(_meta()),
        ),
      );
      final r = await repo.getItems();
      expect(r.getOrElse((_) => fail('expected right')).items, isEmpty);
    });

    test('createItem writes then re-reads the saved row', () async {
      when(() => ds.createItem(any())).thenAnswer((_) async => _written(7));
      when(() => ds.getItem(7)).thenAnswer((_) async => _invItem());
      final r = await repo.createItem(_draft);
      expect(r.getOrElse((_) => fail('expected right')).uomCode, 'KG');
      verify(() => ds.getItem(7)).called(1);
    });

    test('updateItem maps a 422 business_rule failure', () async {
      when(
        () => ds.updateItem(
          id: any(named: 'id'),
          itemUpdate: any(named: 'itemUpdate'),
        ),
      ).thenThrow(_unprocessable());
      final r = await repo.updateItem(7, _draft);
      expect(r.isLeft(), isTrue);
      r.fold((f) {
        expect(f, isA<BusinessRuleFailure>());
        expect((f as BusinessRuleFailure).message, 'Tracking is locked');
      }, (_) => fail('expected left'));
      verifyNever(() => ds.getItem(any()));
    });

    test('getItem returns failure when datasource throws', () async {
      when(() => ds.getItem(1)).thenThrow(_unprocessable());
      expect((await repo.getItem(1)).isLeft(), isTrue);
    });

    test('getUoms and getItemCategories return lists', () async {
      when(
        () => ds.listUoms(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer(
        (_) async => api.UomPage(
          (b) => b
            ..data.replace([
              api.Uom(
                (u) => u
                  ..id = 2
                  ..code = 'KG'
                  ..name = 'Kilogram'
                  ..decimalPlaces = 3
                  ..isActive = true,
              ),
            ])
            ..meta.replace(_meta()),
        ),
      );
      when(
        () => ds.listItemCategories(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          isActive: any(named: 'isActive'),
        ),
      ).thenAnswer(
        (_) async => api.ItemCategoryPage(
          (b) => b
            ..data.replace([
              api.ItemCategory(
                (c) => c
                  ..id = 1
                  ..name = 'Supplements'
                  ..isActive = true,
              ),
            ])
            ..meta.replace(_meta()),
        ),
      );
      final uoms = (await repo.getUoms()).getOrElse((_) => fail('uom'));
      final cats = (await repo.getItemCategories()).getOrElse(
        (_) => fail('cat'),
      );
      expect(uoms.single.code, 'KG');
      expect(cats.single.name, 'Supplements');
    });
  });
}

api.ItemCreate _fakeCreate() => api.ItemCreate(
  (b) => b
    ..name = 'x'
    ..itemKind = api.ItemKind.goods
    ..uomId = 1
    ..incomeAccountId = 1
    ..expenseAccountId = 2,
);
