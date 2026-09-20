import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/medical_record.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateMedicalRecordUseCase
    implements UseCase<MedicalRecord, MedicalRecord> {
  const UpdateMedicalRecordUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, MedicalRecord>> call(MedicalRecord record) {
    return _repository.updateMedicalRecord(record);
  }
}
