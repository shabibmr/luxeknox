import 'package:app/core/di/injector.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/foods/domain/entities/food.dart';
import 'package:app/features/foods/domain/usecases/get_food_usecase.dart';
import 'package:app/features/foods/domain/usecases/get_foods_usecase.dart';
import 'package:app/features/foods/presentation/bloc/food_list_bloc.dart';
import 'package:app/features/foods/presentation/cubit/food_detail_cubit.dart';
import 'package:app/features/foods/presentation/screens/food_detail_screen.dart';
import 'package:app/features/foods/presentation/screens/food_library_screen.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
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

/// S1 — role-variant widget tests for Vertical 2 (Food Library), reusing
/// the vertical-1 `L8` acceptance-gate pattern. Renders the Food Library
/// and Food Details screens under a member, trainer, and admin principal
/// and asserts that admin-only controls (add/edit) appear only for admin.
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

  const memberPrincipal = Principal(
    userId: '1',
    userType: UserType.member,
    displayName: 'Member One',
    profileId: 'p1',
  );
  const trainerPrincipal = Principal(
    userId: '2',
    userType: UserType.trainer,
    displayName: 'Trainer One',
    profileId: 'p2',
  );
  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const readOnlyCapabilities = Capabilities(slugs: ['foods.read']);
  const adminCapabilities = Capabilities(
    slugs: ['foods.read', 'foods.create', 'foods.update'],
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

  Widget wrapWithSession(
    Widget child,
    Principal principal,
    Capabilities capabilities,
  ) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: principal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      home: BlocProvider<SessionCubit>.value(value: sessionCubit, child: child),
    );
  }

  group('Food Library screen role variants (S1)', () {
    testWidgets('member sees browse only, no add button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const FoodLibraryScreen(),
          memberPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('Chicken Breast'), findsOneWidget);
    });

    testWidgets('trainer sees browse only, no add button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const FoodLibraryScreen(),
          trainerPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('Chicken Breast'), findsOneWidget);
    });

    testWidgets('admin sees the add button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const FoodLibraryScreen(),
          adminPrincipal,
          adminCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Chicken Breast'), findsOneWidget);
    });
  });

  group('Food Details screen role variants (S1)', () {
    testWidgets('member sees details only, no edit button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const FoodDetailScreen(foodId: 'food-1'),
          memberPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.text('Chicken Breast'), findsOneWidget);
    });

    testWidgets('trainer sees details only, no edit button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const FoodDetailScreen(foodId: 'food-1'),
          trainerPrincipal,
          readOnlyCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.text('Chicken Breast'), findsOneWidget);
    });

    testWidgets('admin sees the edit button', (tester) async {
      await tester.pumpWidget(
        wrapWithSession(
          const FoodDetailScreen(foodId: 'food-1'),
          adminPrincipal,
          adminCapabilities,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.text('Chicken Breast'), findsOneWidget);
    });
  });
}
