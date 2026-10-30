import 'package:flutter/material.dart';

import '../../domain/entities/par_q_screening.dart';
import '../clearance_status_presentation.dart';

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
    final look = ClearanceStatusPresentation.resolve(
      scheme: Theme.of(context).colorScheme,
      status: parQ?.clearanceStatus,
      unavailable: unavailable,
    );
    final key = look.bannerKey;
    final color = look.color;
    final icon = look.icon;
    final label = look.bannerLabel;

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
