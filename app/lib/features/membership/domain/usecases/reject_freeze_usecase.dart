import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_freeze.dart';
import '../repositories/membership_repository.dart';

class RejectFreezeParams extends Equatable {
  const RejectFreezeParams({required this.freezeId, this.reason});

  final String freezeId;
  final String? reason;

  @override
  List<Object?> get props => [freezeId, reason];
}

@lazySingleton
class RejectFreezeUseCase
    implements UseCase<MembershipFreeze, RejectFreezeParams> {
  const RejectFreezeUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, MembershipFreeze>> call(RejectFreezeParams params) {
    return _repository.rejectFreeze(params.freezeId, reason: params.reason);
  }
}
