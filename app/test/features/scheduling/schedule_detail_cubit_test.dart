import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/idempotency/idempotency_key.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:luxeknox/features/scheduling/domain/entities/schedule_session.dart';
import 'package:luxeknox/features/scheduling/domain/repositories/scheduling_repository.dart';
import 'package:luxeknox/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:luxeknox/features/scheduling/presentation/cubit/schedule_detail_cubit.dart';
import 'package:luxeknox/features/scheduling/presentation/scheduling_strings.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGet extends Mock implements GetScheduleUseCase {}

class _MockBook extends Mock implements BookScheduleUseCase {}

class _MockUnbook extends Mock implements UnbookScheduleUseCase {}

class _MockCancel extends Mock implements CancelScheduleUseCase {}

class _MockStart extends Mock implements StartScheduleUseCase {}

class _MockComplete extends Mock implements CompleteScheduleUseCase {}

class _MockMarkAttendance extends Mock
    implements MarkSessionAttendanceUseCase {}

class _MockUpdate extends Mock implements UpdateScheduleUseCase {}

void main() {
  late _MockGet getSchedule;
  late _MockBook book;
  late _MockUnbook unbook;
  late _MockCancel cancel;
  late _MockStart start;
  late _MockComplete complete;
  late _MockMarkAttendance markAttendance;
  late _MockUpdate updateSchedule;

  final session = ScheduleSession(
    id: '1',
    scheduleTypeId: '2',
    title: 'PT',
    startTime: DateTime.utc(2026, 9, 21, 10),
    endTime: DateTime.utc(2026, 9, 21, 11),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
  );

  final rescheduled = ScheduleSession(
    id: '1',
    scheduleTypeId: '2',
    title: 'PT',
    startTime: DateTime.utc(2026, 9, 22, 10),
    endTime: DateTime.utc(2026, 9, 22, 11),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 2,
  );

  setUp(() {
    getSchedule = _MockGet();
    book = _MockBook();
    unbook = _MockUnbook();
    cancel = _MockCancel();
    start = _MockStart();
    complete = _MockComplete();
    markAttendance = _MockMarkAttendance();
    updateSchedule = _MockUpdate();
    registerFallbackValue(
      const BookScheduleParams(
        scheduleId: '1',
        memberId: '9',
        idempotencyKey: 'k',
      ),
    );
    registerFallbackValue(
      const MarkSessionAttendanceParams(
        scheduleId: '1',
        participantId: '2',
        attended: true,
      ),
    );
    registerFallbackValue(
      const UpdateScheduleParams(
        id: '1',
        input: CreateScheduleInput(),
      ),
    );
    registerFallbackValue(
      const UnbookScheduleParams(scheduleId: '1', memberId: '9'),
    );
    registerFallbackValue(
      const CancelScheduleParams(scheduleId: '1'),
    );
    when(() => getSchedule(any())).thenAnswer((_) async => Right(session));
  });

  ScheduleDetailCubit buildCubit() => ScheduleDetailCubit(
    getSchedule,
    book,
    unbook,
    cancel,
    start,
    complete,
    markAttendance,
    updateSchedule,
  );

  test('newIdempotencyKey is unique-ish', () {
    final a = newIdempotencyKey();
    final b = newIdempotencyKey();
    expect(a, isNot(equals(b)));
    expect(a, isNotEmpty);
  });

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'blocks double-submit while book is in flight',
    build: () {
      when(() => book(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return Right(
          ScheduleParticipantEntry(
            id: 'p1',
            scheduleId: '1',
            memberId: '9',
            bookingStatus: BookingStatus.booked,
          ),
        );
      });
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      final first = cubit.book(memberId: '9');
      await cubit.book(memberId: '9');
      await first;
    },
    verify: (cubit) {
      verify(() => book(any())).called(1);
      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.session?.id, '1');
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'reuses idempotency key across retries of the same intent',
    build: () {
      var calls = 0;
      when(() => book(any())).thenAnswer((invocation) async {
        calls += 1;
        if (calls == 1) return const Left(NetworkFailure());
        return Right(
          ScheduleParticipantEntry(
            id: 'p1',
            scheduleId: '1',
            memberId: '9',
            bookingStatus: BookingStatus.booked,
          ),
        );
      });
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.book(memberId: '9');
      await cubit.book(memberId: '9');
    },
    verify: (_) {
      final captured = verify(() => book(captureAny())).captured;
      expect(captured.length, 2);
      final k1 = (captured[0] as BookScheduleParams).idempotencyKey;
      final k2 = (captured[1] as BookScheduleParams).idempotencyKey;
      expect(k1, equals(k2));
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'reschedule success updates session times',
    build: () {
      when(() => updateSchedule(any()))
          .thenAnswer((_) async => Right(rescheduled));
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.reschedule(
        start: rescheduled.startTime,
        end: rescheduled.endTime,
      );
    },
    verify: (cubit) {
      expect(cubit.state.session?.startTime, rescheduled.startTime);
      expect(cubit.state.message, SchedulingStrings.rescheduleSuccess);
      expect(cubit.state.isConflict, isFalse);
      final params =
          verify(() => updateSchedule(captureAny())).captured.single
              as UpdateScheduleParams;
      expect(params.input.rowVersion, 1);
      expect(params.input.startTime, rescheduled.startTime);
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'reschedule ConflictFailure reloads and sets isConflict',
    build: () {
      when(() => updateSchedule(any()))
          .thenAnswer((_) async => const Left(ConflictFailure()));
      when(() => getSchedule(any())).thenAnswer((_) async => Right(session));
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.reschedule(
        start: rescheduled.startTime,
        end: rescheduled.endTime,
      );
    },
    verify: (cubit) {
      expect(cubit.state.isConflict, isTrue);
      expect(cubit.state.message, SchedulingStrings.rowVersionConflict);
      verify(() => getSchedule(any())).called(greaterThanOrEqualTo(2));
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'moveBooking books new then cancels old',
    build: () {
      when(() => book(any())).thenAnswer(
        (_) async => Right(
          ScheduleParticipantEntry(
            id: 'p2',
            scheduleId: '99',
            memberId: '9',
            bookingStatus: BookingStatus.booked,
          ),
        ),
      );
      when(() => unbook(any())).thenAnswer((_) async => const Right(unit));
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.moveBooking(targetScheduleId: '99', memberId: '9');
    },
    verify: (cubit) {
      expect(cubit.state.message, SchedulingStrings.moveBookingSuccess);
      expect(cubit.state.movedToScheduleId, '99');
      final bookParams =
          verify(() => book(captureAny())).captured.single as BookScheduleParams;
      expect(bookParams.scheduleId, '99');
      final unbookParams = verify(() => unbook(captureAny())).captured.single
          as UnbookScheduleParams;
      expect(unbookParams.scheduleId, '1');
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'moveBooking ConflictFailure on book blocks with cap message and skips unbook',
    build: () {
      when(() => book(any()))
          .thenAnswer((_) async => const Left(ConflictFailure()));
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.moveBooking(targetScheduleId: '99', memberId: '9');
    },
    verify: (cubit) {
      verify(() => book(any())).called(1);
      verifyNever(() => unbook(any()));
      expect(cubit.state.message, SchedulingStrings.moveBookingCapBlocked);
      expect(cubit.state.failure, isA<ConflictFailure>());
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'moveBooking cancel failure after book warns about rollback',
    build: () {
      when(() => book(any())).thenAnswer(
        (_) async => Right(
          ScheduleParticipantEntry(
            id: 'p2',
            scheduleId: '99',
            memberId: '9',
            bookingStatus: BookingStatus.booked,
          ),
        ),
      );
      when(() => unbook(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.moveBooking(targetScheduleId: '99', memberId: '9');
    },
    verify: (cubit) {
      expect(cubit.state.message, SchedulingStrings.moveBookingCancelFailed);
      expect(cubit.state.movedToScheduleId, '99');
    },
  );

  blocTest<ScheduleDetailCubit, ScheduleDetailState>(
    'cancel with cancelSeries: true passes cancelSeries flag to usecase',
    build: () {
      when(() => cancel(any())).thenAnswer((_) async => Right(session));
      return buildCubit();
    },
    seed: () => ScheduleDetailState(
      status: LoadStatus.success,
      session: session,
    ),
    act: (cubit) async {
      await cubit.load('1');
      await cubit.cancel(reason: 'Illness', cancelSeries: true);
    },
    verify: (_) {
      final captured =
          verify(() => cancel(captureAny())).captured.single as CancelScheduleParams;
      expect(captured.cancelSeries, isTrue);
      expect(captured.reason, 'Illness');
    },
  );

  test('ScheduleSession.isRecurring getter works correctly', () {
    final nonRecurring = ScheduleSession(
      id: '1',
      scheduleTypeId: '2',
      title: 'Class',
      startTime: DateTime.utc(2026, 9, 21, 10),
      endTime: DateTime.utc(2026, 9, 21, 11),
      status: ScheduleSessionStatus.scheduled,
      rowVersion: 1,
    );
    expect(nonRecurring.isRecurring, isFalse);

    final recurring = ScheduleSession(
      id: '1',
      seriesId: 'series-99',
      scheduleTypeId: '2',
      title: 'Class',
      startTime: DateTime.utc(2026, 9, 21, 10),
      endTime: DateTime.utc(2026, 9, 21, 11),
      status: ScheduleSessionStatus.scheduled,
      rowVersion: 1,
    );
    expect(recurring.isRecurring, isTrue);
  });

  test('double-submit message constant exists', () {
    expect(SchedulingStrings.doubleSubmitBlocked, isNotEmpty);
  });
}
