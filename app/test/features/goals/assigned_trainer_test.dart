import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/features/goals/domain/helpers/assigned_trainer.dart';

void main() {
  test('true only when trainer principal matches assigned_trainer_id', () {
    expect(
      resolveIsAssignedTrainer(
        isTrainerPrincipal: true,
        sessionProfileId: '42',
        assignedTrainerId: 42,
      ),
      isTrue,
    );
  });

  test('false when admin or non-trainer principal', () {
    expect(
      resolveIsAssignedTrainer(
        isTrainerPrincipal: false,
        sessionProfileId: '42',
        assignedTrainerId: 42,
      ),
      isFalse,
    );
  });

  test('false when session profile missing or empty', () {
    expect(
      resolveIsAssignedTrainer(
        isTrainerPrincipal: true,
        sessionProfileId: null,
        assignedTrainerId: 42,
      ),
      isFalse,
    );
    expect(
      resolveIsAssignedTrainer(
        isTrainerPrincipal: true,
        sessionProfileId: '',
        assignedTrainerId: 42,
      ),
      isFalse,
    );
  });

  test('false when member has no assigned trainer', () {
    expect(
      resolveIsAssignedTrainer(
        isTrainerPrincipal: true,
        sessionProfileId: '42',
        assignedTrainerId: null,
      ),
      isFalse,
    );
  });

  test('false when ids do not match', () {
    expect(
      resolveIsAssignedTrainer(
        isTrainerPrincipal: true,
        sessionProfileId: '7',
        assignedTrainerId: 42,
      ),
      isFalse,
    );
  });
}
