import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/people/domain/entities/employee_status.dart';
import 'package:luxeknox/features/people/domain/entities/employee_summary.dart';
import 'package:luxeknox/features/people/domain/entities/employee_update_input.dart';
import 'package:luxeknox/features/people/domain/entities/member_filter.dart';
import 'package:luxeknox/features/people/domain/entities/new_employee_input.dart';
import 'package:luxeknox/features/people/domain/entities/new_trainer_input.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/people/domain/entities/profile_summary.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_summary.dart';
import 'package:luxeknox/features/people/domain/repositories/people_repository.dart';
import 'package:luxeknox/features/people/domain/usecases/assign_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/create_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/create_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_employees_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_members_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_trainers_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/set_employee_status_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_employee_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_member_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPeopleRepository extends Mock implements PeopleRepository {}

void main() {
  late MockPeopleRepository mockRepository;

  const tPerson = Person(
    id: 1,
    userId: 10,
    membershipNumber: 'M-001',
    firstName: 'Ada',
    lastName: 'Lovelace',
  );

  const tSummary = ProfileSummary(
    id: 1,
    membershipNumber: 'M-001',
    fullName: 'Ada Lovelace',
  );

  const tPage = CursorPage<ProfileSummary>(
    items: [tSummary],
    nextCursor: 'next',
    hasMore: true,
  );

  setUp(() {
    mockRepository = MockPeopleRepository();
  });

  group('People UseCases', () {
    test('ListMembersUseCase calls repository.listMembers', () async {
      const filter = MemberFilter(query: 'ada');
      when(
        () => mockRepository.listMembers(filter, 'c1'),
      ).thenAnswer((_) async => const Right(tPage));

      final useCase = ListMembersUseCase(mockRepository);
      final result = await useCase(
        const ListMembersParams(filter: filter, cursor: 'c1'),
      );

      expect(result, const Right(tPage));
      verify(() => mockRepository.listMembers(filter, 'c1')).called(1);
    });

    test('GetMemberUseCase calls repository.getMember', () async {
      when(
        () => mockRepository.getMember(1),
      ).thenAnswer((_) async => const Right(tPerson));

      final useCase = GetMemberUseCase(mockRepository);
      final result = await useCase(1);

      expect(result, const Right(tPerson));
      verify(() => mockRepository.getMember(1)).called(1);
    });

    test('UpdateMemberUseCase calls repository.updateMember', () async {
      when(
        () => mockRepository.updateMember(tPerson),
      ).thenAnswer((_) async => const Right(tPerson));

      final useCase = UpdateMemberUseCase(mockRepository);
      final result = await useCase(tPerson);

      expect(result, const Right(tPerson));
      verify(() => mockRepository.updateMember(tPerson)).called(1);
    });

    test('AssignTrainerUseCase calls repository.assignTrainer', () async {
      when(
        () => mockRepository.assignTrainer(
          memberId: 1,
          trainerId: 5,
          overrideCapacity: null,
          reason: null,
        ),
      ).thenAnswer((_) async => const Right(tPerson));

      final useCase = AssignTrainerUseCase(mockRepository);
      final result = await useCase(
        const AssignTrainerParams(memberId: 1, trainerId: 5),
      );

      expect(result, const Right(tPerson));
      verify(
        () => mockRepository.assignTrainer(
          memberId: 1,
          trainerId: 5,
          overrideCapacity: null,
          reason: null,
        ),
      ).called(1);
    });

    test('ListTrainersUseCase calls repository.listTrainers', () async {
      const page = CursorPage<TrainerSummary>(
        items: [
          TrainerSummary(id: 1, userId: 2, fullName: 'T One'),
        ],
        nextCursor: null,
        hasMore: false,
      );
      when(
        () => mockRepository.listTrainers(query: 't', cursor: null),
      ).thenAnswer((_) async => const Right(page));

      final useCase = ListTrainersUseCase(mockRepository);
      final result = await useCase(const ListTrainersParams(query: 't'));

      expect(result, const Right(page));
      verify(
        () => mockRepository.listTrainers(query: 't', cursor: null),
      ).called(1);
    });

    test('ListEmployeesUseCase calls repository.listEmployees', () async {
      const page = CursorPage<EmployeeSummary>(
        items: [
          EmployeeSummary(
            id: 1,
            userId: 2,
            fullName: 'E One',
            jobTitle: 'Front desk',
          ),
        ],
        nextCursor: null,
        hasMore: false,
      );
      when(
        () => mockRepository.listEmployees(query: null, cursor: null),
      ).thenAnswer((_) async => const Right(page));

      final useCase = ListEmployeesUseCase(mockRepository);
      final result = await useCase(const ListEmployeesParams());

      expect(result, const Right(page));
      verify(
        () => mockRepository.listEmployees(query: null, cursor: null),
      ).called(1);
    });

    test('CreateTrainerUseCase calls repository.createTrainer', () async {
      const input = NewTrainerInput(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@example.com',
      );
      const trainer = TrainerProfile(id: 1, userId: 2, firstName: 'Jane', lastName: 'Doe');
      when(
        () => mockRepository.createTrainer(input),
      ).thenAnswer((_) async => const Right(trainer));

      final useCase = CreateTrainerUseCase(mockRepository);
      final result = await useCase(input);

      expect(result, const Right(trainer));
      verify(() => mockRepository.createTrainer(input)).called(1);
    });

    test('CreateEmployeeUseCase calls repository.createEmployee', () async {
      const input = NewEmployeeInput(
        firstName: 'Ed',
        lastName: 'Ford',
        email: 'ed@example.com',
        jobTitle: 'Front Desk',
        roleId: 3,
      );
      const employee = EmployeeSummary(
        id: 5,
        userId: 6,
        fullName: 'Ed Ford',
        jobTitle: 'Front Desk',
        roleId: 3,
      );
      when(
        () => mockRepository.createEmployee(input),
      ).thenAnswer((_) async => const Right(employee));

      final useCase = CreateEmployeeUseCase(mockRepository);
      final result = await useCase(input);

      expect(result, const Right(employee));
      verify(() => mockRepository.createEmployee(input)).called(1);
    });

    test('UpdateEmployeeUseCase calls repository.updateEmployee', () async {
      const input = EmployeeUpdateInput(jobTitle: 'Manager');
      const employee = EmployeeSummary(
        id: 5,
        userId: 6,
        fullName: 'Ed Ford',
        jobTitle: 'Manager',
      );
      when(
        () => mockRepository.updateEmployee(5, input),
      ).thenAnswer((_) async => const Right(employee));

      final useCase = UpdateEmployeeUseCase(mockRepository);
      final result = await useCase(
        const UpdateEmployeeParams(id: 5, input: input),
      );

      expect(result, const Right(employee));
      verify(() => mockRepository.updateEmployee(5, input)).called(1);
    });

    test(
      'SetEmployeeStatusUseCase calls repository.setEmployeeStatus',
      () async {
        const employee = EmployeeSummary(
          id: 5,
          userId: 6,
          fullName: 'Ed Ford',
          jobTitle: 'Front Desk',
          status: 'onProbation',
        );
        when(
          () => mockRepository.setEmployeeStatus(
            5,
            EmployeeStatus.onProbation,
          ),
        ).thenAnswer((_) async => const Right(employee));

        final useCase = SetEmployeeStatusUseCase(mockRepository);
        final result = await useCase(
          const SetEmployeeStatusParams(
            id: 5,
            status: EmployeeStatus.onProbation,
          ),
        );

        expect(result, const Right(employee));
        verify(
          () => mockRepository.setEmployeeStatus(
            5,
            EmployeeStatus.onProbation,
          ),
        ).called(1);
      },
    );
  });
}
