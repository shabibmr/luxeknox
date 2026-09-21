import 'package:app/core/error/failures.dart';
import 'package:app/core/idempotency/idempotency_key.dart';
import 'package:app/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:app/features/scheduling/domain/entities/schedule_enums.dart';
import 'package:app/features/scheduling/domain/entities/schedule_session.dart';
import 'package:app/features/scheduling/domain/usecases/schedule_usecases.dart';
import 'package:app/features/scheduling/presentation/cubit/schedule_detail_cubit.dart';
import 'package:app/features/scheduling/presentation/scheduling_strings.dart';
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

void main() {
  late _MockGet getSchedule;
  late _MockBook book;
  late _MockUnbook unbook;
  late _MockCancel cancel;
  late _MockStart start;
  late _MockComplete complete;
  late _MockMarkAttendance markAttendance;

  final session = ScheduleSession(
    id: '1',
    scheduleTypeId: '2',
    title: 'PT',
    startTime: DateTime.utc(2026, 9, 21, 10),
    endTime: DateTime.utc(2026, 9, 21, 11),
    status: ScheduleSessionStatus.scheduled,
    rowVersion: 1,
  );

  setUp(() {
    getSchedule = _MockGet();
    book = _MockBook();
    unbook = _MockUnbook();
    cancel = _MockCancel();
    start = _MockStart();
    complete = _MockComplete();
    markAttendance = _MockMarkAttendance();
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
    seed: () => ScheduleDetailLoaded(session: session),
    act: (cubit) async {
      final first = cubit.book(memberId: '9');
      await cubit.book(memberId: '9');
      await first;
    },
    verify: (cubit) {
      verify(() => book(any())).called(1);
      final state = cubit.state;
      expect(state, isA<ScheduleDetailLoaded>());
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
    seed: () => ScheduleDetailLoaded(session: session),
    act: (cubit) async {
      // Prime schedule id via load path used by book().
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

  test('double-submit message constant exists', () {
    expect(SchedulingStrings.doubleSubmitBlocked, isNotEmpty);
  });
}
