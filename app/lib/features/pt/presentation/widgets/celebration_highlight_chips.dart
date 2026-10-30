import 'package:flutter/material.dart';

import '../pt_strings.dart';

/// Celebration chips from the review's highlight list.
class CelebrationHighlightChips extends StatelessWidget {
  const CelebrationHighlightChips({
    super.key,
    required this.highlights,
    this.otherText,
  });

  final List<String> highlights;
  final String? otherText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = [
      for (final highlight in highlights)
        if (highlight.trim().isNotEmpty && highlight != 'other')
          PtStrings.highlightLabel(highlight.trim()),
      if (otherText != null && otherText!.trim().isNotEmpty) otherText!.trim(),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PtStrings.highlightsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (chips.isEmpty)
              Text(PtStrings.noHighlights, style: theme.textTheme.bodyMedium)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in chips)
                    Chip(
                      label: Text(chip),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
