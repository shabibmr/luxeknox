import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership.dart';
import '../repositories/membership_repository.dart';
import 'renew_membership_usecase.dart';

@lazySingleton
class UpgradeMembershipUseCase
    implements UseCase<Membership, MembershipActionParams> {
  const UpgradeMembershipUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, Membership>> call(MembershipActionParams params) {
    final productId = params.productId;
    if (productId == null) {
      throw ArgumentError('productId is required for upgrade');
    }
    return _repository.upgrade(
      params.membershipId,
      productId: productId,
      rowVersion: params.rowVersion,
      reason: params.reason,
    );
  }
}
