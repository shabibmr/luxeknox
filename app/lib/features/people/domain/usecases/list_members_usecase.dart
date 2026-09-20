import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member_filter.dart';
import '../entities/profile_summary.dart';
import '../repositories/people_repository.dart';

class ListMembersParams extends Equatable {
  const ListMembersParams({this.filter = const MemberFilter(), this.cursor});

  final MemberFilter filter;
  final String? cursor;

  @override
  List<Object?> get props => [filter, cursor];
}

@lazySingleton
class ListMembersUseCase
    implements UseCase<CursorPage<ProfileSummary>, ListMembersParams> {
  const ListMembersUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, CursorPage<ProfileSummary>>> call(
    ListMembersParams params,
  ) {
    return _repository.listMembers(params.filter, params.cursor);
  }
}
