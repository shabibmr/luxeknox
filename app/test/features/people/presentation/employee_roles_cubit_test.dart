import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/people/domain/entities/employee_summary.dart';
import 'package:luxeknox/features/people/domain/entities/role.dart';
import 'package:luxeknox/features/people/domain/usecases/assign_employee_role_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_roles_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/employee_roles_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetEmployeeUseCase extends Mock implements GetEmployeeUseCase {}

class MockListRolesUseCase extends Mock implements ListRolesUseCase {}

class MockAssignEmployeeRoleUseCase extends Mock
    implements AssignEmployeeRoleUseCase {}

void main() {
  late MockGetEmployeeUseCase getEmployee;
  late MockListRolesUseCase listRoles;
  late MockAssignEmployeeRoleUseCase assignRole;

  const employee = EmployeeSummary(
    id: 11,
    userId: 22,
    fullName: 'Jane Doe',
    jobTitle: 'Receptionist',
    roleId: 2,
  );

  const roles = [
    Role(id: 1, name: 'Admin', isSystemRole: true),
    Role(id: 2, name: 'Staff', isSystemRole: false),
  ];

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const AssignEmployeeRoleParams(employeeId: 11, roleId: 1),
    );
  });

  setUp(() {
    getEmployee = MockGetEmployeeUseCase();
    listRoles = MockListRolesUseCase();
    assignRole = MockAssignEmployeeRoleUseCase();
  });

  EmployeeRolesCubit buildCubit() =>
      EmployeeRolesCubit(getEmployee, listRoles, assignRole);

  group('EmployeeRolesCubit.load', () {
    blocTest<EmployeeRolesCubit, EmployeeRolesState>(
      'emits loading then success with employee and roles',
      build: buildCubit,
      setUp: () {
        when(() => getEmployee(11)).thenAnswer((_) async => const Right(employee));
        when(() => listRoles(any())).thenAnswer((_) async => const Right(roles));
      },
      act: (cubit) => cubit.load(11),
      expect: () => [
        const EmployeeRolesState(status: LoadStatus.loading),
        const EmployeeRolesState(
          status: LoadStatus.success,
          employee: employee,
          roles: roles,
        ),
      ],
    );

    blocTest<EmployeeRolesCubit, EmployeeRolesState>(
      'emits failure when getEmployee fails',
      build: buildCubit,
      setUp: () {
        when(() => getEmployee(11))
            .thenAnswer((_) async => const Left(NotFoundFailure()));
      },
      act: (cubit) => cubit.load(11),
      expect: () => [
        const EmployeeRolesState(status: LoadStatus.loading),
        const EmployeeRolesState(
          status: LoadStatus.failure,
          failure: NotFoundFailure(),
        ),
      ],
    );

    blocTest<EmployeeRolesCubit, EmployeeRolesState>(
      'emits failure when listRoles fails',
      build: buildCubit,
      setUp: () {
        when(() => getEmployee(11)).thenAnswer((_) async => const Right(employee));
        when(() => listRoles(any()))
            .thenAnswer((_) async => const Left(NotFoundFailure()));
      },
      act: (cubit) => cubit.load(11),
      expect: () => [
        const EmployeeRolesState(status: LoadStatus.loading),
        const EmployeeRolesState(
          status: LoadStatus.failure,
          failure: NotFoundFailure(),
        ),
      ],
    );
  });

  group('EmployeeRolesCubit.assignRole', () {
    const updatedEmployee = EmployeeSummary(
      id: 11,
      userId: 22,
      fullName: 'Jane Doe',
      jobTitle: 'Receptionist',
      roleId: 1,
    );

    blocTest<EmployeeRolesCubit, EmployeeRolesState>(
      'assigns role and emits assigned: true',
      build: buildCubit,
      seed: () => const EmployeeRolesState(
        status: LoadStatus.success,
        employee: employee,
        roles: roles,
      ),
      setUp: () {
        when(() => assignRole(any()))
            .thenAnswer((_) async => const Right(updatedEmployee));
      },
      act: (cubit) => cubit.assignRole(1),
      expect: () => [
        const EmployeeRolesState(
          status: LoadStatus.success,
          employee: employee,
          roles: roles,
          assigning: true,
        ),
        const EmployeeRolesState(
          status: LoadStatus.success,
          employee: updatedEmployee,
          roles: roles,
          assigned: true,
        ),
      ],
    );
  });
}
