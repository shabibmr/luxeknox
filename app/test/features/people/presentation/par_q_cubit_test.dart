import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_inputs.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:luxeknox/features/people/domain/usecases/submit_par_q_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/par_q_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSubmitParQUseCase extends Mock implements SubmitParQUseCase {}

void main() {
  late MockSubmitParQUseCase mockSubmit;
  late ParQCubit cubit;

  final tSubmission = ParQSubmission(
    memberId: 42,
    answers: List.filled(7, ParQAnswer.no),
    declarationAccepted: true,
  );

  final tScreening = ParQScreening(
    id: 1,
    memberId: 42,
    version: '2024.1',
    answers: List.filled(7, ParQAnswer.no),
    hasPositiveAnswer: false,
    referralRequired: false,
    declarationAccepted: true,
    clearanceStatus: ParQClearanceStatus.passed,
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tSubmission);
  });

  setUp(() {
    mockSubmit = MockSubmitParQUseCase();
    cubit = ParQCubit(mockSubmit);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has LoadStatus.initial', () {
    expect(cubit.state, const ParQState());
    expect(cubit.state.status, LoadStatus.initial);
    expect(cubit.state.isSubmitting, false);
    expect(cubit.state.screening, isNull);
  });

  blocTest<ParQCubit, ParQState>(
    'emits [loading, success] when submission succeeds',
    build: () {
      when(() => mockSubmit(any())).thenAnswer((_) async => Right(tScreening));
      return cubit;
    },
    act: (c) => c.submit(tSubmission),
    expect: () => [
      const ParQState(status: LoadStatus.loading),
      ParQState(status: LoadStatus.success, screening: tScreening),
    ],
    verify: (_) {
      verify(() => mockSubmit(tSubmission)).called(1);
    },
  );

  blocTest<ParQCubit, ParQState>(
    'emits [loading, failure] when submission fails',
    build: () {
      when(() => mockSubmit(any())).thenAnswer(
        (_) async => const Left(ValidationFailure(['Invalid signature'])),
      );
      return cubit;
    },
    act: (c) => c.submit(tSubmission),
    expect: () => [
      const ParQState(status: LoadStatus.loading),
      const ParQState(
        status: LoadStatus.failure,
        failure: ValidationFailure(['Invalid signature']),
      ),
    ],
  );

  test('reset restores initial state', () {
    cubit.emit(ParQState(status: LoadStatus.success, screening: tScreening));
    cubit.reset();
    expect(cubit.state, const ParQState());
  });
}
