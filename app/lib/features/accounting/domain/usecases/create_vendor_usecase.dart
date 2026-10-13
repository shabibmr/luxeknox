import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vendor.dart';
import '../repositories/accounting_repository.dart';

class CreateVendorParams extends Equatable {
  const CreateVendorParams({
    required this.name,
    this.phone,
    this.email,
    this.gstin,
    this.isActive = true,
  });

  final String name;
  final String? phone;
  final String? email;
  final String? gstin;
  final bool? isActive;

  @override
  List<Object?> get props => [name, phone, email, gstin, isActive];
}

@lazySingleton
class CreateVendorUseCase implements UseCase<Vendor, CreateVendorParams> {
  const CreateVendorUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Vendor>> call(CreateVendorParams params) {
    return _repository.createVendor(
      name: params.name,
      phone: params.phone,
      email: params.email,
      gstin: params.gstin,
      isActive: params.isActive,
    );
  }
}
