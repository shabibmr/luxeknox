import 'package:flutter/material.dart';

import '../pt_strings.dart';
import '../review_format.dart';

/// Fields the draft endpoint accepts. Measures are calculated on the server.
class ProgressReviewDraftForm extends StatefulWidget {
  const ProgressReviewDraftForm({
    super.key,
    required this.submitting,
    required this.initialPeriodStart,
    required this.initialPeriodEnd,
    this.initialNextReviewDate,
    required this.onCreate,
  });

  final bool submitting;
  final DateTime initialPeriodStart;
  final DateTime initialPeriodEnd;
  final DateTime? initialNextReviewDate;
  final void Function({
    required DateTime periodStart,
    required DateTime periodEnd,
    required String trainerSummary,
    required String clientFeedback,
    required String nextPhaseGoal,
    required String nextPhaseTrainingFocus,
    required DateTime? nextReviewDate,
  })
  onCreate;

  @override
  State<ProgressReviewDraftForm> createState() =>
      _ProgressReviewDraftFormState();
}

class _ProgressReviewDraftFormState extends State<ProgressReviewDraftForm> {
  late DateTime _start;
  late DateTime _end;
  DateTime? _nextReview;
  late final TextEditingController _summary;
  late final TextEditingController _feedback;
  late final TextEditingController _goal;
  late final TextEditingController _focus;

  @override
  void initState() {
    super.initState();
    _start = widget.initialPeriodStart;
    _end = widget.initialPeriodEnd;
    _nextReview = widget.initialNextReviewDate;
    _summary = TextEditingController();
    _feedback = TextEditingController();
    _goal = TextEditingController();
    _focus = TextEditingController();
  }

  @override
  void dispose() {
    _summary.dispose();
    _feedback.dispose();
    _goal.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _pick(DateTime initial, ValueChanged<DateTime> assign) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(initial.year - 5),
      lastDate: DateTime(initial.year + 5),
    );
    if (picked == null) return;
    setState(() => assign(picked));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(PtStrings.reviewPeriod, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        TextButton(
          onPressed: widget.submitting
              ? null
              : () => _pick(_start, (picked) => _start = picked),
          child: Text('${PtStrings.periodStart}: ${formatReviewDate(_start)}'),
        ),
        TextButton(
          onPressed: widget.submitting
              ? null
              : () => _pick(_end, (picked) => _end = picked),
          child: Text('${PtStrings.periodEnd}: ${formatReviewDate(_end)}'),
        ),
        TextButton(
          onPressed: widget.submitting
              ? null
              : () => _pick(
                  _nextReview ?? _end,
                  (picked) => _nextReview = picked,
                ),
          child: Text(
            '${PtStrings.nextReviewDate}: ${_nextReview == null ? PtStrings.notSet : formatReviewDate(_nextReview!)}',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('review-summary'),
          controller: _summary,
          enabled: !widget.submitting,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: PtStrings.trainerSummary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('review-feedback'),
          controller: _feedback,
          enabled: !widget.submitting,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: PtStrings.clientFeedback,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('review-next-goal'),
          controller: _goal,
          enabled: !widget.submitting,
          decoration: const InputDecoration(labelText: PtStrings.nextPhaseGoal),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('review-next-focus'),
          controller: _focus,
          enabled: !widget.submitting,
          decoration: const InputDecoration(
            labelText: PtStrings.nextPhaseFocus,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: widget.submitting
              ? null
              : () => widget.onCreate(
                  periodStart: _start,
                  periodEnd: _end,
                  trainerSummary: _summary.text,
                  clientFeedback: _feedback.text,
                  nextPhaseGoal: _goal.text,
                  nextPhaseTrainingFocus: _focus.text,
                  nextReviewDate: _nextReview,
                ),
          child: const Text(PtStrings.createDraft),
        ),
      ],
    );
  }
}
