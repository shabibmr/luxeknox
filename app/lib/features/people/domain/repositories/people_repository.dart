import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/employee_status.dart';
import '../entities/employee_summary.dart';
import '../entities/employee_update_input.dart';
import '../entities/member_filter.dart';
import '../entities/new_employee_input.dart';
import '../entities/new_member_input.dart';
import '../entities/new_trainer_input.dart';
import '../entities/person.dart';
import '../entities/profile_summary.dart';
import '../entities/role.dart';
import '../entities/trainer_profile.dart';
import '../entities/trainer_summary.dart';

/// Members, trainers, and employees directories plus member dossier/update.
abstract class PeopleRepository {
  Future<Either<Failure, CursorPage<ProfileSummary>>> listMembers(
    MemberFilter filter,
    String? cursor,
  );

  Future<Either<Failure, Person>> getMember(int id);

  Future<Either<Failure, Person>> createMember(NewMemberInput input);

  Future<Either<Failure, Person>> updateMember(Person person);

  Future<Either<Failure, Person>> assignTrainer({
    required int memberId,
    required int trainerId,
    bool? overrideCapacity,
    String? reason,
  });

  Future<Either<Failure, TrainerProfile>> getTrainer(int id);

  Future<Either<Failure, TrainerProfile>> updateTrainer(TrainerProfile trainer);

  Future<Either<Failure, TrainerProfile>> createTrainer(NewTrainerInput input);

  Future<Either<Failure, CursorPage<TrainerSummary>>> listTrainers({
    String? query,
    String? status,
    String? cursor,
  });

  Future<Either<Failure, CursorPage<EmployeeSummary>>> listEmployees({
    String? query,
    String? cursor,
  });

  Future<Either<Failure, EmployeeSummary>> getEmployee(int id);

  Future<Either<Failure, EmployeeSummary>> createEmployee(
    NewEmployeeInput input,
  );

  Future<Either<Failure, EmployeeSummary>> updateEmployee(
    int id,
    EmployeeUpdateInput input,
  );

  Future<Either<Failure, EmployeeSummary>> setEmployeeStatus(
    int id,
    EmployeeStatus status,
  );

  Future<Either<Failure, List<Role>>> listRoles();

  Future<Either<Failure, EmployeeSummary>> assignEmployeeRole({
    required int employeeId,
    required int roleId,
  });
}
