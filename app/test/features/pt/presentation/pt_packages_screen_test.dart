import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_product.dart';
import 'package:luxeknox/features/pt/domain/usecases/pt_usecases.dart';
import 'package:luxeknox/features/pt/presentation/cubit/pt_packages_cubit.dart';
import 'package:luxeknox/features/pt/presentation/pt_strings.dart';
import 'package:luxeknox/features/pt/presentation/screens/pt_packages_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPtProducts extends Mock implements GetPtProductsUseCase {}

class MockSavePtProduct extends Mock implements SavePtProductUseCase {}

void main() {
  late MockGetPtProducts mockGetProducts;
  late MockSavePtProduct mockSaveProduct;

  const tProduct = PtProduct(
    id: 1,
    name: 'PT Premium',
    code: 'PT-PREM-1M',
    durationDays: 30,
    sessionsPerWeek: 3,
    basePrice: '5000.00',
    isActive: true,
  );

  setUpAll(() {
    registerFallbackValue(tProduct);
  });

  setUp(() {
    mockGetProducts = MockGetPtProducts();
    mockSaveProduct = MockSavePtProduct();

    if (getIt.isRegistered<PtPackagesCubit>()) {
      getIt.unregister<PtPackagesCubit>();
    }
    getIt.registerFactory<PtPackagesCubit>(
      () => PtPackagesCubit(mockGetProducts, mockSaveProduct),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<PtPackagesCubit>()) {
      getIt.unregister<PtPackagesCubit>();
    }
  });

  testWidgets(
    'PT package create form does not show Code field and auto-generates code on submit',
    (tester) async {
      when(
        () => mockGetProducts(const NoParams()),
      ).thenAnswer((_) async => const Right(<PtProduct>[]));
      when(() => mockSaveProduct(any())).thenAnswer((invocation) async {
        final p = invocation.positionalArguments[0] as PtProduct;
        return Right(
          PtProduct(
            id: 10,
            name: p.name,
            code: p.code,
            durationDays: p.durationDays,
            sessionsPerWeek: p.sessionsPerWeek,
            basePrice: p.basePrice,
            isActive: p.isActive,
          ),
        );
      });

      await tester.pumpWidget(const MaterialApp(home: PtPackagesScreen()));
      await tester.pumpAndSettle();

      // Tap + to open create form dialog
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Verify dialog is open with Name field
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(PtStrings.newPackage),
        ),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, PtStrings.name),
        findsOneWidget,
      );

      // Verify Code field is NOT displayed
      expect(find.widgetWithText(TextFormField, PtStrings.code), findsNothing);

      // Fill form
      await tester.enterText(
        find.widgetWithText(TextFormField, PtStrings.name),
        'Super PT 3x',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, PtStrings.durationDays),
        '30',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, PtStrings.sessionsPerWeek),
        '3',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, PtStrings.price),
        '4999.00',
      );

      // Save
      await tester.tap(find.widgetWithText(FilledButton, PtStrings.save));
      await tester.pumpAndSettle();

      // Verify save was called with auto-generated code
      final captured = verify(() => mockSaveProduct(captureAny())).captured;
      expect(captured.length, 1);
      final saved = captured.first as PtProduct;
      expect(saved.name, 'Super PT 3x');
      expect(saved.code, startsWith('SUPER-PT-3X-'));
      expect(saved.code.length, lessThanOrEqualTo(32));
      expect(saved.durationDays, 30);
      expect(saved.sessionsPerWeek, 3);
      expect(saved.basePrice, '4999.00');
    },
  );
}
