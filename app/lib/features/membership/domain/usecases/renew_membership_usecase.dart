import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership.dart';
import '../repositories/membership_repository.dart';

class MembershipActionParams extends Equatable {
  const MembershipActionParams({
    required this.membershipId,
    required this.rowVersion,
    this.productId,
    this.reason,
  });

  final String membershipId;
  final int rowVersion;
  final String? productId;
  final String? reason;

  @override
  List<Object?> get props => [membershipId, rowVersion, productId, reason];
}

@lazySingleton
class RenewMembershipUseCase
    implements UseCase<Membership, MembershipActionParams> {
  const RenewMembershipUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, Membership>> call(MembershipActionParams params) {
    return _repository.renew(
      params.membershipId,
      productId: params.productId,
      rowVersion: params.rowVersion,
      reason: params.reason,
    );
  }
}
