import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/people/domain/entities/health_info.dart';
import 'package:luxeknox/features/people/domain/usecases/create_health_record_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_health_history_usecase.dart';
import 'package:luxeknox/features/people/presentation/cubit/health_history_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockListHealthHistoryUseCase extends Mock
    implements ListHealthHistoryUseCase {}

class MockCreateHealthRecordUseCase extends Mock
    implements CreateHealthRecordUseCase {}

void main() {
  late MockListHealthHistoryUseCase mockList;
  late MockCreateHealthRecordUseCase mockCreate;
  late HealthHistoryCubit cubit;

  final tOlder = HealthInfo(
    id: 1,
    memberId: 5,
    bloodGroup: 'B+',
    recordedAt: DateTime(2026, 1, 1),
  );
  final tNewer = HealthInfo(
    id: 2,
    memberId: 5,
    bloodGroup: 'O+',
    recordedAt: DateTime(2026, 2, 1),
  );

  setUpAll(() {
    registerFallbackValue(tOlder);
  });

  setUp(() {
    mockList = MockListHealthHistoryUseCase();
    mockCreate = MockCreateHealthRecordUseCase();
    cubit = HealthHistoryCubit(mockList, mockCreate);
  });

  tearDown(() => cubit.close());

  group('HealthHistoryCubit.load', () {
    test('emits records desc-sorted with currentIndex 0 when usecase succeeds', () async {
      when(() => mockList(5)).thenAnswer((_) async => Right([tNewer, tOlder]));

      await cubit.load(5);

      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.records, [tNewer, tOlder]);
      expect(cubit.state.currentIndex, 0);
    });

    test('emits a single synthetic blank record when history is empty', () async {
      when(() => mockList(5)).thenAnswer((_) async => const Right(<HealthInfo>[]));

      await cubit.load(5);

      expect(cubit.state.status, LoadStatus.success);
      expect(cubit.state.records.length, 1);
      expect(cubit.state.records[0].id, 0);
      expect(cubit.state.records[0].memberId, 5);
      expect(cubit.state.currentIndex, 0);
    });

    test('emits failure when usecase fails', () async {
      when(() => mockList(5)).thenAnswer((_) async => const Left(NetworkFailure()));

      await cubit.load(5);

      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
    });
  });

  group('HealthHistoryCubit.save', () {
    test('creates a new record and reloads to currentIndex 0', () async {
      when(() => mockCreate(any())).thenAnswer((_) async => Right(tNewer));
      when(() => mockList(5)).thenAnswer((_) async => Right([tNewer, tOlder]));

      await cubit.save(tOlder);

      expect(cubit.state.records[0], tNewer);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.state.status, LoadStatus.success);
    });

    test('emits failure without mutating records when create fails', () async {
      when(() => mockList(5)).thenAnswer((_) async => Right([tOlder]));
      await cubit.load(5);

      when(() => mockCreate(any()))
          .thenAnswer((_) async => const Left(ValidationFailure(['Invalid height'])));

      await cubit.save(tOlder);

      expect(cubit.state.records, [tOlder]);
      expect(cubit.state.status, LoadStatus.failure);
      expect(cubit.state.failure, const ValidationFailure(['Invalid height']));
    });
  });

  group('HealthHistoryCubit.previous/next', () {
    test('previous moves to an older record and next moves back', () async {
      final oldest = HealthInfo(id: 3, memberId: 5, recordedAt: DateTime(2025, 12, 1));
      when(() => mockList(5))
          .thenAnswer((_) async => Right([tNewer, tOlder, oldest]));
      await cubit.load(5);

      expect(cubit.state.currentIndex, 0);
      expect(cubit.canGoPrevious, isTrue);
      expect(cubit.canGoNext, isFalse);

      cubit.previous();
      expect(cubit.state.currentIndex, 1);

      cubit.previous();
      expect(cubit.state.currentIndex, 2);
      expect(cubit.canGoPrevious, isFalse);

      cubit.previous();
      expect(cubit.state.currentIndex, 2);

      cubit.next();
      expect(cubit.state.currentIndex, 1);
      expect(cubit.canGoNext, isTrue);
    });
  });
}
