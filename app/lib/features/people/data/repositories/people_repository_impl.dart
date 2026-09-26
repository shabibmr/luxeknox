import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/employee_status.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/employee_update_input.dart';
import '../../domain/entities/member_filter.dart';
import '../../domain/entities/new_employee_input.dart';
import '../../domain/entities/new_member_input.dart';
import '../../domain/entities/new_trainer_input.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/profile_summary.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/entities/trainer_summary.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasources/people_remote_datasource.dart';
import '../models/people_mapper.dart';

@LazySingleton(as: PeopleRepository)
class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl(this._remote);

  final PeopleRemoteDataSource _remote;

  @override
  Future<Either<Failure, CursorPage<ProfileSummary>>> listMembers(
    MemberFilter filter,
    String? cursor,
  ) async {
    try {
      final page = await _remote.listMembers(
        q: filter.query,
        cursor: cursor,
        assignedTrainerId: filter.assignedTrainerId,
      );
      return Right(
        CursorPage(
          items: page.data.map(profileSummaryFromMember).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Person>> getMember(int id) async {
    try {
      final dossier = await _remote.getMember(id);
      return Right(personFromDossier(dossier));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Person>> createMember(NewMemberInput input) async {
    try {
      final created = await _remote.createMember(memberCreateFromInput(input));
      return Right(personFromMember(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Person>> updateMember(Person person) async {
    try {
      final updated = await _remote.updateMember(
        person.id,
        memberUpdateFromPerson(person),
      );
      return Right(personFromMember(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Person>> assignTrainer({
    required int memberId,
    required int trainerId,
    bool? overrideCapacity,
    String? reason,
  }) async {
    try {
      final updated = await _remote.assignTrainer(
        id: memberId,
        request: api.AssignTrainerRequest(
          (b) => b
            ..trainerId = trainerId
            ..overrideCapacity = overrideCapacity
            ..reason = reason,
        ),
      );
      return Right(personFromMember(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TrainerProfile>> getTrainer(int id) async {
    try {
      final trainer = await _remote.getTrainer(id);
      return Right(trainerProfileFromApi(trainer));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TrainerProfile>> updateTrainer(
    TrainerProfile trainer,
  ) async {
    try {
      final updated = await _remote.updateTrainer(
        trainer.id,
        trainerUpdateFromProfile(trainer),
      );
      return Right(
        trainerProfileFromApi(
          updated,
        ).copyWith(phoneNumber: trainer.phoneNumber),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TrainerProfile>> createTrainer(
    NewTrainerInput input,
  ) async {
    try {
      final created = await _remote.createTrainer(
        trainerCreateFromInput(input),
      );
      return Right(trainerProfileFromApi(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<TrainerSummary>>> listTrainers({
    String? query,
    String? status,
    String? cursor,
  }) async {
    try {
      final offset = cursor == null ? null : int.tryParse(cursor);
      final page = await _remote.listTrainers(
        q: query,
        status: status,
        offset: offset,
      );
      final nextOffset = (offset ?? 0) + page.data.length;
      return Right(
        CursorPage(
          items: page.data.map(trainerSummaryFromApi).toList(),
          nextCursor: page.meta.hasMore ? '$nextOffset' : null,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<EmployeeSummary>>> listEmployees({
    String? query,
    String? status,
    String? cursor,
  }) async {
    try {
      final offset = cursor == null ? null : int.tryParse(cursor);
      final page = await _remote.listEmployees(
        q: query,
        status: status,
        offset: offset,
      );
      final nextOffset = (offset ?? 0) + page.data.length;
      return Right(
        CursorPage(
          items: page.data.map(employeeSummaryFromApi).toList(),
          nextCursor: page.meta.hasMore ? '$nextOffset' : null,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeSummary>> getEmployee(int id) async {
    try {
      final employee = await _remote.getEmployee(id);
      return Right(employeeSummaryFromApi(employee));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeSummary>> createEmployee(
    NewEmployeeInput input,
  ) async {
    try {
      final created = await _remote.createEmployee(
        employeeCreateFromInput(input),
      );
      return Right(employeeSummaryFromApi(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeSummary>> updateEmployee(
    int id,
    EmployeeUpdateInput input,
  ) async {
    try {
      final updated = await _remote.updateEmployeeRaw(
        id,
        employeeUpdateBodyFromInput(input),
      );
      return Right(employeeSummaryFromJson(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeSummary>> setEmployeeStatus(
    int id,
    EmployeeStatus status,
  ) async {
    try {
      final updated = await _remote.setEmployeeStatus(
        id,
        employeeStatusRequestFromDomain(status),
      );
      return Right(employeeSummaryFromApi(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Role>>> listRoles() async {
    try {
      final page = await _remote.listRoles(limit: 100);
      return Right(page.data.map(roleFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmployeeSummary>> assignEmployeeRole({
    required int employeeId,
    required int roleId,
  }) async {
    try {
      final updated = await _remote.assignEmployeeRole(
        id: employeeId,
        assignRoleRequest: assignRoleRequestFromRoleId(roleId),
      );
      return Right(employeeSummaryFromApi(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
