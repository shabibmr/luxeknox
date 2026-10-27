import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan_exercise.dart';
import '../workout_strings.dart';

enum PostRestAction {
  startNextSet,
  nextExercise,
  completeWorkout,
  addMoreRest,
}

class PostRestPromptSheet extends StatelessWidget {
  const PostRestPromptSheet({
    super.key,
    required this.currentExercise,
    required this.currentSetNumber,
    required this.totalSets,
    this.nextExercise,
    this.isLastExercise = false,
  });

  final WorkoutPlanExercise? currentExercise;
  final int currentSetNumber;
  final int? totalSets;
  final WorkoutPlanExercise? nextExercise;
  final bool isLastExercise;

  static Future<PostRestAction?> show(
    BuildContext context, {
    required WorkoutPlanExercise? currentExercise,
    required int currentSetNumber,
    required int? totalSets,
    WorkoutPlanExercise? nextExercise,
    bool isLastExercise = false,
  }) {
    return showModalBottomSheet<PostRestAction>(
      context: context,
      isDismissible: true,
      builder: (sheetContext) => PostRestPromptSheet(
        currentExercise: currentExercise,
        currentSetNumber: currentSetNumber,
        totalSets: totalSets,
        nextExercise: nextExercise,
        isLastExercise: isLastExercise,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMoreSets = totalSets == null || currentSetNumber <= totalSets!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (hasMoreSets) ...[
            Icon(
              Icons.timer_off_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              WorkoutStrings.restCompleteTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ready for Set $currentSetNumber of ${currentExercise?.exerciseName ?? 'Exercise'}?',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text('Start Set $currentSetNumber'),
              onPressed: () => Navigator.of(context).pop(PostRestAction.startNextSet),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_alarm),
              label: const Text(WorkoutStrings.add30sRest),
              onPressed: () => Navigator.of(context).pop(PostRestAction.addMoreRest),
            ),
          ] else if (nextExercise != null) ...[
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              WorkoutStrings.exerciseCompleteTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'All sets completed for ${currentExercise?.exerciseName ?? 'exercise'}. Move to ${nextExercise!.exerciseName}?',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: Text('Next: ${nextExercise!.exerciseName}'),
              onPressed: () => Navigator.of(context).pop(PostRestAction.nextExercise),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_alarm),
              label: const Text(WorkoutStrings.add30sRest),
              onPressed: () => Navigator.of(context).pop(PostRestAction.addMoreRest),
            ),
          ] else ...[
            Icon(
              Icons.emoji_events_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              WorkoutStrings.allExercisesCompleteTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'All planned exercises are completed! You can complete the session now.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.done_all),
              label: const Text(WorkoutStrings.completeSession),
              onPressed: () => Navigator.of(context).pop(PostRestAction.completeWorkout),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ],
      ),
    ),
    ),
    );
  }
}
