import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership.dart';
import '../repositories/membership_repository.dart';

class CreateMembershipParams extends Equatable {
  const CreateMembershipParams({
    required this.memberId,
    required this.productId,
    required this.startDate,
    this.lockerNumber,
    this.autoRenew,
  });

  final String memberId;
  final String productId;
  final DateTime startDate;
  final String? lockerNumber;
  final bool? autoRenew;

  @override
  List<Object?> get props => [
    memberId,
    productId,
    startDate,
    lockerNumber,
    autoRenew,
  ];
}

@lazySingleton
class CreateMembershipUseCase
    implements UseCase<Membership, CreateMembershipParams> {
  const CreateMembershipUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, Membership>> call(CreateMembershipParams params) {
    return _repository.createMembership(
      memberId: params.memberId,
      productId: params.productId,
      startDate: params.startDate,
      lockerNumber: params.lockerNumber,
      autoRenew: params.autoRenew,
    );
  }
}
