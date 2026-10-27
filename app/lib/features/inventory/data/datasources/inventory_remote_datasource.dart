import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/create_counter_sale_input.dart';

abstract class InventoryRemoteDataSource {
  /// `POST /inventory/sales` — returns the raw JSON map.
  Future<Map<String, dynamic>> createCounterSale(
    CreateCounterSaleInput input,
  );
}

@LazySingleton(as: InventoryRemoteDataSource)
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  InventoryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> createCounterSale(
    CreateCounterSaleInput input,
  ) async {
    final buyer = input.buyerName?.trim();
    final body = <String, dynamic>{
      if (input.memberId != null) 'member_id': input.memberId,
      if (buyer != null && buyer.isNotEmpty) 'customer_name': buyer,
      'lines': [
        for (final line in input.lines)
          {
            'item_id': line.itemId,
            'quantity': line.quantity,
          },
      ],
      'tenders': [
        for (final tender in input.tenders)
          {
            'payment_method_id': tender.paymentMethodId,
            'amount': tender.amount,
          },
      ],
    };

    final response = await _dio.post<dynamic>(
      '/inventory/sales',
      data: body,
      options: Options(
        headers: input.idempotencyKey == null
            ? null
            : <String, dynamic>{'Idempotency-Key': input.idempotencyKey},
      ),
    );

    final data = response.data;
    if (data is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return Map<String, dynamic>.from(data);
  }
}
