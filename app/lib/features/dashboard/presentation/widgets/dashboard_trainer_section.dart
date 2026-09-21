import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_snapshot.dart';
import '../dashboard_strings.dart';

class DashboardTrainerSection extends StatelessWidget {
  const DashboardTrainerSection({super.key, required this.data});

  final DashboardTrainerWidget data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DashboardStrings.assignedMembersTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${data.assignedMembersCount} ${DashboardStrings.assignedMembersCount}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            if (data.assignedMembers.isEmpty)
              const Text(DashboardStrings.noAssignedMembers)
            else
              ...data.assignedMembers.map(
                (member) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(member.name),
                  subtitle: Text(member.membershipNumber),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
