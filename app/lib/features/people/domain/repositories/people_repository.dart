import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/member_filter.dart';
import '../entities/person.dart';
import '../entities/profile_summary.dart';

/// Members: list/search (admin, trainer-scoped) and single-member dossier.
abstract class PeopleRepository {
  Future<Either<Failure, CursorPage<ProfileSummary>>> listMembers(
    MemberFilter filter,
    String? cursor,
  );

  Future<Either<Failure, Person>> getMember(int id);

  Future<Either<Failure, Person>> updateMember(Person person);
}
