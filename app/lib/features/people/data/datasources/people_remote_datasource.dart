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

  Future<api.Trainer> createTrainer(api.TrainerCreate trainerCreate);

  Future<api.TrainerPage> listTrainers({
    String? q,
    String? status,
    int? limit,
    int? offset,
  });

  Future<api.EmployeePage> listEmployees({
    String? q,
    String? status,
    String? department,
    int? limit,
    int? offset,
  });

  Future<api.Employee> getEmployee(int id);

  Future<api.Employee> createEmployee(api.EmployeeCreate employeeCreate);

  /// Raw PATCH so null `department` / `hire_date` clear (typed client omits nulls).
  Future<Map<String, dynamic>> updateEmployeeRaw(
    int id,
    Map<String, dynamic> body,
  );

  Future<api.Employee> setEmployeeStatus(
    int id,
    api.EmployeeStatusRequest request,
  );

  Future<api.RolePage> listRoles({int? limit, int? offset});

  Future<api.Employee> assignEmployeeRole({
    required int id,
    required api.AssignRoleRequest assignRoleRequest,
  });
}

@LazySingleton(as: PeopleRemoteDataSource)
class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  PeopleRemoteDataSourceImpl(this._peopleApi, this._rbacApi, this._dio);

  final api.PEOPLEApi _peopleApi;
  final api.RBACApi _rbacApi;
  final Dio _dio;

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
  Future<api.Trainer> createTrainer(api.TrainerCreate trainerCreate) async {
    return _unwrap(
      await _peopleApi.createTrainer(trainerCreate: trainerCreate),
    );
  }

  @override
  Future<api.TrainerPage> listTrainers({
    String? q,
    String? status,
    int? limit,
    int? offset,
  }) async {
    final response = await _dio.get<dynamic>(
      '/trainers',
      queryParameters: <String, dynamic>{
        'q': ?((q != null && q.isNotEmpty) ? q : null),
        'status': ?((status != null && status.isNotEmpty && status != 'all')
            ? status
            : null),
        'limit': ?limit,
        'offset': ?offset,
      },
    );
    final data = _asJsonMap(response);
    return api.standardSerializers.deserializeWith(
      api.TrainerPage.serializer,
      data,
    )!;
  }

  Map<String, dynamic> _asJsonMap(Response<dynamic> response) {
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    throw DioException(
      requestOptions: response.requestOptions,
      type: DioExceptionType.badResponse,
      response: response,
      error: 'Expected JSON object, got ${data.runtimeType}',
    );
  }

  @override
  Future<api.EmployeePage> listEmployees({
    String? q,
    String? status,
    String? department,
    int? limit,
    int? offset,
  }) async {
    return _unwrap(
      await _peopleApi.listEmployees(
        q: (q != null && q.isNotEmpty) ? q : null,
        status: _employeeStatusQuery(status),
        department: (department != null && department.isNotEmpty)
            ? department
            : null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  Future<api.Employee> getEmployee(int id) async {
    return _unwrap(await _peopleApi.getEmployee(id: id));
  }

  @override
  Future<api.Employee> createEmployee(api.EmployeeCreate employeeCreate) async {
    return _unwrap(
      await _peopleApi.createEmployee(employeeCreate: employeeCreate),
    );
  }

  @override
  Future<Map<String, dynamic>> updateEmployeeRaw(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.patch<dynamic>('/employees/$id', data: body);
    return _asJsonMap(response);
  }

  @override
  Future<api.Employee> setEmployeeStatus(
    int id,
    api.EmployeeStatusRequest request,
  ) async {
    return _unwrap(
      await _peopleApi.setEmployeeStatus(
        id: id,
        employeeStatusRequest: request,
      ),
    );
  }

  @override
  Future<api.RolePage> listRoles({int? limit, int? offset}) async {
    return _unwrap(await _rbacApi.listRoles(limit: limit, offset: offset));
  }

  @override
  Future<api.Employee> assignEmployeeRole({
    required int id,
    required api.AssignRoleRequest assignRoleRequest,
  }) async {
    return _unwrap(
      await _rbacApi.assignEmployeeRole(
        id: id,
        assignRoleRequest: assignRoleRequest,
      ),
    );
  }

  api.EmployeeStatus? _employeeStatusQuery(String? status) {
    if (status == null || status.isEmpty || status == 'all') return null;
    return switch (status) {
      'active' => api.EmployeeStatus.active,
      'on_probation' => api.EmployeeStatus.onProbation,
      'suspended' => api.EmployeeStatus.suspended,
      'terminated' => api.EmployeeStatus.terminated,
      _ => null,
    };
  }
}
