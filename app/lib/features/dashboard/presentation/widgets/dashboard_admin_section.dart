import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_snapshot.dart';
import '../dashboard_strings.dart';

class DashboardAdminSection extends StatelessWidget {
  const DashboardAdminSection({super.key, required this.data});

  final DashboardAdminWidget data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DashboardStrings.overviewTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(
                  label: DashboardStrings.members,
                  value: data.membersTotal,
                ),
                _Stat(
                  label: DashboardStrings.trainers,
                  value: data.trainersTotal,
                  subValue: data.trainersActive,
                ),
                _Stat(
                  label: DashboardStrings.employees,
                  value: data.employeesTotal,
                  subValue: data.employeesActive,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              DashboardStrings.membershipsByStatus,
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final entry in data.membershipsByStatus.entries)
                  Chip(label: Text('${entry.key}: ${entry.value}')),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${DashboardStrings.expiringSoon} '
              '(${data.expiringSoon.days}d): ${data.expiringSoon.count}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.subValue});

  final String label;
  final int value;
  final int? subValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text('$value', style: theme.textTheme.headlineSmall),
          if (subValue != null)
            Text(
              '$subValue active',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}
