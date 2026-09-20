import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class DeleteMedicalRecordParams extends Equatable {
  const DeleteMedicalRecordParams({
    required this.memberId,
    required this.recordId,
  });

  final int memberId;
  final int recordId;

  @override
  List<Object?> get props => [memberId, recordId];
}

@lazySingleton
class DeleteMedicalRecordUseCase
    implements UseCase<void, DeleteMedicalRecordParams> {
  const DeleteMedicalRecordUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, void>> call(DeleteMedicalRecordParams params) {
    return _repository.deleteMedicalRecord(params.memberId, params.recordId);
  }
}
