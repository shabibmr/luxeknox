import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/emergency_contact.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class ListEmergencyContactsUseCase
    implements UseCase<List<EmergencyContact>, int> {
  const ListEmergencyContactsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<EmergencyContact>>> call(int userId) {
    return _repository.listEmergencyContacts(userId);
  }
}
