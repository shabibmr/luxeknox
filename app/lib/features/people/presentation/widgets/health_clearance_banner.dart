import 'package:flutter/material.dart';

import '../../domain/entities/par_q_screening.dart';
import '../people_strings.dart';

/// Dossier banner for the member's PAR-Q+ clearance: green when they may
/// train, red while PT booking is blocked, neutral when there is nothing to
/// show ([parQ] null with [unavailable] distinguishing "failed to load" from
/// "none on file").
class HealthClearanceBanner extends StatelessWidget {
  const HealthClearanceBanner({
    super.key,
    required this.parQ,
    required this.unavailable,
  });

  final ParQScreening? parQ;
  final bool unavailable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = parQ?.clearanceStatus;

    final (Key? key, Color color, IconData icon, String label) = unavailable
        ? (
            const ValueKey('clearance-neutral'),
            scheme.outline,
            Icons.help_outline,
            PeopleStrings.clearanceUnavailable,
          )
        : switch (status) {
            ParQClearanceStatus.passed || ParQClearanceStatus.cleared => (
              const ValueKey('clearance-green'),
              Colors.green,
              Icons.verified_outlined,
              PeopleStrings.clearanceCleared,
            ),
            ParQClearanceStatus.pendingClearance => (
              const ValueKey('clearance-red'),
              scheme.error,
              Icons.warning_amber_rounded,
              PeopleStrings.clearancePending,
            ),
            ParQClearanceStatus.rejected => (
              const ValueKey('clearance-red'),
              scheme.error,
              Icons.block,
              PeopleStrings.clearanceRejected,
            ),
            null => (
              null,
              scheme.outline,
              Icons.help_outline,
              PeopleStrings.clearanceNone,
            ),
          };

    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border(bottom: BorderSide(color: color)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
