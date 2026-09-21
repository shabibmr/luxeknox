import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership.dart';
import '../repositories/membership_repository.dart';

@lazySingleton
class GetMembershipUseCase implements UseCase<Membership, String> {
  const GetMembershipUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, Membership>> call(String id) {
    return _repository.getMembership(id);
  }
}
