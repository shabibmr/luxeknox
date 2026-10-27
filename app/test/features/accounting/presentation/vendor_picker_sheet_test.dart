import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/accounting/domain/entities/vendor.dart';
import 'package:luxeknox/features/accounting/domain/usecases/get_vendors_usecase.dart';
import 'package:luxeknox/features/accounting/presentation/accounting_strings.dart';
import 'package:luxeknox/features/accounting/presentation/widgets/vendor_picker_sheet.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVendorsUseCase extends Mock implements GetVendorsUseCase {}

void main() {
  late MockGetVendorsUseCase getVendors;

  const activeVendor = Vendor(
    id: 'v-1',
    name: 'Acme Fitness Equipments',
    phone: '9999999999',
    isActive: true,
  );
  const inactiveVendor = Vendor(
    id: 'v-2',
    name: 'Old Supplier Co',
    isActive: false,
  );

  setUpAll(() => registerFallbackValue(const GetVendorsParams()));

  setUp(() {
    getVendors = MockGetVendorsUseCase();
    when(() => getVendors(any())).thenAnswer((inv) async {
      final p = inv.positionalArguments.first as GetVendorsParams;
      const all = [activeVendor, inactiveVendor];
      final items = p.search == null
          ? all
          : all
                .where(
                  (v) =>
                      v.name.toLowerCase().contains(p.search!.toLowerCase()),
                )
                .toList();
      return Right(CursorPage(items: items, nextCursor: null, hasMore: false));
    });
  });

  testWidgets('picking an active vendor returns the vendor', (tester) async {
    Vendor? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VendorPickerField(
            getVendors: getVendors,
            onChanged: (v) => picked = v,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(VendorPickerField));
    await tester.pumpAndSettle();

    expect(find.text('Acme Fitness Equipments'), findsOneWidget);
    expect(find.text('Old Supplier Co'), findsOneWidget);

    await tester.tap(find.text('Acme Fitness Equipments'));
    await tester.pumpAndSettle();

    expect(picked, activeVendor);
  });

  testWidgets(
    'inactive vendor shows badge, snackbar on tap, and cannot be selected',
    (tester) async {
      Vendor? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VendorPickerField(
              getVendors: getVendors,
              onChanged: (v) => picked = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VendorPickerField));
      await tester.pumpAndSettle();

      expect(find.text(AccountingStrings.inactiveBadge), findsOneWidget);

      await tester.tap(find.text('Old Supplier Co'));
      await tester.pumpAndSettle();

      expect(
        find.text(AccountingStrings.cannotPickInactiveVendor),
        findsOneWidget,
      );
      expect(picked, isNull);
      expect(find.byType(VendorPickerSheet), findsOneWidget);
    },
  );

  testWidgets('search text debounces and calls GetVendorsUseCase', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VendorPickerField(getVendors: getVendors, onChanged: (_) {}),
        ),
      ),
    );

    await tester.tap(find.byType(VendorPickerField));
    await tester.pumpAndSettle();

    final searchField = find.byKey(const Key('vendor_picker_search_field'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Acme');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Acme Fitness Equipments'), findsOneWidget);
    expect(find.text('Old Supplier Co'), findsNothing);

    final last =
        verify(() => getVendors(captureAny())).captured.last as GetVendorsParams;
    expect(last.search, 'Acme');
    expect(last.isActive, isNull);
  });

  testWidgets('VendorPickerField renders name and clear sets null', (
    tester,
  ) async {
    Vendor? current = activeVendor;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => VendorPickerField(
              value: current,
              getVendors: getVendors,
              onChanged: (vendor) {
                setState(() => current = vendor);
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Acme Fitness Equipments'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(current, isNull);
    expect(find.text(AccountingStrings.selectVendor), findsAtLeastNWidgets(1));
  });
}
