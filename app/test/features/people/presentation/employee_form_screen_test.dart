import 'package:luxeknox/core/di/injector.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/people/domain/entities/employee_status.dart';
import 'package:luxeknox/features/people/domain/entities/employee_summary.dart';
import 'package:luxeknox/features/people/domain/entities/employee_update_input.dart';
import 'package:luxeknox/features/people/domain/entities/new_employee_input.dart';
import 'package:luxeknox/features/people/domain/entities/role.dart';
import 'package:luxeknox/features/people/domain/usecases/create_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_employees_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_roles_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/set_employee_status_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_employee_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/employee_form_cubit.dart';
import 'package:luxeknox/features/people/presentation/cubit/employees_directory_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:luxeknox/features/people/presentation/screens/employee_form_screen.dart';
import 'package:luxeknox/features/people/presentation/screens/employees_directory_screen.dart';
import 'package:luxeknox/session/domain/entities/capabilities.dart';
import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:luxeknox/session/presentation/session_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateEmployeeUseCase extends Mock implements CreateEmployeeUseCase {}

class MockUpdateEmployeeUseCase extends Mock implements UpdateEmployeeUseCase {}

class MockGetEmployeeUseCase extends Mock implements GetEmployeeUseCase {}

class MockListRolesUseCase extends Mock implements ListRolesUseCase {}

class MockListEmployeesUseCase extends Mock implements ListEmployeesUseCase {}

class MockSetEmployeeStatusUseCase extends Mock
    implements SetEmployeeStatusUseCase {}

class MockSessionCubit extends MockCubit<SessionState>
    implements SessionCubit {}

void main() {
  late MockCreateEmployeeUseCase createEmployee;
  late MockUpdateEmployeeUseCase updateEmployee;
  late MockGetEmployeeUseCase getEmployee;
  late MockListRolesUseCase listRoles;
  late MockListEmployeesUseCase listEmployees;
  late MockSetEmployeeStatusUseCase setEmployeeStatus;

  const adminPrincipal = Principal(
    userId: '3',
    userType: UserType.admin,
    displayName: 'Admin One',
    profileId: 'p3',
  );

  const roles = [
    Role(id: 3, name: 'Staff', isSystemRole: false),
  ];

  const loaded = EmployeeSummary(
    id: 11,
    userId: 22,
    fullName: 'Ada Lovelace',
    jobTitle: 'Front desk',
    department: 'Ops',
    roleId: 3,
    email: 'ada@example.com',
    phoneNumber: '555-0100',
    status: 'active',
  );

  setUpAll(() {
    registerFallbackValue(const NewEmployeeInput(email: 'a@b.c', roleId: 1));
    registerFallbackValue(
      const UpdateEmployeeParams(id: 1, input: EmployeeUpdateInput()),
    );
    registerFallbackValue(
      const SetEmployeeStatusParams(id: 1, status: EmployeeStatus.active),
    );
    registerFallbackValue(const NoParams());
    registerFallbackValue(const ListEmployeesParams());
  });

  setUp(() {
    createEmployee = MockCreateEmployeeUseCase();
    updateEmployee = MockUpdateEmployeeUseCase();
    getEmployee = MockGetEmployeeUseCase();
    listRoles = MockListRolesUseCase();
    listEmployees = MockListEmployeesUseCase();
    setEmployeeStatus = MockSetEmployeeStatusUseCase();

    when(() => listRoles(any())).thenAnswer((_) async => const Right(roles));
    when(() => listEmployees(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<EmployeeSummary>(
          items: [],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(() => getEmployee(11)).thenAnswer((_) async => const Right(loaded));

    getIt.registerFactory<EmployeeFormCubit>(
      () => EmployeeFormCubit(
        createEmployee,
        updateEmployee,
        getEmployee,
        listRoles,
        setEmployeeStatus,
      ),
    );
    getIt.registerFactory<EmployeesDirectoryCubit>(
      () => EmployeesDirectoryCubit(listEmployees),
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
      home: BlocProvider<SessionCubit>.value(
        value: sessionCubit,
        child: child,
      ),
    );
  }

  testWidgets('renders create form fields including hire date and hides role', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const EmployeeFormScreen.create(),
        capabilities: const Capabilities(
          slugs: ['employees.create', 'employees.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.addEmployeeTitle), findsOneWidget);
    expect(find.text(PeopleStrings.firstName), findsOneWidget);
    expect(find.text(PeopleStrings.email), findsOneWidget);
    expect(find.text(PeopleStrings.password), findsOneWidget);
    expect(find.text(PeopleStrings.jobTitle), findsOneWidget);
    expect(find.text(PeopleStrings.department), findsOneWidget);
    expect(find.text(PeopleStrings.hireDate), findsOneWidget);
    expect(find.text(PeopleStrings.role), findsNothing);
    expect(find.text(PeopleStrings.createEmployee), findsOneWidget);
  });

  testWidgets('shows validation snackbar when required fields missing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const EmployeeFormScreen.create(),
        capabilities: const Capabilities(
          slugs: ['employees.create', 'employees.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(PeopleStrings.createEmployee));
    await tester.pump();

    expect(find.text(PeopleStrings.firstNameRequired), findsOneWidget);
    verifyNever(() => createEmployee(any()));
  });

  testWidgets('edit mode shows read-only identity, status, roles link', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const EmployeeFormScreen.edit(employeeId: 11),
        capabilities: const Capabilities(
          slugs: ['employees.update', 'employees.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.editEmployeeTitle), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.text('555-0100'), findsOneWidget);
    expect(find.text(PeopleStrings.employmentStatus), findsOneWidget);
    expect(find.text(PeopleStrings.manageRoles), findsOneWidget);
    expect(find.text(PeopleStrings.save), findsOneWidget);
    expect(find.text(PeopleStrings.firstName), findsNothing);
    expect(find.text(PeopleStrings.password), findsNothing);
    expect(find.text(PeopleStrings.role), findsNothing);
  });

  testWidgets('edit mode confirms before suspend', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    when(() => setEmployeeStatus(any())).thenAnswer(
      (_) async => Right(
        EmployeeSummary(
          id: loaded.id,
          userId: loaded.userId,
          fullName: loaded.fullName,
          jobTitle: loaded.jobTitle,
          department: loaded.department,
          roleId: loaded.roleId,
          email: loaded.email,
          phoneNumber: loaded.phoneNumber,
          status: 'suspended',
        ),
      ),
    );

    await tester.pumpWidget(
      wrap(
        const EmployeeFormScreen.edit(employeeId: 11),
        capabilities: const Capabilities(
          slugs: ['employees.update', 'employees.read'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<EmployeeStatus>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(PeopleStrings.statusSuspended).last);
    await tester.pumpAndSettle();

    expect(find.text(PeopleStrings.confirmStatusChangeTitle), findsOneWidget);
    await tester.tap(find.text(PeopleStrings.confirmStatusChange));
    await tester.pumpAndSettle();

    verify(() => setEmployeeStatus(any())).called(1);
    expect(find.text(PeopleStrings.statusUpdated), findsOneWidget);
  });

  testWidgets('directory AppBar + gated on employees.create', (tester) async {
    await tester.pumpWidget(
      wrap(
        const EmployeesDirectoryScreen(),
        capabilities: const Capabilities(slugs: ['employees.read']),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byTooltip(PeopleStrings.addEmployeeTooltip), findsNothing);

    await tester.pumpWidget(
      wrap(
        const EmployeesDirectoryScreen(),
        capabilities: const Capabilities(
          slugs: ['employees.read', 'employees.create'],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byTooltip(PeopleStrings.addEmployeeTooltip), findsOneWidget);
  });
}
