import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/features/pt/domain/entities/pt_subscription.dart';
import 'package:luxeknox/features/pt/domain/repositories/pt_repository.dart';
import 'package:luxeknox/features/pt/domain/usecases/pt_usecases.dart';
import 'package:mocktail/mocktail.dart';

class MockPtRepository extends Mock implements PtRepository {}

void main() {
  late MockPtRepository repository;
  late ReplanPtUseCase useCase;

  final sub = PtSubscription(
    id: 9,
    memberId: 42,
    ptProductId: 3,
    trainerId: 7,
    startDate: DateTime(2026, 10, 5),
    endDate: DateTime(2026, 11, 2),
    weekdays: const [1, 3, 5],
    slotStart: '17:00:00',
    status: PtSubscriptionStatus.active,
    rowVersion: 1,
    productName: 'PT',
    sessionsPerWeek: 3,
    trainerName: 'Rina',
    slotLabel: '17:00-18:00',
  );

  ReplanPtParams params({
    int trainerId = 7,
    List<int> weekdays = const [1, 3, 5],
    String slotStart = '17:00:00',
  }) => ReplanPtParams(
    subscription: sub,
    trainerId: trainerId,
    weekdays: weekdays,
    slotStart: slotStart,
    effectiveDate: DateTime(2026, 10, 12),
  );

  setUpAll(() => registerFallbackValue(DateTime(2026)));

  setUp(() {
    repository = MockPtRepository();
    useCase = ReplanPtUseCase(repository);
    when(
      () => repository.changeSlot(
        any(),
        weekdays: any(named: 'weekdays'),
        slotStart: any(named: 'slotStart'),
        trainerId: any(named: 'trainerId'),
        effectiveDate: any(named: 'effectiveDate'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => Right(sub));
    when(
      () => repository.reassignTrainer(
        any(),
        trainerId: any(named: 'trainerId'),
        effectiveDate: any(named: 'effectiveDate'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => Right(sub));
  });

  test('a trainer-only change reassigns the trainer', () async {
    await useCase(params(trainerId: 8));
    verify(
      () => repository.reassignTrainer(
        9,
        trainerId: 8,
        effectiveDate: any(named: 'effectiveDate'),
        reason: any(named: 'reason'),
      ),
    ).called(1);
  });

  test('a slot change sends the trainer only when it changed', () async {
    await useCase(params(slotStart: '18:00:00'));
    verify(
      () => repository.changeSlot(
        9,
        weekdays: any(named: 'weekdays'),
        slotStart: '18:00:00',
        trainerId: null,
        effectiveDate: any(named: 'effectiveDate'),
        reason: any(named: 'reason'),
      ),
    ).called(1);
  });

  test('weekday order alone is not a change', () {
    expect(params(weekdays: const [5, 1, 3]).slotChanged, isFalse);
    expect(params(weekdays: const [1, 2, 3]).slotChanged, isTrue);
  });

  test('a malformed short slot does not throw', () {
    expect(params(slotStart: '9').slotChanged, isTrue);
  });
}
