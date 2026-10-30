import 'package:flutter/material.dart';

import '../../domain/entities/pt_progress_review.dart';
import '../pt_strings.dart';

const _highlightKeys = [
  'improved_technique',
  'increased_strength',
  'improved_conditioning',
  'better_consistency',
  'improved_mobility',
  'goal_milestone',
  'other',
];

/// Draft-only editor for celebration highlights and the six-item checklist.
class ReviewCardEditor extends StatefulWidget {
  const ReviewCardEditor({
    super.key,
    required this.review,
    required this.saving,
    required this.onSave,
    required this.onDirtyChanged,
  });

  final PtProgressReview review;
  final bool saving;
  final ValueChanged<PtProgressReviewCardEdit> onSave;
  final ValueChanged<bool> onDirtyChanged;

  @override
  State<ReviewCardEditor> createState() => _ReviewCardEditorState();
}

class _ReviewCardEditorState extends State<ReviewCardEditor> {
  late Set<String> _highlights;
  late PtReviewChecklist _checklist;
  late final TextEditingController _other;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _highlights = {...widget.review.progressHighlights};
    _checklist = widget.review.reviewChecklist ?? const PtReviewChecklist();
    _other = TextEditingController(text: widget.review.highlightsOtherText);
  }

  @override
  void didUpdateWidget(ReviewCardEditor old) {
    super.didUpdateWidget(old);
    // A saved review comes back from the server: the editor is clean again.
    if (old.review != widget.review && _dirty) _setDirty(false);
  }

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  void _setDirty(bool value) {
    _dirty = value;
    // Reported after the frame so the parent is not rebuilt mid-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onDirtyChanged(value);
    });
  }

  void _change(VoidCallback mutate) {
    setState(mutate);
    if (!_dirty) _setDirty(true);
  }

  void _toggleHighlight(String key, bool selected) => _change(() {
    selected ? _highlights.add(key) : _highlights.remove(key);
  });

  void _save() {
    final other = _highlights.contains('other') ? _other.text.trim() : '';
    widget.onSave(
      PtProgressReviewCardEdit(
        progressHighlights: [
          for (final key in _highlightKeys)
            if (_highlights.contains(key)) key,
        ],
        highlightsOtherText: other.isEmpty ? null : other,
        reviewChecklist: _checklist,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = _checklist;
    final rows = <(String, bool, PtReviewChecklist Function(bool))>[
      (
        PtStrings.goalsReviewed,
        c.goalsReviewed,
        (v) => c.copyWith(goalsReviewed: v),
      ),
      (
        PtStrings.measurementsReviewed,
        c.measurementsReviewed,
        (v) => c.copyWith(measurementsReviewed: v),
      ),
      (
        PtStrings.performanceReviewed,
        c.performanceReviewed,
        (v) => c.copyWith(performanceReviewed: v),
      ),
      (
        PtStrings.attendanceReviewed,
        c.attendanceReviewed,
        (v) => c.copyWith(attendanceReviewed: v),
      ),
      (
        PtStrings.programUpdated,
        c.programUpdated,
        (v) => c.copyWith(programUpdated: v),
      ),
      (
        PtStrings.nextGoalsAgreed,
        c.nextGoalsAgreed,
        (v) => c.copyWith(nextGoalsAgreed: v),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PtStrings.highlightsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in _highlightKeys)
                  FilterChip(
                    key: Key('highlight-$key'),
                    label: Text(PtStrings.highlightLabel(key)),
                    selected: _highlights.contains(key),
                    onSelected: widget.saving
                        ? null
                        : (v) => _toggleHighlight(key, v),
                  ),
              ],
            ),
            if (_highlights.contains('other')) ...[
              const SizedBox(height: 12),
              TextField(
                key: const Key('highlight-other-text'),
                controller: _other,
                enabled: !widget.saving,
                onChanged: (_) => _change(() {}),
                decoration: const InputDecoration(
                  labelText: PtStrings.highlightsOtherLabel,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(PtStrings.checklistTitle, style: theme.textTheme.titleMedium),
            for (final (label, checked, update) in rows)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: checked,
                onChanged: widget.saving
                    ? null
                    : (v) => _change(() => _checklist = update(v ?? false)),
                title: Text(label),
              ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: widget.saving || !_dirty ? null : _save,
              child: const Text(PtStrings.saveCard),
            ),
          ],
        ),
      ),
    );
  }
}
