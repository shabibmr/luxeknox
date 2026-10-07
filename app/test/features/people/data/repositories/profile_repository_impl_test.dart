import 'package:api_client/api_client.dart' as api;
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/data/datasources/profile_remote_datasource.dart';
import 'package:luxeknox/features/people/data/repositories/profile_repository_impl.dart';
import 'package:luxeknox/features/people/domain/entities/health_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource mockRemote;
  late ProfileRepositoryImpl repository;

  final tApiHealth = api.MemberHealth(
    (b) => b
      ..id = 1
      ..memberId = 10
      ..bloodGroup = 'O+'
      ..heightCm = 180.0
      ..baselineWeightKg = 75.0,
  );

  setUp(() {
    mockRemote = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockRemote);
  });

  group('ProfileRepositoryImpl.getHealthInfo', () {
    test('returns HealthInfo when remote datasource succeeds', () async {
      when(() => mockRemote.getHealth(10)).thenAnswer((_) async => tApiHealth);

      final result = await repository.getHealthInfo(10);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (info) {
        expect(info.id, 1);
        expect(info.memberId, 10);
        expect(info.bloodGroup, 'O+');
        expect(info.heightCm, 180.0);
      });
    });

    test(
      'returns empty HealthInfo(id: 0, memberId: 10) when remote datasource throws 404',
      () async {
        final req = RequestOptions(path: '/members/10/health');
        when(() => mockRemote.getHealth(10)).thenThrow(
          DioException(
            requestOptions: req,
            response: Response(
              requestOptions: req,
              statusCode: 404,
              data: {'message': 'Member health not found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getHealthInfo(10);

        expect(result, const Right(HealthInfo(id: 0, memberId: 10)));
      },
    );

    test(
      'returns NetworkFailure when remote datasource throws connection error',
      () async {
        final req = RequestOptions(path: '/members/10/health');
        when(() => mockRemote.getHealth(10)).thenThrow(
          DioException(
            requestOptions: req,
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await repository.getHealthInfo(10);

        expect(result, const Left(NetworkFailure()));
      },
    );
  });
}
