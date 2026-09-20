import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/medical_record.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class CreateMedicalRecordUseCase
    implements UseCase<MedicalRecord, MedicalRecord> {
  const CreateMedicalRecordUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, MedicalRecord>> call(MedicalRecord record) {
    return _repository.createMedicalRecord(record);
  }
}
