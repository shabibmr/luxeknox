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

  Future<api.Member> createMember(api.MemberCreate memberCreate);

  Future<api.Member> updateMember(int id, api.MemberUpdate update);

  Future<api.Member> assignTrainer({
    required int id,
    required api.AssignTrainerRequest request,
  });

  Future<api.Trainer> getTrainer(int id);

  Future<api.Trainer> updateTrainer(int id, api.TrainerUpdate update);

  Future<api.TrainerPage> listTrainers({String? q, int? limit, int? offset});

  Future<api.EmployeePage> listEmployees({String? q, int? limit, int? offset});

  Future<api.Employee> getEmployee(int id);

  Future<api.RolePage> listRoles({int? limit, int? offset});

  Future<api.Employee> assignEmployeeRole({
    required int id,
    required api.AssignRoleRequest request,
  });
}

@LazySingleton(as: PeopleRemoteDataSource)
class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  PeopleRemoteDataSourceImpl(this._peopleApi, this._rbacApi);

  final api.PEOPLEApi _peopleApi;
  final api.RBACApi _rbacApi;

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
  Future<api.Member> createMember(api.MemberCreate memberCreate) async {
    return _unwrap(await _peopleApi.createMember(memberCreate: memberCreate));
  }

  @override
  Future<api.Member> updateMember(int id, api.MemberUpdate update) async {
    return _unwrap(await _peopleApi.updateMember(id: id, memberUpdate: update));
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
  Future<api.Trainer> getTrainer(int id) async {
    return _unwrap(await _peopleApi.getTrainer(id: id));
  }

  @override
  Future<api.Trainer> updateTrainer(int id, api.TrainerUpdate update) async {
    return _unwrap(
      await _peopleApi.updateTrainer(id: id, trainerUpdate: update),
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

  @override
  Future<api.Employee> getEmployee(int id) async {
    return _unwrap(await _peopleApi.getEmployee(id: id));
  }

  @override
  Future<api.RolePage> listRoles({int? limit, int? offset}) async {
    return _unwrap(await _rbacApi.listRoles(limit: limit, offset: offset));
  }

  @override
  Future<api.Employee> assignEmployeeRole({
    required int id,
    required api.AssignRoleRequest request,
  }) async {
    return _unwrap(
      await _rbacApi.assignEmployeeRole(id: id, assignRoleRequest: request),
    );
  }
}
