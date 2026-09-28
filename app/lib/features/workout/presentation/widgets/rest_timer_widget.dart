import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/rest_timer_cubit.dart';
import '../workout_strings.dart';

class RestTimerWidget extends StatelessWidget {
  const RestTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestTimerCubit, RestTimerState>(
      builder: (context, state) {
        if (!state.isRunning && !state.isFinished && state.totalSeconds == 0) {
          return const SizedBox.shrink();
        }
        final theme = Theme.of(context);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(WorkoutStrings.restTimer, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  WorkoutStrings.restRemaining(state.remainingSeconds),
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                if (state.isFinished)
                  Text(
                    'Done',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<RestTimerCubit>().cancel(),
                        child: const Text(WorkoutStrings.restCancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<RestTimerCubit>().addSeconds(15),
                        child: const Text(WorkoutStrings.restAdd15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.read<RestTimerCubit>().skip(),
                        child: const Text(WorkoutStrings.restSkip),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
