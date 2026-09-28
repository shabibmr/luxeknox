import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/features/attendance/domain/entities/attendance_occupancy.dart';
import 'package:luxeknox/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:luxeknox/features/attendance/domain/usecases/attendance_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAttendanceRepository extends Mock implements AttendanceRepository {}

void main() {
  late MockAttendanceRepository repository;
  late GetAttendanceOccupancyUseCase useCase;

  setUp(() {
    repository = MockAttendanceRepository();
    useCase = GetAttendanceOccupancyUseCase(repository);
  });

  test('delegates to repository.getOccupancy and returns its result', () async {
    final occupancy = AttendanceOccupancy(
      checkedInNow: 5,
      asOf: DateTime(2026, 1, 1, 9),
      byGate: const [GateOccupancy(gateIdentifier: 'main', count: 5)],
    );
    when(() => repository.getOccupancy()).thenAnswer((_) async => Right(occupancy));

    final result = await useCase(const NoParams());

    expect(result, Right(occupancy));
    verify(() => repository.getOccupancy()).called(1);
  });
}
