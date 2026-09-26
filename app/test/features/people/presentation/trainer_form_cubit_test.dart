import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/domain/entities/new_trainer_input.dart';
import 'package:luxeknox/features/people/domain/entities/trainer_profile.dart';
import 'package:luxeknox/features/people/domain/usecases/create_trainer_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/trainer_form_cubit.dart';
import 'package:luxeknox/features/people/presentation/people_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTrainerUseCase extends Mock implements CreateTrainerUseCase {}

void main() {
  late MockCreateTrainerUseCase createTrainer;
  late TrainerFormCubit cubit;

  const created = TrainerProfile(
    id: 42,
    userId: 7,
    firstName: 'Ada',
    lastName: 'Lovelace',
  );

  setUpAll(() {
    registerFallbackValue(const NewTrainerInput(email: 'a@b.c'));
  });

  setUp(() {
    createTrainer = MockCreateTrainerUseCase();
    cubit = TrainerFormCubit(createTrainer);
  });

  tearDown(() => cubit.close());

  test('submit validates required fields before calling use case', () async {
    final ok = await cubit.submit();
    expect(ok, isFalse);
    expect(cubit.state.error, PeopleStrings.firstNameRequired);
    verifyNever(() => createTrainer(any()));
  });

  test('submit succeeds and stores created trainer', () async {
    when(() => createTrainer(any())).thenAnswer((_) async => const Right(created));

    cubit.updateInput(
      (i) => i.copyWith(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret1',
      ),
    );

    final ok = await cubit.submit();
    expect(ok, isTrue);
    expect(cubit.state.created, created);
    expect(cubit.state.submitting, isFalse);
    verify(() => createTrainer(any())).called(1);
  });

  test('double-submit while in flight is ignored', () async {
    when(() => createTrainer(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return const Right(created);
    });

    cubit.updateInput(
      (i) => i.copyWith(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret1',
      ),
    );

    final first = cubit.submit();
    final second = await cubit.submit();
    expect(second, isFalse);
    expect(await first, isTrue);
    verify(() => createTrainer(any())).called(1);
  });

  test('maps failure message on create error', () async {
    when(() => createTrainer(any())).thenAnswer(
      (_) async => const Left(ConflictFailure()),
    );

    cubit.updateInput(
      (i) => i.copyWith(
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        password: 'secret1',
      ),
    );

    final ok = await cubit.submit();
    expect(ok, isFalse);
    expect(cubit.state.created, isNull);
    expect(cubit.state.error, isNotNull);
  });

  test('specialization chips add and remove', () {
    cubit.addSpecialization('HIIT');
    cubit.addSpecialization('HIIT');
    cubit.addSpecialization(' Strength ');
    expect(cubit.state.input.specializations, ['HIIT', 'Strength']);
    cubit.removeSpecialization('HIIT');
    expect(cubit.state.input.specializations, ['Strength']);
  });
}
