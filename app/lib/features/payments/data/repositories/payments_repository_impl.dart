import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payments_repository.dart';
import '../datasources/payments_remote_datasource.dart';
import '../models/payments_mappers.dart';

@LazySingleton(as: PaymentsRepository)
class PaymentsRepositoryImpl implements PaymentsRepository {
  PaymentsRepositoryImpl(this._remoteDataSource);

  final PaymentsRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<Payment>>> getPayments({
    String? memberId,
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final page = await _remoteDataSource.listPayments(
        memberId: memberId == null ? null : int.tryParse(memberId),
        status: status,
        limit: limit,
        offset: offset,
      );
      return Right(
        CursorPage<Payment>(
          items: page.data.map((p) => p.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<Payment>>> getOutstanding({
    int? limit,
    int? offset,
  }) async {
    try {
      final page = await _remoteDataSource.listOutstandingPayments(
        limit: limit,
        offset: offset,
      );
      return Right(
        CursorPage<Payment>(
          items: page.data.map((p) => p.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Payment>> getPayment(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getPayment(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final page = await _remoteDataSource.listPaymentMethods();
      return Right(page.data.map((m) => m.toDomain()).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaymentMethod>> createPaymentMethod({
    required String methodName,
    bool? isDigital,
    bool? isActive,
  }) async {
    try {
      final created = await _remoteDataSource.createPaymentMethod(
        toPaymentMethodWrite(
          methodName: methodName,
          isDigital: isDigital,
          isActive: isActive,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
