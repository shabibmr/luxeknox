import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/pt/data/datasources/pt_remote_datasource.dart';
import 'package:luxeknox/features/pt/data/repositories/pt_repository_impl.dart';
import 'package:luxeknox/features/pt/domain/repositories/pt_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements PtRemoteDataSource {}

void main() {
  late MockRemote remote;
  late PtRepositoryImpl repository;

  setUpAll(
    () => registerFallbackValue(
      api.PtPurchaseRequest(
        (b) => b
          ..memberId = 0
          ..ptProductId = 0
          ..trainerId = 0
          ..startDate = api.Date(2026, 1, 1)
          ..slotStart = '00:00'
          ..weekdays = ListBuilder<int>([1]),
      ),
    ),
  );

  setUp(() {
    remote = MockRemote();
    repository = PtRepositoryImpl(remote);
  });

  Future<dynamic> purchase({String? key}) => repository.purchase(
    memberId: 42,
    ptProductId: 3,
    trainerId: 7,
    startDate: DateTime(2026, 10, 5),
    weekdays: const [5, 1, 3],
    slotStart: '17:00:00',
    payment: const PtPayment(paymentMethodId: 1, discountAmount: '100.00'),
    idempotencyKey: key,
  );

  test(
    'purchase sends HH:mm, sorted weekdays and the idempotency key',
    () async {
      when(
        () => remote.purchase(
          request: any(named: 'request'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await purchase(key: 'key-12345678');

      final captured = verify(
        () => remote.purchase(
          request: captureAny(named: 'request'),
          idempotencyKey: captureAny(named: 'idempotencyKey'),
        ),
      ).captured;
      final request = captured[0] as api.PtPurchaseRequest;
      expect(request.slotStart, '17:00');
      expect(request.weekdays.toList(), [1, 3, 5]);
      expect(request.discountAmount, '100.00');
      expect(captured[1], 'key-12345678');
      expect(result.isLeft(), isTrue);
    },
  );

  test(
    'a thrown transport error becomes a Failure, not an exception',
    () async {
      when(
        () => remote.purchase(
          request: any(named: 'request'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await purchase();

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('right'),
      );
    },
  );
}
