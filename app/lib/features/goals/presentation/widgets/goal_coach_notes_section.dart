import 'package:flutter/material.dart';

import '../../domain/entities/progress_note.dart';
import '../goals_strings.dart';

class GoalCoachNotesSection extends StatelessWidget {
  const GoalCoachNotesSection({super.key, required this.notes});

  final List<ProgressNote> notes;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('goal-view-coach-notes'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GoalsStrings.coachNotesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (notes.isEmpty)
          const Text(GoalsStrings.coachNotesEmpty)
        else
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GoalsStrings.calendarDate(note.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(note.noteText),
                ],
              ),
            ),
      ],
    );
  }
}
