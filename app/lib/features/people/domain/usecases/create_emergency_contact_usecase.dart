import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/emergency_contact.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class CreateEmergencyContactUseCase
    implements UseCase<EmergencyContact, EmergencyContact> {
  const CreateEmergencyContactUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, EmergencyContact>> call(EmergencyContact contact) {
    return _repository.createEmergencyContact(contact);
  }
}
