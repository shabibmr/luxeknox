import 'package:flutter/material.dart';

import '../pt_strings.dart';
import '../review_format.dart';

/// Next goal, training focus, and the next review date.
class NextPhaseRoadmapCard extends StatelessWidget {
  const NextPhaseRoadmapCard({
    super.key,
    this.goal,
    this.trainingFocus,
    this.nextReviewDate,
  });

  final String? goal;
  final String? trainingFocus;
  final DateTime? nextReviewDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PtStrings.roadmapTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            _line(context, PtStrings.nextPhaseGoal, goal),
            _line(context, PtStrings.nextPhaseFocus, trainingFocus),
            _line(
              context,
              PtStrings.nextReviewDate,
              nextReviewDate == null ? null : formatReviewDate(nextReviewDate!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(BuildContext context, String label, String? value) {
    final theme = Theme.of(context);
    final shown = (value == null || value.trim().isEmpty)
        ? PtStrings.notSet
        : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelLarge),
          const SizedBox(height: 2),
          Text(shown, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
