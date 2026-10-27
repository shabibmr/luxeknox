import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/network/error_interceptor.dart';
import '../../domain/entities/counter_sale.dart';
import '../../domain/entities/create_counter_sale_input.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(this._remote);

  final InventoryRemoteDataSource _remote;

  @override
  Future<Either<Failure, CounterSale>> createCounterSale(
    CreateCounterSaleInput input,
  ) async {
    try {
      final json = await _remote.createCounterSale(input);
      return Right(_mapSale(json));
    } catch (e) {
      return Left(_mapCreateFailure(e));
    }
  }

  Failure _mapCreateFailure(Object e) {
    final details = _extractDetails(e);
    final rule = _firstRule(details);
    if (rule != null) {
      switch (rule['rule']) {
        case 'insufficient_stock':
          final available = rule['available']?.toString() ?? '';
          return BusinessRuleFailure(
            available.isEmpty
                ? 'Insufficient stock on hand'
                : 'Only $available available',
          );
        case 'tender_total_mismatch':
          final expected = rule['expected']?.toString() ?? '';
          return BusinessRuleFailure(
            expected.isEmpty
                ? 'Tender total does not match the sale total'
                : 'Expected total $expected',
          );
        case 'payment_method_unmapped':
          return const BusinessRuleFailure(
            'Map this payment method in Go-live setup',
          );
      }
    }
    return mapThrownToFailure(e);
  }

  List<dynamic> _extractDetails(Object e) {
    Response<dynamic>? response;
    if (e is DioException) {
      if (e.error is FailureDioException) {
        response = (e.error! as FailureDioException).original.response;
      }
      response ??= e.response;
    }
    final body = response?.data;
    if (body is Map && body['details'] is List) {
      return body['details'] as List<dynamic>;
    }
    return const [];
  }

  Map<String, dynamic>? _firstRule(List<dynamic> details) {
    for (final entry in details) {
      if (entry is Map) {
        return Map<String, dynamic>.from(entry);
      }
    }
    return null;
  }

  CounterSale _mapSale(Map<String, dynamic> json) {
    final tendersRaw = json['tenders'];
    final tenders = <CounterSaleTender>[];
    if (tendersRaw is List) {
      for (final row in tendersRaw) {
        if (row is! Map) continue;
        final map = Map<String, dynamic>.from(row);
        tenders.add(
          CounterSaleTender(
            paymentMethodId: (map['payment_method_id'] as num).toInt(),
            paymentMethodName: map['payment_method_name']?.toString() ?? '',
            amount: map['amount']?.toString() ?? '0.00',
          ),
        );
      }
    }
    return CounterSale(
      id: (json['id'] as num).toInt(),
      saleNumber: json['sale_number']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0.00',
      tenders: tenders,
    );
  }
}
