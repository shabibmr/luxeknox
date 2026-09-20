import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/foods/domain/entities/food.dart';
import 'package:app/features/foods/domain/entities/food_filter.dart';
import 'package:app/features/foods/domain/repositories/food_repository.dart';
import 'package:app/features/foods/domain/usecases/create_food_usecase.dart';
import 'package:app/features/foods/domain/usecases/deactivate_food_usecase.dart';
import 'package:app/features/foods/domain/usecases/get_food_usecase.dart';
import 'package:app/features/foods/domain/usecases/get_foods_usecase.dart';
import 'package:app/features/foods/domain/usecases/update_food_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockFoodRepository extends Mock implements FoodRepository {}

void main() {
  late MockFoodRepository mockRepository;

  const tFood = Food(
    id: '1',
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

  const tPage = CursorPage<Food>(
    items: [tFood],
    nextCursor: 'next_page_token',
    hasMore: true,
  );

  setUp(() {
    mockRepository = MockFoodRepository();
  });

  group('Food UseCases', () {
    test('GetFoodsUseCase calls repository.getFoods', () async {
      const filter = FoodFilter(query: 'chicken');
      when(
        () => mockRepository.getFoods(filter, 'c1'),
      ).thenAnswer((_) async => const Right(tPage));

      final useCase = GetFoodsUseCase(mockRepository);
      final result = await useCase(
        const GetFoodsParams(filter: filter, cursor: 'c1'),
      );

      expect(result, const Right(tPage));
      verify(() => mockRepository.getFoods(filter, 'c1')).called(1);
    });

    test('GetFoodUseCase calls repository.getFood', () async {
      when(
        () => mockRepository.getFood('1'),
      ).thenAnswer((_) async => const Right(tFood));

      final useCase = GetFoodUseCase(mockRepository);
      final result = await useCase('1');

      expect(result, const Right(tFood));
      verify(() => mockRepository.getFood('1')).called(1);
    });

    test('CreateFoodUseCase calls repository.create', () async {
      when(
        () => mockRepository.create(tFood),
      ).thenAnswer((_) async => const Right(tFood));

      final useCase = CreateFoodUseCase(mockRepository);
      final result = await useCase(tFood);

      expect(result, const Right(tFood));
      verify(() => mockRepository.create(tFood)).called(1);
    });

    test('UpdateFoodUseCase calls repository.update', () async {
      when(
        () => mockRepository.update(tFood),
      ).thenAnswer((_) async => const Right(tFood));

      final useCase = UpdateFoodUseCase(mockRepository);
      final result = await useCase(tFood);

      expect(result, const Right(tFood));
      verify(() => mockRepository.update(tFood)).called(1);
    });

    test('DeactivateFoodUseCase calls repository.deactivate', () async {
      when(
        () => mockRepository.deactivate('1'),
      ).thenAnswer((_) async => const Right(null));

      final useCase = DeactivateFoodUseCase(mockRepository);
      final result = await useCase('1');

      expect(result, const Right(null));
      verify(() => mockRepository.deactivate('1')).called(1);
    });
  });
}
