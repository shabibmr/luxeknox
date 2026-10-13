import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vendor.dart';
import '../repositories/accounting_repository.dart';

@lazySingleton
class GetVendorUseCase implements UseCase<Vendor, String> {
  const GetVendorUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Vendor>> call(String id) {
    return _repository.getVendor(id);
  }
}
