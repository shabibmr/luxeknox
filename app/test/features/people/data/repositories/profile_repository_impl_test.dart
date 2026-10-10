import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
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

api.MemberHealthRecord _apiRecord({
  required int id,
  required int memberId,
  required DateTime recordedAt,
}) {
  return api.MemberHealthRecord(
    (b) => b
      ..id = id
      ..memberId = memberId
      ..bloodGroup = 'O+'
      ..heightCm = 180.0
      ..baselineWeightKg = 75.0
      ..recordedAt = recordedAt,
  );
}

api.MemberHealthHistoryPage _page(List<api.MemberHealthRecord> records) {
  return api.MemberHealthHistoryPage(
    (b) => b
      ..data = ListBuilder(records)
      ..meta = (api.PageMetaBuilder()
        ..limit = 20
        ..hasMore = false
        ..total = records.length),
  );
}

void main() {
  late MockProfileRemoteDataSource mockRemote;
  late ProfileRepositoryImpl repository;

  final tOlder = _apiRecord(id: 1, memberId: 10, recordedAt: DateTime(2026, 1, 1));
  final tNewer = _apiRecord(id: 2, memberId: 10, recordedAt: DateTime(2026, 2, 1));

  setUpAll(() {
    registerFallbackValue(api.MemberHealthWrite((b) => b));
  });

  setUp(() {
    mockRemote = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockRemote);
  });

  group('ProfileRepositoryImpl.listHealthHistory', () {
    test('returns desc-sorted HealthInfo list when remote datasource succeeds', () async {
      when(() => mockRemote.listHealthHistory(10))
          .thenAnswer((_) async => _page([tOlder, tNewer]));

      final result = await repository.listHealthHistory(10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (records) {
          expect(records.length, 2);
          expect(records[0].id, 2);
          expect(records[1].id, 1);
        },
      );
    });

    test('returns NetworkFailure when remote datasource throws connection error', () async {
      when(() => mockRemote.listHealthHistory(10)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/members/10/health/history'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.listHealthHistory(10);

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('ProfileRepositoryImpl.createHealthRecord', () {
    final tHealthInfo = HealthInfo(
      id: 0,
      memberId: 10,
      bloodGroup: 'O+',
      recordedAt: DateTime(2026, 1, 1),
    );

    test('returns created HealthInfo when remote datasource succeeds', () async {
      when(() => mockRemote.createHealthRecord(10, any()))
          .thenAnswer((_) async => tNewer);

      final result = await repository.createHealthRecord(tHealthInfo);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (info) {
          expect(info.id, 2);
          expect(info.recordedAt, tNewer.recordedAt);
        },
      );
    });

    test('returns NetworkFailure when remote datasource throws connection error', () async {
      when(() => mockRemote.createHealthRecord(10, any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/members/10/health/history'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.createHealthRecord(tHealthInfo);

      expect(result, const Left(NetworkFailure()));
    });
  });
}
