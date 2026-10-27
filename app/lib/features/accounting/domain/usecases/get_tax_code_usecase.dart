import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/tax_code.dart';
import '../repositories/accounting_repository.dart';

class GetTaxCodeParams extends Equatable {
  const GetTaxCodeParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

@lazySingleton
class GetTaxCodeUseCase implements UseCase<TaxCode, GetTaxCodeParams> {
  const GetTaxCodeUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, TaxCode>> call(GetTaxCodeParams params) {
    return _repository.getTaxCode(params.id);
  }
}
