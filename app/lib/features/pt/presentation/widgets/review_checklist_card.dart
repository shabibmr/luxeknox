import 'package:flutter/material.dart';

import '../../domain/entities/pt_progress_review.dart';
import '../pt_strings.dart';

/// The six discussed items. The API does not accept edits, so they are read-only.
class ReviewChecklistCard extends StatelessWidget {
  const ReviewChecklistCard({super.key, required this.checklist});

  final PtReviewChecklist? checklist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = checklist ?? const PtReviewChecklist();
    final rows = <(String, bool)>[
      (PtStrings.goalsReviewed, items.goalsReviewed),
      (PtStrings.measurementsReviewed, items.measurementsReviewed),
      (PtStrings.performanceReviewed, items.performanceReviewed),
      (PtStrings.attendanceReviewed, items.attendanceReviewed),
      (PtStrings.programUpdated, items.programUpdated),
      (PtStrings.nextGoalsAgreed, items.nextGoalsAgreed),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PtStrings.checklistTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            for (final (label, checked) in rows)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: checked,
                onChanged: null,
                title: Text(label),
              ),
          ],
        ),
      ),
    );
  }
}
