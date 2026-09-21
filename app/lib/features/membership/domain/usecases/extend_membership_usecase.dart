import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_extension.dart';
import '../repositories/membership_repository.dart';

class ExtendMembershipParams extends Equatable {
  const ExtendMembershipParams({
    required this.membershipId,
    required this.daysExtended,
    this.reason,
  });

  final String membershipId;
  final int daysExtended;
  final String? reason;

  @override
  List<Object?> get props => [membershipId, daysExtended, reason];
}

@lazySingleton
class ExtendMembershipUseCase
    implements UseCase<MembershipExtension, ExtendMembershipParams> {
  const ExtendMembershipUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, MembershipExtension>> call(
    ExtendMembershipParams params,
  ) {
    return _repository.extend(
      params.membershipId,
      daysExtended: params.daysExtended,
      reason: params.reason,
    );
  }
}
