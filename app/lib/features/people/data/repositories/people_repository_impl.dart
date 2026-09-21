import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/member_filter.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/profile_summary.dart';
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
  Future<Either<Failure, CursorPage<TrainerSummary>>> listTrainers({
    String? query,
    String? cursor,
  }) async {
    try {
      final offset = cursor == null ? null : int.tryParse(cursor);
      final page = await _remote.listTrainers(q: query, offset: offset);
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
    String? cursor,
  }) async {
    try {
      final offset = cursor == null ? null : int.tryParse(cursor);
      final page = await _remote.listEmployees(q: query, offset: offset);
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
}
