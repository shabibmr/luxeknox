import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_enums.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_record.dart';
import 'package:luxeknox/features/attendance/domain/entities/check_in_input.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:luxeknox/features/attendance/presentation/bloc/check_in_bloc.dart';
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

  const submit = CheckInSubmitted(
    userId: '5',
    method: AttendanceCheckInMethod.manualOverride,
  );

  setUp(() {
    checkIn = _MockCheckIn();
    registerFallbackValue(const CheckInInput(idempotencyKey: 'k'));
  });

  blocTest<CheckInBloc, CheckInState>(
    'reuses idempotency key across retries of the same intent',
    build: () {
      when(
        () => checkIn(any()),
      ).thenAnswer((_) async => const Left(NetworkFailure()));
      return CheckInBloc(checkIn);
    },
    act: (bloc) async {
      bloc.add(submit);
      await bloc.stream.firstWhere((s) => s.status == LoadStatus.failure);
      // Let the droppable handler finish before the retry.
      await Future<void>.delayed(Duration.zero);
      bloc.add(submit);
      await bloc.stream.firstWhere((s) => s.status == LoadStatus.failure);
    },
    verify: (_) {
      final captured = verify(() => checkIn(captureAny())).captured;
      expect(captured, hasLength(2));
      final first = captured[0] as CheckInInput;
      final second = captured[1] as CheckInInput;
      expect(first.idempotencyKey, second.idempotencyKey);
    },
  );

  blocTest<CheckInBloc, CheckInState>(
    'drops a second submit while check-in is in flight',
    build: () {
      when(() => checkIn(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return Right(record);
      });
      return CheckInBloc(checkIn);
    },
    act: (bloc) async {
      bloc.add(submit);
      bloc.add(submit);
      await bloc.stream.firstWhere((s) => s.status == LoadStatus.success);
    },
    expect: () => [
      isA<CheckInState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<CheckInState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.record?.id, 'id', '10')
          .having((s) => s.message, 'message', isNull),
    ],
    verify: (_) {
      verify(() => checkIn(any())).called(1);
    },
  );

  blocTest<CheckInBloc, CheckInState>(
    'emits success only after server confirmation',
    build: () {
      when(() => checkIn(any())).thenAnswer((_) async => Right(record));
      return CheckInBloc(checkIn);
    },
    act: (bloc) => bloc.add(submit),
    expect: () => [
      isA<CheckInState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<CheckInState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.record?.id, 'id', '10'),
    ],
  );

  blocTest<CheckInBloc, CheckInState>(
    'reset returns to initial',
    build: () => CheckInBloc(checkIn),
    seed: () => const CheckInState(
      status: LoadStatus.failure,
      message: 'nope',
    ),
    act: (bloc) => bloc.reset(),
    expect: () => const [CheckInState()],
  );
}
