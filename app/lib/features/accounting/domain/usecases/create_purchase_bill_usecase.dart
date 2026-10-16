import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/purchase_bill.dart';
import '../repositories/accounting_repository.dart';

class CreatePurchaseBillParams extends Equatable {
  const CreatePurchaseBillParams({
    required this.vendorId,
    required this.billDate,
    this.dueDate,
    this.supplierInvoiceNo,
    required this.lines,
    this.draft = false,
    this.idempotencyKey,
  });

  final String vendorId;
  final DateTime billDate;
  final DateTime? dueDate;
  final String? supplierInvoiceNo;
  final List<PurchaseBillLine> lines;
  final bool draft;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
    vendorId,
    billDate,
    dueDate,
    supplierInvoiceNo,
    lines,
    draft,
    idempotencyKey,
  ];
}

@lazySingleton
class CreatePurchaseBillUseCase
    implements UseCase<PurchaseBill, CreatePurchaseBillParams> {
  const CreatePurchaseBillUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, PurchaseBill>> call(CreatePurchaseBillParams params) {
    return _repository.createPurchaseBill(
      vendorId: params.vendorId,
      billDate: params.billDate,
      dueDate: params.dueDate,
      supplierInvoiceNo: params.supplierInvoiceNo,
      lines: params.lines,
      draft: params.draft,
      idempotencyKey: params.idempotencyKey,
    );
  }
}
