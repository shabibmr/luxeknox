import 'package:app/core/error/failures.dart';
import 'package:app/features/attendance/domain/entities/attendance_enums.dart';
import 'package:app/features/attendance/domain/entities/attendance_record.dart';
import 'package:app/features/attendance/domain/entities/check_in_input.dart';
import 'package:app/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:app/features/attendance/presentation/attendance_strings.dart';
import 'package:app/features/attendance/presentation/cubit/attendance_pass_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockCheckIn extends Mock implements CheckInUseCase {}

void main() {
  late _MockCheckIn checkIn;

  final record = AttendanceRecord(
    id: '10',
    userId: '5',
    checkInTime: DateTime.utc(2026, 9, 21, 8),
    method: AttendanceCheckInMethod.manualOverride,
  );

  setUp(() {
    checkIn = _MockCheckIn();
    registerFallbackValue(
      const CheckInInput(idempotencyKey: 'k'),
    );
  });

  blocTest<CheckInCubit, CheckInCubitState>(
    'reuses idempotency key across retries of the same intent',
    build: () {
      when(() => checkIn(any())).thenAnswer((_) async => const Left(NetworkFailure()));
      return CheckInCubit(checkIn);
    },
    act: (cubit) async {
      await cubit.submit(
        userId: '5',
        method: AttendanceCheckInMethod.manualOverride,
      );
      await cubit.submit(
        userId: '5',
        method: AttendanceCheckInMethod.manualOverride,
      );
    },
    verify: (_) {
      final captured = verify(() => checkIn(captureAny())).captured;
      expect(captured, hasLength(2));
      final first = captured[0] as CheckInInput;
      final second = captured[1] as CheckInInput;
      expect(first.idempotencyKey, second.idempotencyKey);
    },
  );

  blocTest<CheckInCubit, CheckInCubitState>(
    'blocks double-submit while check-in is in flight',
    build: () {
      when(() => checkIn(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return Right(record);
      });
      return CheckInCubit(checkIn);
    },
    act: (cubit) async {
      final first = cubit.submit(
        userId: '5',
        method: AttendanceCheckInMethod.manualOverride,
      );
      await cubit.submit(
        userId: '5',
        method: AttendanceCheckInMethod.manualOverride,
      );
      await first;
    },
    expect: () => [
      isA<CheckInIdle>().having((s) => s.actionInFlight, 'busy', true),
      isA<CheckInIdle>().having(
        (s) => s.message,
        'message',
        AttendanceStrings.doubleSubmitBlocked,
      ),
      isA<CheckInSuccess>(),
    ],
  );

  blocTest<CheckInCubit, CheckInCubitState>(
    'emits success only after server confirmation',
    build: () {
      when(() => checkIn(any())).thenAnswer((_) async => Right(record));
      return CheckInCubit(checkIn);
    },
    act: (cubit) => cubit.submit(
      userId: '5',
      method: AttendanceCheckInMethod.manualOverride,
    ),
    expect: () => [
      isA<CheckInIdle>().having((s) => s.actionInFlight, 'busy', true),
      isA<CheckInSuccess>().having((s) => s.record.id, 'id', '10'),
    ],
  );
}
