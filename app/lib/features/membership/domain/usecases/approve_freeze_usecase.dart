import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_freeze.dart';
import '../repositories/membership_repository.dart';

@lazySingleton
class ApproveFreezeUseCase implements UseCase<MembershipFreeze, String> {
  const ApproveFreezeUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, MembershipFreeze>> call(String freezeId) {
    return _repository.approveFreeze(freezeId);
  }
}
