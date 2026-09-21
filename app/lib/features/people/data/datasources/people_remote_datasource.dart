import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PeopleRemoteDataSource {
  Future<api.MemberPage> listMembers({
    String? q,
    String? cursor,
    int? limit,
    int? assignedTrainerId,
    String? membershipStatus,
  });

  Future<api.MemberDossier> getMember(int id);

  Future<api.Member> updateMember(int id, api.MemberUpdate update);

  Future<api.Member> assignTrainer({
    required int id,
    required api.AssignTrainerRequest request,
  });

  Future<api.TrainerPage> listTrainers({
    String? q,
    int? limit,
    int? offset,
  });

  Future<api.EmployeePage> listEmployees({
    String? q,
    int? limit,
    int? offset,
  });
}

@LazySingleton(as: PeopleRemoteDataSource)
class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  PeopleRemoteDataSourceImpl(this._peopleApi);

  final api.PEOPLEApi _peopleApi;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.MemberPage> listMembers({
    String? q,
    String? cursor,
    int? limit,
    int? assignedTrainerId,
    String? membershipStatus,
  }) async {
    return _unwrap(
      await _peopleApi.listMembers(
        q: q,
        cursor: cursor,
        limit: limit,
        assignedTrainerId: assignedTrainerId,
        membershipStatus: membershipStatus,
      ),
    );
  }

  @override
  Future<api.MemberDossier> getMember(int id) async {
    return _unwrap(await _peopleApi.getMember(id: id));
  }

  @override
  Future<api.Member> updateMember(int id, api.MemberUpdate update) async {
    return _unwrap(
      await _peopleApi.updateMember(id: id, memberUpdate: update),
    );
  }

  @override
  Future<api.Member> assignTrainer({
    required int id,
    required api.AssignTrainerRequest request,
  }) async {
    return _unwrap(
      await _peopleApi.assignTrainer(id: id, assignTrainerRequest: request),
    );
  }

  @override
  Future<api.TrainerPage> listTrainers({
    String? q,
    int? limit,
    int? offset,
  }) async {
    return _unwrap(
      await _peopleApi.listTrainers(q: q, limit: limit, offset: offset),
    );
  }

  @override
  Future<api.EmployeePage> listEmployees({
    String? q,
    int? limit,
    int? offset,
  }) async {
    return _unwrap(
      await _peopleApi.listEmployees(q: q, limit: limit, offset: offset),
    );
  }
}
