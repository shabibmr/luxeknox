import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/employee_summary.dart';
import '../entities/member_filter.dart';
import '../entities/person.dart';
import '../entities/profile_summary.dart';
import '../entities/trainer_summary.dart';

/// Members, trainers, and employees directories plus member dossier/update.
abstract class PeopleRepository {
  Future<Either<Failure, CursorPage<ProfileSummary>>> listMembers(
    MemberFilter filter,
    String? cursor,
  );

  Future<Either<Failure, Person>> getMember(int id);

  Future<Either<Failure, Person>> updateMember(Person person);

  Future<Either<Failure, Person>> assignTrainer({
    required int memberId,
    required int trainerId,
    bool? overrideCapacity,
    String? reason,
  });

  Future<Either<Failure, CursorPage<TrainerSummary>>> listTrainers({
    String? query,
    String? cursor,
  });

  Future<Either<Failure, CursorPage<EmployeeSummary>>> listEmployees({
    String? query,
    String? cursor,
  });
}
