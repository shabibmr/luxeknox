import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/features/accounting/data/datasources/accounting_remote_datasource.dart';
import 'package:luxeknox/features/accounting/data/models/go_live_mapper.dart';
import 'package:luxeknox/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:luxeknox/features/accounting/domain/entities/go_live.dart';
import 'package:mocktail/mocktail.dart';

class MockACCTApi extends Mock implements api.ACCTApi {}

class MockINVApi extends Mock implements api.INVApi {}

class MockDio extends Mock implements Dio {}

class MockAccountingRemoteDataSource extends Mock
    implements AccountingRemoteDataSource {}

void main() {
  group('Go-Live Mappers', () {
    test('goLiveChecklistFromJson correctly parses JSON map', () {
      final json = <String, dynamic>{
        'go_live_date': '2026-03-01T00:00:00.000Z',
        'is_posting_enabled': false,
        'can_enable': true,
        'failing_reasons': <dynamic>['Reason 1', 'Reason 2'],
        'opening_journal_found': true,
        'opening_journal_matches': true,
        'membership_unearned': <String, dynamic>{
          'preview': '1000.00',
          'actual': '1000.00',
          'is_matched': true,
        },
        'pt_unearned': <String, dynamic>{
          'preview': '500.00',
          'actual': '500.00',
          'is_matched': true,
        },
        'tax_match': <String, dynamic>{
          'gym_rate': '18.00',
          'default_code': 'gst_18',
          'default_rate': '18.00',
          'is_matched': true,
        },
        'payment_methods': <dynamic>[
          <String, dynamic>{
            'id': 1,
            'method_name': 'Cash',
            'is_active': true,
            'is_digital': false,
            'account_id': 10,
            'account_code': '1000',
            'account_name': 'Cash on Hand',
          },
          <String, dynamic>{
            'id': 2,
            'method_name': 'UPI',
            'is_active': true,
            'is_digital': true,
            'account_id': null,
            'account_code': null,
            'account_name': null,
          },
        ],
      };

      final checklist = goLiveChecklistFromJson(json);

      expect(checklist.goLiveDate, DateTime.parse('2026-03-01T00:00:00.000Z'));
      expect(checklist.isPostingEnabled, isFalse);
      expect(checklist.canEnable, isTrue);
      expect(checklist.failingReasons, ['Reason 1', 'Reason 2']);
      expect(checklist.openingJournalFound, isTrue);
      expect(checklist.openingJournalMatches, isTrue);
      expect(checklist.membershipUnearned.preview, '1000.00');
      expect(checklist.membershipUnearned.actual, '1000.00');
      expect(checklist.membershipUnearned.isMatched, isTrue);
      expect(checklist.ptUnearned.preview, '500.00');
      expect(checklist.ptUnearned.actual, '500.00');
      expect(checklist.ptUnearned.isMatched, isTrue);
      expect(checklist.taxMatch.gymRate, '18.00');
      expect(checklist.taxMatch.defaultCode, 'gst_18');
      expect(checklist.taxMatch.defaultRate, '18.00');
      expect(checklist.taxMatch.isMatched, isTrue);
      expect(checklist.paymentMethods.length, 2);
      expect(checklist.paymentMethods[0].methodName, 'Cash');
      expect(checklist.paymentMethods[0].accountId, 10);
      expect(checklist.paymentMethods[1].methodName, 'UPI');
      expect(checklist.paymentMethods[1].accountId, isNull);
    });

    test('goLivePaymentMethodMapping copyWith allows clearing accountId', () {
      const mapping = GoLivePaymentMethodMapping(
        id: 1,
        methodName: 'Cash',
        isActive: true,
        isDigital: false,
        accountId: 10,
        accountName: 'Cash on Hand',
      );

      final updated = mapping.copyWith(clearAccountId: true);
      expect(updated.accountId, isNull);
      expect(updated.accountName, isNull);
      expect(updated.methodName, 'Cash');
    });
  });

  group('AccountingRemoteDataSourceImpl Go-Live calls', () {
    late MockACCTApi mockAcctApi;
    late MockDio mockDio;
    late AccountingRemoteDataSourceImpl dataSource;

    setUp(() {
      mockAcctApi = MockACCTApi();
      mockDio = MockDio();
      dataSource = AccountingRemoteDataSourceImpl(mockAcctApi, MockINVApi(), mockDio);
    });

    final reqOptions = RequestOptions(path: '');

    test('getGoLiveChecklist performs GET on /accounting/go-live/checklist',
        () async {
      when(
        () => mockDio.get<dynamic>(
          '/accounting/go-live/checklist',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'can_enable': true},
          requestOptions: reqOptions,
          statusCode: 200,
        ),
      );

      final result = await dataSource.getGoLiveChecklist(
        goLiveDate: api.Date(2026, 3, 1),
      );

      expect(result['can_enable'], isTrue);
      verify(
        () => mockDio.get<dynamic>(
          '/accounting/go-live/checklist',
          queryParameters: {'go_live_date': '2026-03-01'},
        ),
      ).called(1);
    });

    test('mapPaymentMethodAccount performs PATCH on payment method endpoint',
        () async {
      when(
        () => mockDio.patch<dynamic>(
          '/accounting/go-live/payment-methods/5',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{
            'id': 5,
            'method_name': 'Card',
            'is_active': true,
            'is_digital': true,
            'account_id': 1050,
          },
          requestOptions: reqOptions,
          statusCode: 200,
        ),
      );

      final result = await dataSource.mapPaymentMethodAccount(
        paymentMethodId: 5,
        accountId: 1050,
      );

      expect(result['account_id'], 1050);
      verify(
        () => mockDio.patch<dynamic>(
          '/accounting/go-live/payment-methods/5',
          data: {'account_id': 1050},
        ),
      ).called(1);
    });

    test('enablePosting performs POST on /accounting/go-live/enable-posting',
        () async {
      when(
        () => mockDio.post<dynamic>(
          '/accounting/go-live/enable-posting',
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response<dynamic>(
          data: <String, dynamic>{'is_posting_enabled': true},
          requestOptions: reqOptions,
          statusCode: 200,
        ),
      );

      final result = await dataSource.enablePosting(
        goLiveDate: api.Date(2026, 3, 1),
      );

      expect(result, isTrue);
      verify(
        () => mockDio.post<dynamic>(
          '/accounting/go-live/enable-posting',
          queryParameters: {'go_live_date': '2026-03-01'},
          data: {'go_live_date': '2026-03-01'},
        ),
      ).called(1);
    });
  });

  group('AccountingRepositoryImpl Go-Live', () {
    late MockAccountingRemoteDataSource mockDataSource;
    late AccountingRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockAccountingRemoteDataSource();
      repository = AccountingRepositoryImpl(mockDataSource);
    });

    test('getGoLiveChecklist returns Right(GoLiveChecklist)', () async {
      final tJson = <String, dynamic>{
        'go_live_date': '2026-03-01T00:00:00.000Z',
        'is_posting_enabled': true,
        'can_enable': true,
        'failing_reasons': <dynamic>[],
        'opening_journal_found': true,
        'opening_journal_matches': true,
        'membership_unearned': <String, dynamic>{
          'preview': '0.00',
          'actual': '0.00',
          'is_matched': true,
        },
        'pt_unearned': <String, dynamic>{
          'preview': '0.00',
          'actual': '0.00',
          'is_matched': true,
        },
        'tax_match': <String, dynamic>{
          'gym_rate': '18.00',
          'default_code': 'gst_18',
          'default_rate': '18.00',
          'is_matched': true,
        },
        'payment_methods': <dynamic>[],
      };

      when(
        () => mockDataSource.getGoLiveChecklist(
          goLiveDate: any(named: 'goLiveDate'),
        ),
      ).thenAnswer((_) async => tJson);

      final result = await repository.getGoLiveChecklist(
        goLiveDate: DateTime.utc(2026, 3, 1),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected Right'),
        (checklist) {
          expect(checklist.isPostingEnabled, isTrue);
          expect(checklist.canEnable, isTrue);
          expect(checklist.failingReasons, isEmpty);
        },
      );
    });

    test('getGoLiveChecklist maps thrown error to Left(Failure)', () async {
      when(
        () => mockDataSource.getGoLiveChecklist(
          goLiveDate: any(named: 'goLiveDate'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getGoLiveChecklist();

      expect(result.isLeft(), isTrue);
    });

    test('mapPaymentMethodAccount returns Right(GoLivePaymentMethodMapping)',
        () async {
      final tJson = <String, dynamic>{
        'id': 2,
        'method_name': 'Bank Transfer',
        'is_active': true,
        'is_digital': true,
        'account_id': 1020,
        'account_code': '1020',
        'account_name': 'HDFC Bank',
      };

      when(
        () => mockDataSource.mapPaymentMethodAccount(
          paymentMethodId: 2,
          accountId: 1020,
        ),
      ).thenAnswer((_) async => tJson);

      final result = await repository.mapPaymentMethodAccount(
        paymentMethodId: 2,
        accountId: 1020,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected Right'),
        (mapping) {
          expect(mapping.id, 2);
          expect(mapping.accountId, 1020);
        },
      );
    });

    test('enablePosting returns Right(bool)', () async {
      when(
        () => mockDataSource.enablePosting(
          goLiveDate: any(named: 'goLiveDate'),
        ),
      ).thenAnswer((_) async => true);

      final result = await repository.enablePosting(
        goLiveDate: DateTime.utc(2026, 3, 1),
      );

      expect(result, const Right(true));
    });

    test('enablePosting returns Left(Failure) on exception', () async {
      when(
        () => mockDataSource.enablePosting(
          goLiveDate: any(named: 'goLiveDate'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 400,
            data: {'message': 'Checks failed'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.enablePosting();

      expect(result.isLeft(), isTrue);
    });
  });
}
