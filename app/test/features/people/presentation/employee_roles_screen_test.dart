import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/people/domain/entities/employee_summary.dart';
import 'package:luxeknox/features/people/domain/entities/role.dart';
import 'package:luxeknox/features/people/domain/usecases/assign_employee_role_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_roles_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/employee_roles_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/employee_roles_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetEmployeeUseCase extends Mock implements GetEmployeeUseCase {}

class MockListRolesUseCase extends Mock implements ListRolesUseCase {}

class MockAssignEmployeeRoleUseCase extends Mock
    implements AssignEmployeeRoleUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockGetEmployeeUseCase getEmployee;
  late MockListRolesUseCase listRoles;
  late MockAssignEmployeeRoleUseCase assignRole;

  const adminPrincipal = Principal(
    userId: '1',
    userType: UserType.admin,
    displayName: 'Admin User',
    profileId: 'p1',
  );

  const employee = EmployeeSummary(
    id: 11,
    userId: 22,
    fullName: 'Ada Lovelace',
    jobTitle: 'Developer',
    roleId: 2,
  );

  const employeeWithoutJobTitle = EmployeeSummary(
    id: 12,
    userId: 23,
    fullName: 'Alan Turing',
    jobTitle: '',
    roleId: 1,
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

    getIt.registerFactory<EmployeeRolesCubit>(
      () => EmployeeRolesCubit(getEmployee, listRoles, assignRole),
    );
  });

  tearDown(() => getIt.reset());

  Widget wrap(Widget child, {required Capabilities capabilities}) {
    final sessionCubit = MockSessionCubit();
    whenListen(
      sessionCubit,
      const Stream<SessionState>.empty(),
      initialState: SessionAuthenticated(
        principal: adminPrincipal,
        capabilities: capabilities,
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: BlocProvider<SessionCubit>.value(value: sessionCubit, child: child),
    );
  }

  testWidgets('shows noPermission when user lacks roles.update capability', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const EmployeeRolesScreen(employeeId: 11),
        capabilities: const Capabilities(slugs: ['employees.read']),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.employeeRolesTitle), findsOneWidget);
    expect(find.text(PeopleStrings.noPermission), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsNothing);
  });

  testWidgets('renders employee details and roles when authorized', (
    tester,
  ) async {
    when(() => getEmployee(11)).thenAnswer((_) async => const Right(employee));
    when(() => listRoles(any())).thenAnswer((_) async => const Right(roles));

    await tester.pumpWidget(
      wrap(
        const EmployeeRolesScreen(employeeId: 11),
        capabilities: const Capabilities(
          slugs: ['roles.update', 'employees.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.employeeRolesTitle), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Developer'), findsOneWidget);
    expect(find.text(PeopleStrings.currentRole), findsOneWidget);
    expect(find.text('Staff'), findsNWidgets(2));
    expect(find.text(PeopleStrings.availableRoles), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text(PeopleStrings.assign), findsOneWidget);
  });

  testWidgets('renders gracefully when employee has empty job title', (
    tester,
  ) async {
    when(
      () => getEmployee(12),
    ).thenAnswer((_) async => const Right(employeeWithoutJobTitle));
    when(() => listRoles(any())).thenAnswer((_) async => const Right(roles));

    await tester.pumpWidget(
      wrap(
        const EmployeeRolesScreen(employeeId: 12),
        capabilities: const Capabilities(slugs: ['roles.update']),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Alan Turing'), findsOneWidget);
    expect(find.text(PeopleStrings.currentRole), findsOneWidget);
    expect(find.text('Admin'), findsNWidgets(2));
  });

  testWidgets('assigns role when tapping Assign button', (tester) async {
    when(() => getEmployee(11)).thenAnswer((_) async => const Right(employee));
    when(() => listRoles(any())).thenAnswer((_) async => const Right(roles));
    when(() => assignRole(any())).thenAnswer(
      (_) async => const Right(
        EmployeeSummary(
          id: 11,
          userId: 22,
          fullName: 'Ada Lovelace',
          jobTitle: 'Developer',
          roleId: 1,
        ),
      ),
    );

    await tester.pumpWidget(
      wrap(
        const EmployeeRolesScreen(employeeId: 11),
        capabilities: const Capabilities(slugs: ['roles.update']),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(PeopleStrings.assign));
    await tester.pumpAndSettle();

    verify(() => assignRole(any())).called(1);
    expect(find.text(PeopleStrings.roleAssigned), findsOneWidget);
  });
}
