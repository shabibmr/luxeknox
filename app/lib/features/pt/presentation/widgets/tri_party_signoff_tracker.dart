import 'package:flutter/material.dart';

import '../../domain/entities/pt_progress_review.dart';
import '../cubit/pt_progress_review_cubit.dart';
import '../pt_strings.dart';
import '../review_format.dart';

/// Trainer, client, and manager. The button for the party whose turn it is
/// is the only one shown.
class TriPartySignoffTracker extends StatelessWidget {
  const TriPartySignoffTracker({
    super.key,
    required this.review,
    required this.audience,
    required this.acting,
    required this.onTrainerSign,
    required this.onClientSign,
    required this.onManagerApprove,
    required this.onExport,
  });

  final PtProgressReview review;
  final PtProgressReviewAudience audience;
  final bool acting;
  final VoidCallback onTrainerSign;
  final VoidCallback onClientSign;
  final VoidCallback onManagerApprove;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showTrainer =
        audience == PtProgressReviewAudience.trainer &&
        review.status == PtProgressReviewStatus.draft;
    final showClient =
        audience == PtProgressReviewAudience.member &&
        review.status == PtProgressReviewStatus.pendingClientSign;
    final showManager =
        audience == PtProgressReviewAudience.manager &&
        review.status == PtProgressReviewStatus.pendingManagerApproval;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(PtStrings.signoffTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _party(context, PtStrings.trainerParty, review.trainerSignedAt),
            if (showTrainer)
              FilledButton(
                onPressed: acting ? null : onTrainerSign,
                child: const Text(PtStrings.signAsTrainer),
              ),
            _party(context, PtStrings.clientParty, review.clientSignedAt),
            if (showClient)
              FilledButton(
                onPressed: acting ? null : onClientSign,
                child: const Text(PtStrings.signAsClient),
              ),
            _party(context, PtStrings.managerParty, review.managerSignedAt),
            if (showManager)
              FilledButton(
                onPressed: acting ? null : onManagerApprove,
                child: const Text(PtStrings.approveReview),
              ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: acting ? null : onExport,
              child: const Text(PtStrings.exportPdf),
            ),
          ],
        ),
      ),
    );
  }

  Widget _party(BuildContext context, String label, DateTime? signedAt) {
    final theme = Theme.of(context);
    final value = signedAt == null
        ? PtStrings.pending
        : formatReviewDate(signedAt);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(value, style: theme.textTheme.bodyLarge),
    );
  }
}
