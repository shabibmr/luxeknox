import 'package:flutter/material.dart';

import '../workout_strings.dart';

class SkipReasonResult {
  const SkipReasonResult({required this.reason, required this.comment});

  final String reason;
  final String comment;
}

class SkipReasonDialog extends StatefulWidget {
  const SkipReasonDialog({super.key, this.isExercise = false});

  final bool isExercise;

  static Future<SkipReasonResult?> show(
    BuildContext context, {
    bool isExercise = false,
  }) {
    return showDialog<SkipReasonResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SkipReasonDialog(isExercise: isExercise),
    );
  }

  @override
  State<SkipReasonDialog> createState() => _SkipReasonDialogState();
}

class _SkipReasonDialogState extends State<SkipReasonDialog> {
  static const _reasons = [
    'Fatigue / Exhaustion',
    'Pain / Discomfort',
    'Equipment Unavailable',
    'Time Constraint',
    'Other',
  ];

  late String _selectedReason;
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedReason = _reasons.first;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isExercise
        ? WorkoutStrings.skipExercise
        : WorkoutStrings.skipSet;

    return AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
                WorkoutStrings.skipReasonLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                items: _reasons
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(r),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedReason = val);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: WorkoutStrings.skipCommentLabel,
                  hintText: WorkoutStrings.skipCommentHint,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) {
                  final text = val?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Comment is required when skipping.';
                  }
                  if (text.length < 5) {
                    return 'Please enter at least 5 characters.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(WorkoutStrings.skipCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              Navigator.of(context).pop(
                SkipReasonResult(
                  reason: _selectedReason,
                  comment: _commentController.text.trim(),
                ),
              );
            }
          },
          child: const Text(WorkoutStrings.skipConfirm),
        ),
      ],
    );
  }
}
