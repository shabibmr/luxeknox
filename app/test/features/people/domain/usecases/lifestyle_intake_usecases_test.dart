import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/domain/entities/lifestyle_intake.dart';
import 'package:luxeknox/features/people/domain/repositories/lifestyle_intake_repository.dart';
import 'package:luxeknox/features/people/domain/usecases/get_lifestyle_intake_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/save_lifestyle_intake_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockLifestyleIntakeRepository extends Mock
    implements LifestyleIntakeRepository {}

void main() {
  late MockLifestyleIntakeRepository repository;

  final intake = LifestyleIntake(
    id: 1,
    memberId: 10,
    stressLevel: 4,
    priorities: const [],
    createdAt: DateTime.utc(2026, 3, 1),
  );
  const input = LifestyleIntakeInput(
    memberId: 10,
    stressLevel: 4,
    priorities: [],
  );

  setUp(() => repository = MockLifestyleIntakeRepository());

  test('GetLifestyleIntakeUseCase fetches by member id', () async {
    when(() => repository.get(10)).thenAnswer((_) async => Right(intake));

    final result = await GetLifestyleIntakeUseCase(repository)(10);

    expect(result, Right<Failure, LifestyleIntake>(intake));
  });

  test('SaveLifestyleIntakeUseCase forwards the input', () async {
    when(() => repository.save(input)).thenAnswer((_) async => Right(intake));

    final result = await SaveLifestyleIntakeUseCase(repository)(input);

    expect(result, Right<Failure, LifestyleIntake>(intake));
    verify(() => repository.save(input)).called(1);
  });

  test('propagates a failure from the repository', () async {
    when(
      () => repository.get(10),
    ).thenAnswer((_) async => const Left(NotFoundFailure()));

    final result = await GetLifestyleIntakeUseCase(repository)(10);

    expect(result.isLeft(), isTrue);
  });
}
