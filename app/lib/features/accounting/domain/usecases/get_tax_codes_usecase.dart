import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/tax_code.dart';
import '../repositories/accounting_repository.dart';

class GetTaxCodesParams extends Equatable {
  const GetTaxCodesParams({
    this.limit,
    this.offset,
    this.isActive,
  });

  final int? limit;
  final int? offset;
  final bool? isActive;

  @override
  List<Object?> get props => [limit, offset, isActive];
}

@lazySingleton
class GetTaxCodesUseCase
    implements UseCase<CursorPage<TaxCode>, GetTaxCodesParams> {
  const GetTaxCodesUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<TaxCode>>> call(GetTaxCodesParams params) {
    return _repository.getTaxCodes(
      limit: params.limit,
      offset: params.offset,
      isActive: params.isActive,
    );
  }
}
