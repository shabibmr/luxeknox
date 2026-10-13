import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vendor.dart';
import '../repositories/accounting_repository.dart';

class UpdateVendorParams extends Equatable {
  const UpdateVendorParams({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.gstin,
    this.isActive,
  });

  final String id;
  final String? name;
  final String? phone;
  final String? email;
  final String? gstin;
  final bool? isActive;

  @override
  List<Object?> get props => [id, name, phone, email, gstin, isActive];
}

@lazySingleton
class UpdateVendorUseCase implements UseCase<Vendor, UpdateVendorParams> {
  const UpdateVendorUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Vendor>> call(UpdateVendorParams params) {
    return _repository.updateVendor(
      id: params.id,
      name: params.name,
      phone: params.phone,
      email: params.email,
      gstin: params.gstin,
      isActive: params.isActive,
    );
  }
}
