import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_summary.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/membership/domain/entities/membership.dart';
import 'package:luxeknox/features/membership/domain/usecases/get_memberships_usecase.dart';
import 'package:luxeknox/features/people/domain/entities/lifestyle_intake.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:luxeknox/features/people/domain/entities/person.dart';
import 'package:luxeknox/features/people/domain/usecases/get_lifestyle_intake_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_member_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_par_q_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_trainer_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_member_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/member_dossier_cubit.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_subscription.dart';
import 'package:luxeknox/features/pt/domain/usecases/pt_usecases.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMemberUseCase extends Mock implements GetMemberUseCase {}

class MockUpdateMemberUseCase extends Mock implements UpdateMemberUseCase {}

class MockGetMembershipsUseCase extends Mock implements GetMembershipsUseCase {}

class MockGetAttendanceSummaryUseCase extends Mock
    implements GetAttendanceSummaryUseCase {}

class MockGetTrainerUseCase extends Mock implements GetTrainerUseCase {}

class MockListSchedulesUseCase extends Mock implements ListSchedulesUseCase {}

class MockGetMemberPtSummaryUseCase extends Mock
    implements GetMemberPtSummaryUseCase {}

class MockRenewPtUseCase extends Mock implements RenewPtUseCase {}

class MockGetParQUseCase extends Mock implements GetParQUseCase {}

class MockGetLifestyleIntakeUseCase extends Mock
    implements GetLifestyleIntakeUseCase {}

void main() {
  late MockGetMemberUseCase getMember;
  late MockGetMembershipsUseCase getMemberships;
  late MockGetAttendanceSummaryUseCase getAttendanceSummary;
  late MockListSchedulesUseCase listSchedules;
  late MockGetMemberPtSummaryUseCase getPtSummary;
  late MockGetParQUseCase getParQ;
  late MockGetLifestyleIntakeUseCase getLifestyle;

  const person = Person(
    id: 42,
    userId: 101,
    membershipNumber: 'MEM-042',
    firstName: 'John',
    lastName: 'Doe',
  );

  final screening = ParQScreening(
    id: 5,
    memberId: 42,
    version: 'PAR-Q+ 2024',
    answers: List.filled(7, ParQAnswer.no),
    hasPositiveAnswer: false,
    referralRequired: false,
    declarationAccepted: true,
    clearanceStatus: ParQClearanceStatus.passed,
    createdAt: DateTime.utc(2026, 3, 1),
  );

  final intake = LifestyleIntake(
    id: 3,
    memberId: 42,
    stressLevel: 7,
    sleepHoursTypical: 6.5,
    priorities: const [
      LifestylePriority(
        domain: LifestylePriorityDomain.sleep,
        currentStatus: 'Wakes at 3am',
        firstAction: 'No screens after 10pm',
      ),
    ],
    createdAt: DateTime.utc(2026, 3, 1),
  );

  MemberDossierCubit build() => MemberDossierCubit(
    getMember,
    MockUpdateMemberUseCase(),
    getMemberships,
    getAttendanceSummary,
    MockGetTrainerUseCase(),
    listSchedules,
    getPtSummary,
    MockRenewPtUseCase(),
    getParQ,
    getLifestyle,
  );

  setUpAll(() {
    registerFallbackValue(const GetMembershipsParams());
    registerFallbackValue(const GetAttendanceSummaryParams());
    registerFallbackValue(const ListSchedulesParams());
  });

  setUp(() {
    getMember = MockGetMemberUseCase();
    getMemberships = MockGetMembershipsUseCase();
    getAttendanceSummary = MockGetAttendanceSummaryUseCase();
    listSchedules = MockListSchedulesUseCase();
    getPtSummary = MockGetMemberPtSummaryUseCase();
    getParQ = MockGetParQUseCase();
    getLifestyle = MockGetLifestyleIntakeUseCase();

    when(() => getMember(42)).thenAnswer((_) async => const Right(person));
    when(() => getMemberships(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<Membership>(items: [], nextCursor: null, hasMore: false),
      ),
    );
    when(() => getAttendanceSummary(any())).thenAnswer(
      (_) async => const Right(AttendanceSummaryInfo(visitsThisMonth: 1)),
    );
    when(() => listSchedules(any())).thenAnswer(
      (_) async => const Right(
        CursorPage<ScheduleSession>(
          items: [],
          nextCursor: null,
          hasMore: false,
        ),
      ),
    );
    when(() => getPtSummary(42)).thenAnswer(
      (_) async => const Right(MemberPtSummary()),
    );
  });

  test('loads the latest PAR-Q+ screening and lifestyle intake', () async {
    when(() => getParQ(42)).thenAnswer((_) async => Right(screening));
    when(() => getLifestyle(42)).thenAnswer((_) async => Right(intake));
    final cubit = build();

    await cubit.load(42);

    expect(cubit.state.parQ, screening);
    expect(cubit.state.lifestyle, intake);
    expect(cubit.state.healthUnavailable, isFalse);
    expect(cubit.state.lifestyleUnavailable, isFalse);
    await cubit.close();
  });

  test('treats NotFound as "nothing on file", not as unavailable', () async {
    when(() => getParQ(42)).thenAnswer((_) async => const Left(NotFoundFailure()));
    when(() => getLifestyle(42))
        .thenAnswer((_) async => const Left(NotFoundFailure()));
    final cubit = build();

    await cubit.load(42);

    expect(cubit.state.parQ, isNull);
    expect(cubit.state.lifestyle, isNull);
    expect(cubit.state.healthUnavailable, isFalse);
    expect(cubit.state.lifestyleUnavailable, isFalse);
    await cubit.close();
  });

  test('flags each section unavailable independently on other failures', () async {
    when(() => getParQ(42)).thenAnswer((_) async => const Left(PermissionFailure()));
    when(() => getLifestyle(42)).thenAnswer((_) async => Right(intake));
    final cubit = build();

    await cubit.load(42);

    expect(cubit.state.parQ, isNull);
    expect(cubit.state.healthUnavailable, isTrue);
    expect(cubit.state.lifestyle, intake);
    expect(cubit.state.lifestyleUnavailable, isFalse);
    // A health-section failure must not turn the whole dossier into an error.
    expect(cubit.state.person, person);
    expect(cubit.state.failure, isNull);
    await cubit.close();
  });
}
