import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/people/domain/entities/employee_status.dart';
import 'package:luxeknox/features/people/domain/entities/employee_summary.dart';
import 'package:luxeknox/features/people/domain/entities/employee_update_input.dart';
import 'package:luxeknox/features/people/domain/entities/new_employee_input.dart';
import 'package:luxeknox/features/people/domain/entities/role.dart';
import 'package:luxeknox/features/people/domain/usecases/create_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_roles_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/set_employee_status_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_employee_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/employee_form_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateEmployeeUseCase extends Mock implements CreateEmployeeUseCase {}

class MockUpdateEmployeeUseCase extends Mock implements UpdateEmployeeUseCase {}

class MockGetEmployeeUseCase extends Mock implements GetEmployeeUseCase {}

class MockListRolesUseCase extends Mock implements ListRolesUseCase {}

class MockSetEmployeeStatusUseCase extends Mock
    implements SetEmployeeStatusUseCase {}

void main() {
  late MockCreateEmployeeUseCase createEmployee;
  late MockUpdateEmployeeUseCase updateEmployee;
  late MockGetEmployeeUseCase getEmployee;
  late MockListRolesUseCase listRoles;
  late MockSetEmployeeStatusUseCase setEmployeeStatus;
  late EmployeeFormCubit cubit;

  const created = EmployeeSummary(
    id: 11,
    userId: 22,
    fullName: 'Ada Lovelace',
    jobTitle: 'Front desk',
    roleId: 3,
    email: 'ada@example.com',
    status: 'active',
  );

  const roles = [
    Role(id: 3, name: 'Employee / Front Desk', isSystemRole: false),
    Role(id: 4, name: 'Manager', isSystemRole: true),
  ];

  setUpAll(() {
    registerFallbackValue(const NewEmployeeInput(email: 'a@b.c', roleId: 1));
    registerFallbackValue(
      const UpdateEmployeeParams(id: 1, input: EmployeeUpdateInput()),
    );
    registerFallbackValue(
      const SetEmployeeStatusParams(id: 1, status: EmployeeStatus.active),
    );
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    createEmployee = MockCreateEmployeeUseCase();
    updateEmployee = MockUpdateEmployeeUseCase();
    getEmployee = MockGetEmployeeUseCase();
    listRoles = MockListRolesUseCase();
    setEmployeeStatus = MockSetEmployeeStatusUseCase();
    when(() => listRoles(any())).thenAnswer((_) async => const Right(roles));
    cubit = EmployeeFormCubit(
      createEmployee,
      updateEmployee,
      getEmployee,
      listRoles,
      setEmployeeStatus,
    );
  });

  tearDown(() => cubit.close());

  test('initCreate loads roles and defaults roleId to Employee / Front Desk role', () async {
    await cubit.initCreate();
    expect(cubit.state.mode, EmployeeFormMode.create);
    expect(cubit.state.roles, roles);
    expect(cubit.state.createInput.roleId, 3);
    expect(cubit.state.rolesLoading, isFalse);
  });

  test('submit validates required create fields before calling use case', () async {
    await cubit.initCreate();
    final ok = await cubit.submit();
    expect(ok, isFalse);
    expect(cubit.state.error, PeopleStrings.firstNameRequired);
    verifyNever(() => createEmployee(any()));
  });

  test('submit succeeds and stores created employee', () async {
    when(() => createEmployee(any())).thenAnswer((_) async => const Right(created));
    await cubit.initCreate();

    cubit.updateCreateInput(
      (i) => i.copyWith(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret1',
        jobTitle: 'Front desk',
        roleId: 3,
      ),
    );

    final ok = await cubit.submit();
    expect(ok, isTrue);
    expect(cubit.state.saved, created);
    expect(cubit.state.submitting, isFalse);
    verify(() => createEmployee(any())).called(1);
  });

  test('double-submit while in flight is ignored', () async {
    when(() => createEmployee(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return const Right(created);
    });
    await cubit.initCreate();

    cubit.updateCreateInput(
      (i) => i.copyWith(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret1',
        jobTitle: 'Front desk',
        roleId: 3,
      ),
    );

    final first = cubit.submit();
    final second = await cubit.submit();
    expect(second, isFalse);
    expect(await first, isTrue);
    verify(() => createEmployee(any())).called(1);
  });

  test('maps failure message on create error', () async {
    when(() => createEmployee(any())).thenAnswer(
      (_) async => const Left(ConflictFailure()),
    );
    await cubit.initCreate();

    cubit.updateCreateInput(
      (i) => i.copyWith(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret1',
        jobTitle: 'Front desk',
        roleId: 3,
      ),
    );

    final ok = await cubit.submit();
    expect(ok, isFalse);
    expect(cubit.state.saved, isNull);
    expect(cubit.state.error, isNotNull);
  });

  test('initEdit prefills update input from employee including hireDate', () async {
    final loaded = EmployeeSummary(
      id: 11,
      userId: 22,
      fullName: 'Ada Lovelace',
      jobTitle: 'Front desk',
      department: 'Ops',
      roleId: 3,
      email: 'ada@example.com',
      status: 'active',
      hireDate: DateTime(2024, 1, 15),
    );
    when(() => getEmployee(11)).thenAnswer((_) async => Right(loaded));
    await cubit.initEdit(11);
    expect(cubit.state.mode, EmployeeFormMode.edit);
    expect(cubit.state.employeeId, 11);
    expect(cubit.state.loadedEmployee, loaded);
    expect(cubit.state.updateInput.jobTitle, 'Front desk');
    expect(cubit.state.updateInput.department, 'Ops');
    expect(cubit.state.updateInput.hireDate, DateTime(2024, 1, 15));
    expect(cubit.state.isDirty, isFalse);
  });

  test('edit submit updates employee', () async {
    when(() => getEmployee(11)).thenAnswer((_) async => const Right(created));
    when(() => updateEmployee(any())).thenAnswer((_) async => const Right(created));
    await cubit.initEdit(11);
    cubit.updateEditInput((i) => i.copyWith(jobTitle: 'Manager'));

    final ok = await cubit.submit();
    expect(ok, isTrue);
    expect(cubit.state.saved, created);
    verify(() => updateEmployee(any())).called(1);
  });

  test('copyWith can clear optional edit fields', () {
    final input = EmployeeUpdateInput(
      jobTitle: 'Desk',
      department: 'Ops',
      hireDate: DateTime(2024, 1, 1),
    ).copyWith(
      department: null,
      hireDate: null,
    );
    expect(input.department, isNull);
    expect(input.hireDate, isNull);
    expect(input.jobTitle, 'Desk');
  });

  test('changeStatus calls setEmployeeStatus and updates loaded employee', () async {
    when(() => getEmployee(11)).thenAnswer((_) async => const Right(created));
    when(() => setEmployeeStatus(any())).thenAnswer(
      (_) async => Right(
        created.copyWithStatus('suspended'),
      ),
    );
    await cubit.initEdit(11);

    final ok = await cubit.changeStatus(EmployeeStatus.suspended);
    expect(ok, isTrue);
    expect(cubit.state.loadedEmployee?.status, 'suspended');
    verify(() => setEmployeeStatus(any())).called(1);
  });

  test('statusRequiresConfirm only for suspend and terminate', () {
    expect(EmployeeFormCubit.statusRequiresConfirm(EmployeeStatus.active), isFalse);
    expect(
      EmployeeFormCubit.statusRequiresConfirm(EmployeeStatus.onProbation),
      isFalse,
    );
    expect(
      EmployeeFormCubit.statusRequiresConfirm(EmployeeStatus.suspended),
      isTrue,
    );
    expect(
      EmployeeFormCubit.statusRequiresConfirm(EmployeeStatus.terminated),
      isTrue,
    );
  });
}

extension on EmployeeSummary {
  EmployeeSummary copyWithStatus(String status) {
    return EmployeeSummary(
      id: id,
      userId: userId,
      fullName: fullName,
      jobTitle: jobTitle,
      department: department,
      status: status,
      roleId: roleId,
      email: email,
      phoneNumber: phoneNumber,
      hireDate: hireDate,
    );
  }
}
