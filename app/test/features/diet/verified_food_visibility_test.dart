import 'package:app/core/di/injector.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/diet/presentation/cubit/food_picker_cubit.dart';
import 'package:app/features/diet/presentation/widgets/food_picker_sheet.dart';
import 'package:app/features/foods/domain/entities/food.dart';
import 'package:app/features/foods/domain/usecases/get_foods_usecase.dart';
import 'package:app/session/domain/entities/capabilities.dart';
import 'package:app/session/domain/entities/principal.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:app/session/presentation/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetFoodsUseCase extends Mock implements GetFoodsUseCase {}
class _MockSessionCubit extends Mock implements SessionCubit {}

void main() {
  late _MockGetFoodsUseCase mockGetFoods;
  late _MockSessionCubit mockSessionCubit;

  const verifiedFood = Food(
    id: '1',
    name: 'Verified Oats',
    servingUnit: 'g',
    calories: 389,
    isVerified: true,
  );

  const unverifiedFood = Food(
    id: '2',
    name: 'Unverified Smoothie',
    servingUnit: 'ml',
    calories: 250,
    isVerified: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetFoodsParams());
  });

  setUp(() {
    mockGetFoods = _MockGetFoodsUseCase();
    mockSessionCubit = _MockSessionCubit();

    if (getIt.isRegistered<SessionCubit>()) {
      getIt.unregister<SessionCubit>();
    }
    if (getIt.isRegistered<FoodPickerCubit>()) {
      getIt.unregister<FoodPickerCubit>();
    }

    getIt.registerSingleton<SessionCubit>(mockSessionCubit);
    getIt.registerFactory<FoodPickerCubit>(
      () => FoodPickerCubit(mockGetFoods),
    );

    when(() => mockSessionCubit.state).thenReturn(
      const SessionAuthenticated(
        principal: Principal(
          userId: '1',
          displayName: 'Trainer',
          profileId: '10',
          userType: UserType.trainer,
        ),
        capabilities: Capabilities(slugs: []),
      ),
    );

    when(() => mockGetFoods(any())).thenAnswer(
      (_) async => const Right(
        CursorPage(
          items: [verifiedFood, unverifiedFood],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('shows both verified and unverified foods when verifiedOnly is false', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FoodPickerSheet(verifiedOnly: false),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verified Oats'), findsOneWidget);
    expect(find.text('Unverified Smoothie'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
    expect(find.text('Unverified'), findsOneWidget);
  });

  testWidgets('hides unverified foods when verifiedOnly is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FoodPickerSheet(verifiedOnly: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verified Oats'), findsOneWidget);
    expect(find.text('Unverified Smoothie'), findsNothing);
  });
}
