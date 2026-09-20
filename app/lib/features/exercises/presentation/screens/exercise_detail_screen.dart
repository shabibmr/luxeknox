import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/exercise.dart';
import '../bloc/exercise_list_bloc.dart';
import '../bloc/exercise_list_event.dart';
import '../cubit/exercise_detail_cubit.dart';
import '../exercise_strings.dart';
import '../widgets/exercise_media.dart';
import 'exercise_form_screen.dart';

/// Exercise Details screen (screen 30). Pushed on phone; shown as the
/// detail pane on desktop/tablet (K11) via [embedded], which suppresses
/// the back button since there is nothing to pop in that layout.
class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.embedded = false,
  });

  final String exerciseId;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExerciseDetailCubit>()..loadExercise(exerciseId),
      child: _ExerciseDetailView(exerciseId: exerciseId, embedded: embedded),
    );
  }
}

class _ExerciseDetailView extends StatelessWidget {
  const _ExerciseDetailView({required this.exerciseId, required this.embedded});

  final String exerciseId;
  final bool embedded;

  Future<void> _openEditor(BuildContext context, Exercise exercise) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ExerciseFormScreen(exercise: exercise),
      ),
    );
    if (saved != true || !context.mounted) return;

    // Reload detail; refresh the library list when this screen is under it.
    context.read<ExerciseDetailCubit>().loadExercise(exerciseId);
    try {
      context.read<ExerciseListBloc>().add(const ExerciseListRefreshed());
    } catch (_) {
      // Opened outside the library shell (e.g. deep link) — no list to refresh.
    }
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = context.can('exercises.update');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        title: const Text(ExerciseStrings.detailsTitle),
        actions: [
          if (canEdit)
            BlocBuilder<ExerciseDetailCubit, ExerciseDetailState>(
              buildWhen: (previous, current) =>
                  previous.exercise != current.exercise,
              builder: (context, state) {
                final exercise = state.exercise;
                if (exercise == null) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: ExerciseStrings.editTooltip,
                  onPressed: () => _openEditor(context, exercise),
                );
              },
            ),
        ],
      ),
      body: BlocBuilder<ExerciseDetailCubit, ExerciseDetailState>(
        builder: (context, state) {
          return switch (state.status) {
            ExerciseDetailStatus.initial || ExerciseDetailStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            ExerciseDetailStatus.failure => _ErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<ExerciseDetailCubit>().loadExercise(exerciseId),
            ),
            ExerciseDetailStatus.success => _ExerciseDetailBody(
              exercise: state.exercise!,
            ),
          };
        },
      ),
    );
  }
}

class _ExerciseDetailBody extends StatelessWidget {
  const _ExerciseDetailBody({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(exercise.name, style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(exercise.difficultyLevel)),
            Chip(label: Text(exercise.primaryMuscleGroup)),
          ],
        ),
        const SizedBox(height: 16),
        ExerciseMedia(videoUrl: exercise.videoUrl, gifUrl: exercise.gifUrl),
        const SizedBox(height: 16),
        Text(ExerciseStrings.instructions, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(exercise.instructions),
        if (exercise.secondaryMuscles.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(ExerciseStrings.secondaryMuscles, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: exercise.secondaryMuscles
                .map((m) => Chip(label: Text(m)))
                .toList(),
          ),
        ],
        const SizedBox(height: 16),
        Text(ExerciseStrings.equipment, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        exercise.equipmentNeeded.isEmpty
            ? const Text(ExerciseStrings.noEquipment)
            : Wrap(
                spacing: 8,
                children: exercise.equipmentNeeded
                    .map((e) => Chip(label: Text(e)))
                    .toList(),
              ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text(ExerciseStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
