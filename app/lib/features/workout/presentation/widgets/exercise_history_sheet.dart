import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/presentation/app_date_format.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/exercise_history_session.dart';
import '../../domain/usecases/get_exercise_history_usecase.dart';
import '../workout_strings.dart';

class ExerciseHistorySheet extends StatefulWidget {
  const ExerciseHistorySheet({
    super.key,
    this.memberId,
    required this.exerciseId,
    this.exerciseName,
  });

  final String? memberId;
  final String exerciseId;
  final String? exerciseName;

  static Future<void> show(
    BuildContext context, {
    String? memberId,
    required String exerciseId,
    String? exerciseName,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => ExerciseHistorySheet(
        memberId: memberId,
        exerciseId: exerciseId,
        exerciseName: exerciseName,
      ),
    );
  }

  @override
  State<ExerciseHistorySheet> createState() => _ExerciseHistorySheetState();
}

class _ExerciseHistorySheetState extends State<ExerciseHistorySheet> {
  bool _loading = true;
  String? _error;
  List<ExerciseHistorySession> _history = const [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final useCase = getIt<GetExerciseHistoryUseCase>();
    final result = await useCase(
      GetExerciseHistoryParams(
        memberId: widget.memberId,
        exerciseId: widget.exerciseId,
      ),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _loading = false;
          _error = failureMessage(failure);
        });
      },
      (history) {
        setState(() {
          _loading = false;
          _history = history;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.exerciseName ?? 'Exercise #${widget.exerciseId}';

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.history),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${WorkoutStrings.exerciseHistoryTitle}: $title',
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(child: _buildContent(scrollController, theme)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ScrollController scrollController, ThemeData theme) {
    if (_loading) {
      return const Center(child: AppLoading());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _loadHistory,
              child: const Text(WorkoutStrings.retry),
            ),
          ],
        ),
      );
    }

    if (_history.isEmpty) {
      return Center(
        child: Text(
          WorkoutStrings.noExerciseHistory,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final session = _history[index];
        final dateStr = AppDateFormat.historyDateTime(session.startedAt);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                for (final set in session.sets) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          'Set ${set.setNumber}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        if (set.isCompleted == false) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Skipped',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (set.notes != null && set.notes!.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                set.notes!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ] else ...[
                          Text(
                            '${set.weightLiftedKg ?? 0} kg × ${set.repsCompleted ?? 0} reps',
                          ),
                          if (set.rpeScore != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '@ RPE ${set.rpeScore}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (set.notes != null && set.notes!.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '(${set.notes})',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
