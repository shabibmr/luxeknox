import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/go_live.dart';
import '../repositories/accounting_repository.dart';

class MapPaymentMethodAccountParams extends Equatable {
  const MapPaymentMethodAccountParams({
    required this.paymentMethodId,
    required this.accountId,
  });

  final int paymentMethodId;
  final int? accountId;

  @override
  List<Object?> get props => [paymentMethodId, accountId];
}

@lazySingleton
class MapPaymentMethodAccountUseCase
    implements
        UseCase<GoLivePaymentMethodMapping, MapPaymentMethodAccountParams> {
  const MapPaymentMethodAccountUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, GoLivePaymentMethodMapping>> call(
    MapPaymentMethodAccountParams params,
  ) {
    return _repository.mapPaymentMethodAccount(
      paymentMethodId: params.paymentMethodId,
      accountId: params.accountId,
    );
  }
}
