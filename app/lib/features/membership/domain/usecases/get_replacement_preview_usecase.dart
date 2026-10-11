import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_replacement_preview.dart';
import '../repositories/membership_repository.dart';

/// Param is the partner's member id. Right(null) = nothing to replace.
@lazySingleton
class GetReplacementPreviewUseCase
    implements UseCase<MembershipReplacementPreview?, String> {
  const GetReplacementPreviewUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, MembershipReplacementPreview?>> call(
    String memberId,
  ) {
    return _repository.getReplacementPreview(memberId);
  }
}
