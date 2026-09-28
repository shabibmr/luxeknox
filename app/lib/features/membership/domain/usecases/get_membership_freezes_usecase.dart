import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_freeze.dart';
import '../repositories/membership_repository.dart';

@lazySingleton
class GetMembershipFreezesUseCase
    implements UseCase<CursorPage<MembershipFreeze>, String> {
  const GetMembershipFreezesUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, CursorPage<MembershipFreeze>>> call(
    String membershipId,
  ) {
    return _repository.getFreezes(membershipId);
  }
}
