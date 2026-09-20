import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/medical_record.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class ListMedicalRecordsUseCase implements UseCase<List<MedicalRecord>, int> {
  const ListMedicalRecordsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<MedicalRecord>>> call(int memberId) {
    return _repository.listMedicalRecords(memberId);
  }
}
