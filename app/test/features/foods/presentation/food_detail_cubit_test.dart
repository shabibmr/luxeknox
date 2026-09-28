import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/foods/domain/entities/food.dart';
import 'package:luxeknox/features/foods/domain/usecases/get_food_usecase.dart';
import 'package:luxeknox/features/foods/presentation/cubit/food_detail_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFoodUseCase extends Mock implements GetFoodUseCase {}

void main() {
  late MockGetFoodUseCase mockUseCase;

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

  setUp(() {
    mockUseCase = MockGetFoodUseCase();
  });

  group('FoodDetailCubit (Q5)', () {
    test('initial state has initial status and null food', () {
      final cubit = FoodDetailCubit(mockUseCase);
      expect(cubit.state.status, FoodDetailStatus.initial);
      expect(cubit.state.food, isNull);
    });

    blocTest<FoodDetailCubit, FoodDetailState>(
      'loadFood success emits [loading, success]',
      build: () {
        when(
          () => mockUseCase('1'),
        ).thenAnswer((_) async => const Right(tFood));
        return FoodDetailCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadFood('1'),
      expect: () => [
        const FoodDetailState(status: FoodDetailStatus.loading),
        const FoodDetailState(status: FoodDetailStatus.success, food: tFood),
      ],
    );

    blocTest<FoodDetailCubit, FoodDetailState>(
      'loadFood not found emits [loading, failure(NotFoundFailure)]',
      build: () {
        when(
          () => mockUseCase('999'),
        ).thenAnswer((_) async => const Left(NotFoundFailure()));
        return FoodDetailCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadFood('999'),
      expect: () => [
        const FoodDetailState(status: FoodDetailStatus.loading),
        const FoodDetailState(
          status: FoodDetailStatus.failure,
          failure: NotFoundFailure(),
        ),
      ],
    );

    blocTest<FoodDetailCubit, FoodDetailState>(
      'loadFood network failure emits [loading, failure(NetworkFailure)]',
      build: () {
        when(
          () => mockUseCase('1'),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return FoodDetailCubit(mockUseCase);
      },
      act: (cubit) => cubit.loadFood('1'),
      expect: () => [
        const FoodDetailState(status: FoodDetailStatus.loading),
        const FoodDetailState(
          status: FoodDetailStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );
  });
}
