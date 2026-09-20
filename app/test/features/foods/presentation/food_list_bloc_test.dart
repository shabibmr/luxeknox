import 'package:app/core/error/failures.dart';
import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/foods/domain/entities/food.dart';
import 'package:app/features/foods/domain/entities/food_filter.dart';
import 'package:app/features/foods/domain/usecases/get_foods_usecase.dart';
import 'package:app/features/foods/presentation/bloc/food_list_bloc.dart';
import 'package:app/features/foods/presentation/bloc/food_list_event.dart';
import 'package:app/features/foods/presentation/bloc/food_list_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFoodsUseCase extends Mock implements GetFoodsUseCase {}

void main() {
  late MockGetFoodsUseCase mockUseCase;

  const tFood1 = Food(
    id: '1',
    name: 'Chicken Breast',
    servingUnit: 'g',
    calories: 165,
    isVerified: true,
  );

  const tFood2 = Food(
    id: '2',
    name: 'Brown Rice',
    servingUnit: 'cup',
    calories: 216,
    isVerified: true,
  );

  setUpAll(() {
    registerFallbackValue(const GetFoodsParams());
  });

  setUp(() {
    mockUseCase = MockGetFoodsUseCase();
  });

  group('FoodListBloc (Q1)', () {
    test('initial state has initial status and empty items', () {
      final bloc = FoodListBloc(getFoodsUseCase: mockUseCase);
      expect(bloc.state.status, FoodListStatus.initial);
      expect(bloc.state.items, isEmpty);
    });

    blocTest<FoodListBloc, FoodListState>(
      'started emits loading then success with items',
      build: () {
        when(() => mockUseCase(any())).thenAnswer(
          (_) async => const Right(
            CursorPage<Food>(items: [tFood1], nextCursor: 'c1', hasMore: true),
          ),
        );
        return FoodListBloc(getFoodsUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FoodListStarted()),
      expect: () => [
        const FoodListState(status: FoodListStatus.loading),
        const FoodListState(
          status: FoodListStatus.success,
          items: [tFood1],
          cursor: 'c1',
          hasMore: true,
        ),
      ],
    );

    blocTest<FoodListBloc, FoodListState>(
      'pagination retains existing items while loading next page and appends them',
      build: () {
        when(
          () => mockUseCase(
            const GetFoodsParams(filter: FoodFilter(), cursor: 'c1'),
          ),
        ).thenAnswer(
          (_) async => const Right(
            CursorPage<Food>(items: [tFood2], nextCursor: null, hasMore: false),
          ),
        );
        return FoodListBloc(getFoodsUseCase: mockUseCase);
      },
      seed: () => const FoodListState(
        status: FoodListStatus.success,
        items: [tFood1],
        cursor: 'c1',
        hasMore: true,
      ),
      act: (bloc) => bloc.add(const FoodListNextPageRequested()),
      expect: () => [
        const FoodListState(
          status: FoodListStatus.loading,
          items: [tFood1],
          cursor: 'c1',
          hasMore: true,
        ),
        const FoodListState(
          status: FoodListStatus.success,
          items: [tFood1, tFood2],
          cursor: null,
          hasMore: false,
        ),
      ],
    );

    blocTest<FoodListBloc, FoodListState>(
      'failure emits failure state with Failure object',
      build: () {
        when(
          () => mockUseCase(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return FoodListBloc(getFoodsUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FoodListStarted()),
      expect: () => [
        const FoodListState(status: FoodListStatus.loading),
        const FoodListState(
          status: FoodListStatus.failure,
          failure: NetworkFailure(),
        ),
      ],
    );

    test('rapid search events debounce to a single call', () async {
      when(() => mockUseCase(any())).thenAnswer(
        (_) async => const Right(
          CursorPage<Food>(items: [tFood1], nextCursor: null, hasMore: false),
        ),
      );

      final bloc = FoodListBloc(
        getFoodsUseCase: mockUseCase,
        debounceDuration: const Duration(milliseconds: 100),
      );

      bloc.add(const FoodListSearchChanged('c'));
      bloc.add(const FoodListSearchChanged('ch'));
      bloc.add(const FoodListSearchChanged('chicken'));

      await Future<void>.delayed(const Duration(milliseconds: 200));

      verify(() => mockUseCase(any())).called(1);
      await bloc.close();
    });
  });
}
