import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/foods/domain/entities/food.dart';
import 'package:luxeknox/features/foods/domain/usecases/get_food_usecase.dart';
import 'package:luxeknox/features/foods/domain/usecases/get_foods_usecase.dart';
import 'package:luxeknox/features/foods/presentation/bloc/food_list_bloc.dart';
import 'package:luxeknox/features/foods/presentation/cubit/food_detail_cubit.dart';
import 'package:luxeknox/features/foods/presentation/screens/food_detail_screen.dart';
import 'package:luxeknox/features/foods/presentation/screens/food_library_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFoodsUseCase extends Mock implements GetFoodsUseCase {}

class MockGetFoodUseCase extends Mock implements GetFoodUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

/// S3 — golden tests for the Food Library and Food Details screens at
/// 390dp (phone) and 1280dp (master-detail breakpoint), mirroring the
/// vertical-1 `L9` pattern for the Exercise Library.
void main() {
  const tFood = Food(
    id: 'food-1',
    name: 'Chicken Breast',
    servingUnit: 'g',
    servingSize: 100,
    calories: 165,
    proteinGrams: 31,
    carbsGrams: 0,
    fatGrams: 3.6,
    fiberGrams: 0,
    isVerified: true,
  );

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const adminCapabilities = Capabilities(
    slugs: ['diet.read', 'diet.create', 'diet.update'],
  );

  late MockGetFoodsUseCase mockGetFoodsUseCase;
  late MockGetFoodUseCase mockGetFoodUseCase;

  setUpAll(() {
    registerFallbackValue(const GetFoodsParams());
  });

  setUp(() {
    mockGetFoodsUseCase = MockGetFoodsUseCase();
    mockGetFoodUseCase = MockGetFoodUseCase();

    when(() => mockGetFoodsUseCase(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(items: [tFood], nextCursor: null, hasMore: false),
      ),
    );
    when(
      () => mockGetFoodUseCase(any()),
    ).thenAnswer((_) async => const Right(tFood));

    getIt.registerFactory<FoodListBloc>(
      () => FoodListBloc(getFoodsUseCase: mockGetFoodsUseCase),
    );
    getIt.registerFactory<FoodDetailCubit>(
      () => FoodDetailCubit(mockGetFoodUseCase),
    );
  });

  tearDown(() => getIt.reset());

  Widget wrapWithSession(Widget child) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: const SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: adminCapabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(value: sessionCubit, child: child),
    );
  }

  Future<void> pumpAtWidth(
    WidgetTester tester,
    Widget widget,
    double width,
  ) async {
    tester.view.physicalSize = Size(width, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(wrapWithSession(widget));
    await tester.pumpAndSettle();
  }

  group('Food Library screen goldens (S3)', () {
    testWidgets('390dp', (tester) async {
      await pumpAtWidth(tester, const FoodLibraryScreen(), 390);
      await expectLater(
        find.byType(FoodLibraryScreen),
        matchesGoldenFile('goldens/food_library_390.png'),
      );
    });

    testWidgets('1280dp', (tester) async {
      await pumpAtWidth(tester, const FoodLibraryScreen(), 1280);
      await expectLater(
        find.byType(FoodLibraryScreen),
        matchesGoldenFile('goldens/food_library_1280.png'),
      );
    });
  });

  group('Food Details screen goldens (S3)', () {
    testWidgets('390dp', (tester) async {
      await pumpAtWidth(tester, const FoodDetailScreen(foodId: 'food-1'), 390);
      await expectLater(
        find.byType(FoodDetailScreen),
        matchesGoldenFile('goldens/food_detail_390.png'),
      );
    });

    testWidgets('1280dp', (tester) async {
      await pumpAtWidth(tester, const FoodDetailScreen(foodId: 'food-1'), 1280);
      await expectLater(
        find.byType(FoodDetailScreen),
        matchesGoldenFile('goldens/food_detail_1280.png'),
      );
    });
  });
}
