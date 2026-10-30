import 'package:flutter/material.dart';

import '../workout_strings.dart';

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
    this.initialEffort = 7,
    this.initialSatisfaction = 8,
    this.initialPain = 0,
    this.initialNotes,
  });

  final int initialEffort;
  final int initialSatisfaction;
  final int initialPain;
  final String? initialNotes;

  static Future<PostWorkoutFeedbackResult?> show(
    BuildContext context, {
    int initialEffort = 7,
    int initialSatisfaction = 8,
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

    if (painScore > 0 && painNotes.isEmpty) {
      setState(() {
        _painNotesError = 'Please describe any pain or discomfort experienced';
      });
      return;
    }

    final generalNotes = _notesController.text.trim();

    Navigator.of(context).pop(
      PostWorkoutFeedbackResult(
        effortRating: _effort.round(),
        satisfactionRating: _satisfaction.round(),
        painDiscomfortScore: painScore,
        painNotes: painScore > 0 && painNotes.isNotEmpty ? painNotes : null,
        notes: generalNotes.isNotEmpty ? generalNotes : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final painScore = _pain.round();
    final isHighPain = painScore >= 4;

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

              // Effort Slider (1–10)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    WorkoutStrings.effortRatingLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_effort.round()} / 10',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                key: const ValueKey('feedback-effort-slider'),
                value: _effort,
                min: 1,
                max: 10,
                divisions: 9,
                label: '${_effort.round()}',
                onChanged: (val) => setState(() => _effort = val),
              ),
              const SizedBox(height: 12),

              // Satisfaction Slider (1–10)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    WorkoutStrings.satisfactionRatingLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_satisfaction.round()} / 10',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                key: const ValueKey('feedback-satisfaction-slider'),
                value: _satisfaction,
                min: 1,
                max: 10,
                divisions: 9,
                label: '${_satisfaction.round()}',
                onChanged: (val) => setState(() => _satisfaction = val),
              ),
              const SizedBox(height: 12),

              // Pain / Discomfort Slider (0–10)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    WorkoutStrings.painDiscomfortLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isHighPain
                          ? theme.colorScheme.error
                          : painScore > 0
                          ? Colors.orange.shade800
                          : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isHighPain
                          ? theme.colorScheme.errorContainer
                          : painScore > 0
                          ? Colors.orange.shade100
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$painScore / 10',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isHighPain
                            ? theme.colorScheme.onErrorContainer
                            : painScore > 0
                            ? Colors.orange.shade900
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                key: const ValueKey('feedback-pain-slider'),
                value: _pain,
                min: 0,
                max: 10,
                divisions: 10,
                label: '$painScore',
                activeColor: isHighPain
                    ? theme.colorScheme.error
                    : painScore > 0
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

              // High Discomfort Safety Banner
              if (isHighPain) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(
                      alpha: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.error),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          WorkoutStrings.highDiscomfortAlert,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Mandatory Pain Notes when Pain > 0
              if (painScore > 0) ...[
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
