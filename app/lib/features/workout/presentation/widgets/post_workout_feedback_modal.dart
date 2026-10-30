import 'package:flutter/material.dart';

import '../../domain/workout_pain.dart';
import '../workout_strings.dart';
import 'high_discomfort_alert.dart';
import 'workout_rating_slider.dart';

class PostWorkoutFeedbackResult {
  const PostWorkoutFeedbackResult({
    this.effortRating,
    this.satisfactionRating,
    this.painDiscomfortScore,
    this.painNotes,
    this.notes,
  });

  final int? effortRating;
  final int? satisfactionRating;
  final int? painDiscomfortScore;
  final String? painNotes;
  final String? notes;
}

class PostWorkoutFeedbackModal extends StatefulWidget {
  const PostWorkoutFeedbackModal({
    super.key,
    this.initialEffort = 5,
    this.initialSatisfaction = 5,
    this.initialPain = 0,
    this.initialNotes,
  });

  final int initialEffort;
  final int initialSatisfaction;
  final int initialPain;
  final String? initialNotes;

  static Future<PostWorkoutFeedbackResult?> show(
    BuildContext context, {
    int initialEffort = 5,
    int initialSatisfaction = 5,
    int initialPain = 0,
    String? initialNotes,
  }) {
    return showDialog<PostWorkoutFeedbackResult>(
      context: context,
      builder: (dialogContext) => PostWorkoutFeedbackModal(
        initialEffort: initialEffort,
        initialSatisfaction: initialSatisfaction,
        initialPain: initialPain,
        initialNotes: initialNotes,
      ),
    );
  }

  @override
  State<PostWorkoutFeedbackModal> createState() =>
      _PostWorkoutFeedbackModalState();
}

class _PostWorkoutFeedbackModalState extends State<PostWorkoutFeedbackModal> {
  late double _effort;
  late double _satisfaction;
  late double _pain;
  late final TextEditingController _painNotesController;
  late final TextEditingController _notesController;
  String? _painNotesError;

  @override
  void initState() {
    super.initState();
    _effort = widget.initialEffort.clamp(1, 10).toDouble();
    _satisfaction = widget.initialSatisfaction.clamp(1, 10).toDouble();
    _pain = widget.initialPain.clamp(0, 10).toDouble();
    _painNotesController = TextEditingController();
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _painNotesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final painScore = _pain.round();
    final painNotes = _painNotesController.text.trim();

    if (WorkoutPain.requiresNotes(painScore) && painNotes.isEmpty) {
      setState(() {
        _painNotesError = WorkoutStrings.painNotesRequiredError;
      });
      return;
    }

    final generalNotes = _notesController.text.trim();

    Navigator.of(context).pop(
      PostWorkoutFeedbackResult(
        effortRating: _effort.round(),
        satisfactionRating: _satisfaction.round(),
        painDiscomfortScore: painScore,
        painNotes: WorkoutPain.requiresNotes(painScore) && painNotes.isNotEmpty
            ? painNotes
            : null,
        notes: generalNotes.isNotEmpty ? generalNotes : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final painScore = _pain.round();
    final isHighPain = WorkoutPain.isHighPain(painScore);
    final needsNotes = WorkoutPain.requiresNotes(painScore);

    return AlertDialog(
      title: const Text(WorkoutStrings.completeConfirmTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                WorkoutStrings.completeConfirmMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              WorkoutRatingSlider(
                sliderKey: const ValueKey('feedback-effort-slider'),
                label: WorkoutStrings.effortRatingLabel,
                value: _effort,
                min: 1,
                max: 10,
                badgeBackground: theme.colorScheme.primaryContainer,
                badgeForeground: theme.colorScheme.onPrimaryContainer,
                onChanged: (val) => setState(() => _effort = val),
              ),
              const SizedBox(height: 12),

              WorkoutRatingSlider(
                sliderKey: const ValueKey('feedback-satisfaction-slider'),
                label: WorkoutStrings.satisfactionRatingLabel,
                value: _satisfaction,
                min: 1,
                max: 10,
                badgeBackground: theme.colorScheme.secondaryContainer,
                badgeForeground: theme.colorScheme.onSecondaryContainer,
                onChanged: (val) => setState(() => _satisfaction = val),
              ),
              const SizedBox(height: 12),

              WorkoutRatingSlider(
                sliderKey: const ValueKey('feedback-pain-slider'),
                label: WorkoutStrings.painDiscomfortLabel,
                value: _pain,
                min: 0,
                max: 10,
                labelColor: isHighPain
                    ? theme.colorScheme.error
                    : needsNotes
                    ? Colors.orange.shade800
                    : null,
                badgeBackground: isHighPain
                    ? theme.colorScheme.errorContainer
                    : needsNotes
                    ? Colors.orange.shade100
                    : theme.colorScheme.surfaceContainerHighest,
                badgeForeground: isHighPain
                    ? theme.colorScheme.onErrorContainer
                    : needsNotes
                    ? Colors.orange.shade900
                    : theme.colorScheme.onSurfaceVariant,
                activeColor: isHighPain
                    ? theme.colorScheme.error
                    : needsNotes
                    ? Colors.orange
                    : theme.colorScheme.primary,
                onChanged: (val) {
                  setState(() {
                    _pain = val;
                    if (val.round() == 0) {
                      _painNotesError = null;
                    }
                  });
                },
              ),

              if (isHighPain) const HighDiscomfortAlert(),

              if (needsNotes) ...[
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('feedback-pain-notes-field'),
                  controller: _painNotesController,
                  onChanged: (_) {
                    if (_painNotesError != null) {
                      setState(() => _painNotesError = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: WorkoutStrings.painNotesLabel,
                    hintText: WorkoutStrings.painNotesHint,
                    errorText: _painNotesError,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],

              const SizedBox(height: 16),

              // General Session Notes
              TextField(
                key: const ValueKey('feedback-general-notes-field'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: WorkoutStrings.notesLabel,
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(WorkoutStrings.completeConfirmCancel),
        ),
        FilledButton(
          key: const ValueKey('feedback-modal-submit-btn'),
          onPressed: _submit,
          child: const Text(WorkoutStrings.completeConfirmAction),
        ),
      ],
    );
  }
}
