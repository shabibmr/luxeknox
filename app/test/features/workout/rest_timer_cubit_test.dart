import 'dart:async';

import 'package:luxeknox/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('countdown skip and addSeconds', () async {
    final controller = StreamController<void>.broadcast();
    addTearDown(controller.close);

    final cubit = RestTimerCubit(ticker: () => controller.stream);
    addTearDown(cubit.close);

    cubit.start(3);
    expect(cubit.state.remainingSeconds, 3);
    expect(cubit.state.isRunning, isTrue);

    controller.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.remainingSeconds, 2);

    cubit.addSeconds(15);
    expect(cubit.state.remainingSeconds, 17);

    cubit.skip();
    expect(cubit.state.remainingSeconds, 0);
    expect(cubit.state.isFinished, isTrue);
    expect(cubit.state.isRunning, isFalse);

    cubit.cancel();
    expect(cubit.state, const RestTimerState.idle());
  });

  test('reaches finished on last tick', () async {
    final controller = StreamController<void>.broadcast();
    addTearDown(controller.close);

    final cubit = RestTimerCubit(ticker: () => controller.stream);
    addTearDown(cubit.close);

    cubit.start(1);
    controller.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.isFinished, isTrue);
    expect(cubit.state.remainingSeconds, 0);
  });
}
