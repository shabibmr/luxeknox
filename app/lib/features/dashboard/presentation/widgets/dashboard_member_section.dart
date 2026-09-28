import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_snapshot.dart';
import '../dashboard_strings.dart';

class DashboardMemberSection extends StatelessWidget {
  const DashboardMemberSection({super.key, required this.data});

  final DashboardMemberWidget data;

  @override
  Widget build(BuildContext context) {
    final membership = data.membership;
    final trainer = data.assignedTrainer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DashboardStrings.membershipCardTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (membership == null)
              const Text(DashboardStrings.noMembership)
            else ...[
              Text(
                membership.status.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '${membership.daysRemaining} ${DashboardStrings.daysRemaining} '
                '(${membership.endDate})',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (trainer != null) ...[
              const SizedBox(height: 12),
              Text(
                DashboardStrings.assignedTrainer,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(trainer.name, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
