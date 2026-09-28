import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/foods/data/datasources/food_remote_datasource.dart';
import 'package:luxeknox/features/foods/domain/entities/food_filter.dart';
import 'package:mocktail/mocktail.dart';

class MockDIETApi extends Mock implements api.DIETApi {}

void main() {
  late MockDIETApi mockDietApi;
  late FoodRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDietApi = MockDIETApi();
    dataSource = FoodRemoteDataSourceImpl(mockDietApi);
  });

  group('FoodRemoteDataSourceImpl', () {
    test(
      'getFoods forwards q, isVerified, isActive, limit, offset to listFoods',
      () async {
        final tPage = api.FoodPage((b) {
          b
            ..data.replace(BuiltList<api.Food>([]))
            ..meta.limit = 25
            ..meta.nextCursor = '65'
            ..meta.hasMore = true;
        });

        when(
          () => mockDietApi.listFoods(
            q: 'chicken',
            isVerified: true,
            isActive: false,
            limit: 25,
            offset: 40,
          ),
        ).thenAnswer(
          (_) async => Response<api.FoodPage>(
            requestOptions: RequestOptions(path: '/foods'),
            data: tPage,
          ),
        );

        const filter = FoodFilter(
          query: 'chicken',
          isVerified: true,
          isActive: false,
        );

        final result = await dataSource.getFoods(
          filter: filter,
          cursor: '40',
          limit: 25,
        );

        expect(result, tPage);
        verify(
          () => mockDietApi.listFoods(
            q: 'chicken',
            isVerified: true,
            isActive: false,
            limit: 25,
            offset: 40,
          ),
        ).called(1);
      },
    );
  });
}
