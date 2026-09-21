import 'package:app/core/pagination/cursor_page.dart';
import 'package:app/features/people/domain/entities/employee_summary.dart';
import 'package:app/features/people/domain/entities/member_filter.dart';
import 'package:app/features/people/domain/entities/person.dart';
import 'package:app/features/people/domain/entities/profile_summary.dart';
import 'package:app/features/people/domain/entities/trainer_summary.dart';
import 'package:app/features/people/domain/repositories/people_repository.dart';
import 'package:app/features/people/domain/usecases/assign_trainer_usecase.dart';
import 'package:app/features/people/domain/usecases/get_member_usecase.dart';
import 'package:app/features/people/domain/usecases/list_employees_usecase.dart';
import 'package:app/features/people/domain/usecases/list_members_usecase.dart';
import 'package:app/features/people/domain/usecases/list_trainers_usecase.dart';
import 'package:app/features/people/domain/usecases/update_member_usecase.dart';
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
  });
}
