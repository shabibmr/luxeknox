import 'package:api_client/api_client.dart' as api;
import 'package:app/core/error/failures.dart';
import 'package:app/features/foods/data/datasources/food_remote_datasource.dart';
import 'package:app/features/foods/data/models/food_model.dart';
import 'package:app/features/foods/data/repositories/food_repository_impl.dart';
import 'package:app/features/foods/domain/entities/food_filter.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockFoodRemoteDataSource extends Mock implements FoodRemoteDataSource {}

void main() {
  late MockFoodRemoteDataSource mockDataSource;
  late FoodRepositoryImpl repository;

  final tApiModel = api.Food((b) {
    b
      ..id = 1
      ..name = 'Chicken Breast'
      ..servingUnit = 'g'
      ..servingSize = 100
      ..calories = 165
      ..proteinGrams = 31
      ..carbsGrams = 0
      ..fatGrams = 3.6
      ..fiberGrams = 0
      ..isVerified = true
      ..isActive = true;
  });

  setUpAll(() {
    registerFallbackValue(
      api.FoodWrite(
        (b) => b
          ..name = 'fallback'
          ..servingUnit = 'g',
      ),
    );
    registerFallbackValue(const FoodFilter());
  });

  setUp(() {
    mockDataSource = MockFoodRemoteDataSource();
    repository = FoodRepositoryImpl(mockDataSource);
  });

  group('FoodRepositoryImpl', () {
    test('getFoods returns mapped CursorPage on success', () async {
      final tPage = api.FoodPage((b) {
        b
          ..data.replace(BuiltList<api.Food>([tApiModel]))
          ..meta.limit = 20
          ..meta.nextCursor = 'cursor123'
          ..meta.hasMore = true;
      });

      when(
        () => mockDataSource.getFoods(
          filter: any(named: 'filter'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((_) async => tPage);

      final result = await repository.getFoods(const FoodFilter(), null);

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('expected right, got $failure'), (page) {
        expect(page.items.length, 1);
        expect(page.items.first.name, 'Chicken Breast');
        expect(page.nextCursor, 'cursor123');
        expect(page.hasMore, isTrue);
      });
    });

    test('getFood returns mapped Food on success', () async {
      when(() => mockDataSource.getFood(1)).thenAnswer((_) async => tApiModel);

      final result = await repository.getFood('1');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (food) => expect(food.name, 'Chicken Breast'),
      );
    });

    test('getFood with non-integer id returns NotFoundFailure', () async {
      final result = await repository.getFood('invalid-id');
      expect(result, const Left(NotFoundFailure()));
    });

    test(
      'wraps 404 DioException into NotFoundFailure without throwing',
      () async {
        final req = RequestOptions(path: '/foods/999');
        when(() => mockDataSource.getFood(999)).thenThrow(
          DioException(
            requestOptions: req,
            response: Response(
              requestOptions: req,
              statusCode: 404,
              data: {'code': 'not_found', 'message': 'Food not found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getFood('999');

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (_) => fail('expected failure'),
        );
      },
    );

    test('create returns mapped Food on success', () async {
      when(
        () => mockDataSource.createFood(any()),
      ).thenAnswer((_) async => tApiModel);

      final result = await repository.create(tApiModel.toDomain());

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (food) => expect(food.name, 'Chicken Breast'),
      );
    });

    test('update returns mapped Food on success', () async {
      when(
        () => mockDataSource.updateFood(1, any()),
      ).thenAnswer((_) async => tApiModel);

      final result = await repository.update(tApiModel.toDomain());

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (food) => expect(food.name, 'Chicken Breast'),
      );
    });

    test('deactivate fetches then updates with isVerified false', () async {
      when(() => mockDataSource.getFood(1)).thenAnswer((_) async => tApiModel);
      when(
        () => mockDataSource.updateFood(1, any()),
      ).thenAnswer((_) async => tApiModel);

      final result = await repository.deactivate('1');

      expect(result, const Right(null));
      final captured = verify(
        () => mockDataSource.updateFood(1, captureAny()),
      ).captured;
      final write = captured.single as api.FoodWrite;
      expect(write.isVerified, isFalse);
    });

    test('deactivate with non-integer id returns NotFoundFailure', () async {
      final result = await repository.deactivate('invalid-id');
      expect(result, const Left(NotFoundFailure()));
    });
  });
}
