import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_history_entry.dart';
import '../repositories/membership_repository.dart';

class GetMembershipHistoryParams extends Equatable {
  const GetMembershipHistoryParams({
    required this.membershipId,
    this.cursor,
    this.limit,
  });

  final String membershipId;
  final String? cursor;
  final int? limit;

  @override
  List<Object?> get props => [membershipId, cursor, limit];
}

@lazySingleton
class GetMembershipHistoryUseCase
    implements
        UseCase<CursorPage<MembershipHistoryEntry>, GetMembershipHistoryParams> {
  const GetMembershipHistoryUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, CursorPage<MembershipHistoryEntry>>> call(
    GetMembershipHistoryParams params,
  ) {
    return _repository.getHistory(
      params.membershipId,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}
