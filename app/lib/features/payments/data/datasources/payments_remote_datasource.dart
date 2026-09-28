import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PaymentsRemoteDataSource {
  Future<api.PaymentPage> listPayments({
    int? limit,
    int? offset,
    int? memberId,
    String? status,
  });

  Future<api.PaymentPage> listOutstandingPayments({
    int? limit,
    int? offset,
  });

  Future<api.Payment> getPayment(int id);

  Future<api.PaymentMethodPage> listPaymentMethods();

  Future<api.PaymentMethod> createPaymentMethod(
    api.PaymentMethodWrite write,
  );
}

@LazySingleton(as: PaymentsRemoteDataSource)
class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  PaymentsRemoteDataSourceImpl(this._payApi);

  final api.PAYApi _payApi;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.PaymentPage> listPayments({
    int? limit,
    int? offset,
    int? memberId,
    String? status,
  }) async {
    return _unwrap(
      await _payApi.listPayments(
        limit: limit,
        offset: offset,
        memberId: memberId,
        status: status,
      ),
    );
  }

  @override
  Future<api.PaymentPage> listOutstandingPayments({
    int? limit,
    int? offset,
  }) async {
    return _unwrap(
      await _payApi.listOutstandingPayments(limit: limit, offset: offset),
    );
  }

  @override
  Future<api.Payment> getPayment(int id) async {
    return _unwrap(await _payApi.getPayment(id: id));
  }

  @override
  Future<api.PaymentMethodPage> listPaymentMethods() async {
    return _unwrap(await _payApi.listPaymentMethods());
  }

  @override
  Future<api.PaymentMethod> createPaymentMethod(
    api.PaymentMethodWrite write,
  ) async {
    return _unwrap(
      await _payApi.createPaymentMethod(paymentMethodWrite: write),
    );
  }
}
