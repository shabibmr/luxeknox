import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/people/domain/entities/health_info.dart';
import 'package:luxeknox/features/people/domain/usecases/get_health_info_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/update_health_info_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/health_info_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHealthInfoUseCase extends Mock implements GetHealthInfoUseCase {}

class MockUpdateHealthInfoUseCase extends Mock
    implements UpdateHealthInfoUseCase {}

void main() {
  late MockGetHealthInfoUseCase mockGetHealth;
  late MockUpdateHealthInfoUseCase mockUpdateHealth;
  late HealthInfoCubit cubit;

  const tHealthInfo = HealthInfo(
    id: 1,
    memberId: 5,
    bloodGroup: 'B+',
    heightCm: 175.0,
    baselineWeightKg: 70.0,
  );

  setUpAll(() {
    registerFallbackValue(tHealthInfo);
  });

  setUp(() {
    mockGetHealth = MockGetHealthInfoUseCase();
    mockUpdateHealth = MockUpdateHealthInfoUseCase();
    cubit = HealthInfoCubit(mockGetHealth, mockUpdateHealth);
  });

  tearDown(() => cubit.close());

  group('HealthInfoCubit.load', () {
    test('emits success with info when usecase succeeds', () async {
      when(
        () => mockGetHealth(5),
      ).thenAnswer((_) async => const Right(tHealthInfo));

      await cubit.load(5);

      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.info, tHealthInfo);
      expect(cubit.state.failure, isNull);
    });

    test(
      'emits success with empty HealthInfo when usecase returns NotFoundFailure',
      () async {
        when(
          () => mockGetHealth(5),
        ).thenAnswer((_) async => const Left(NotFoundFailure()));

        await cubit.load(5);

        expect(cubit.state.status, LoadStatus.success);
        expect(cubit.state.info, const HealthInfo(id: 0, memberId: 5));
        expect(cubit.state.failure, isNull);
      },
    );

    test('emits failure when usecase returns NetworkFailure', () async {
      when(
        () => mockGetHealth(5),
      ).thenAnswer((_) async => const Left(NetworkFailure()));

      await cubit.load(5);

      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.info, isNull);
      expect(cubit.state.failure, const NetworkFailure());
    });
  });

  group('HealthInfoCubit.save', () {
    test(
      'emits success with updated info and message when save succeeds',
      () async {
        when(
          () => mockUpdateHealth(any()),
        ).thenAnswer((_) async => const Right(tHealthInfo));

        await cubit.save(tHealthInfo);

        expect(cubit.state.status, LoadStatus.success);
        expect(cubit.state.info, tHealthInfo);
        expect(cubit.state.message, 'saved');
        expect(cubit.state.failure, isNull);
      },
    );

    test('emits failure when save fails', () async {
      when(() => mockUpdateHealth(any())).thenAnswer(
        (_) async => const Left(ValidationFailure(['Invalid height'])),
      );

      await cubit.save(tHealthInfo);

      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, const ValidationFailure(['Invalid height']));
    });
  });
}
