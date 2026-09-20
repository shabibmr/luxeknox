import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/profile_repository.dart';

class DeleteEmergencyContactParams extends Equatable {
  const DeleteEmergencyContactParams({
    required this.userId,
    required this.contactId,
  });

  final int userId;
  final int contactId;

  @override
  List<Object?> get props => [userId, contactId];
}

@lazySingleton
class DeleteEmergencyContactUseCase
    implements UseCase<void, DeleteEmergencyContactParams> {
  const DeleteEmergencyContactUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, void>> call(DeleteEmergencyContactParams params) {
    return _repository.deleteEmergencyContact(params.userId, params.contactId);
  }
}
