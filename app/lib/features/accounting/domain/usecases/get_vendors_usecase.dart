import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vendor.dart';
import '../repositories/accounting_repository.dart';

class GetVendorsParams extends Equatable {
  const GetVendorsParams({
    this.limit,
    this.offset,
    this.isActive,
    this.search,
  });

  final int? limit;
  final int? offset;
  final bool? isActive;
  final String? search;

  @override
  List<Object?> get props => [limit, offset, isActive, search];
}

@lazySingleton
class GetVendorsUseCase
    implements UseCase<CursorPage<Vendor>, GetVendorsParams> {
  const GetVendorsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Vendor>>> call(GetVendorsParams params) {
    return _repository.getVendors(
      limit: params.limit,
      offset: params.offset,
      isActive: params.isActive,
      search: params.search,
    );
  }
}
