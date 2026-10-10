import 'package:flutter/material.dart';

import '../../domain/entities/workout_plan.dart';
import '../workout_strings.dart';
import 'plan_status_chip.dart';

/// Modular header card showing workout plan metadata, badges, and status.
class WorkoutPlanHeaderCard extends StatelessWidget {
  const WorkoutPlanHeaderCard({super.key, required this.plan});

  final WorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    plan.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PlanStatusChip(status: plan.status),
              ],
            ),
            if (plan.description != null && plan.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                plan.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (plan.isTemplate)
                  const Chip(
                    avatar: Icon(Icons.copy, size: 14),
                    label: Text(WorkoutStrings.isTemplateLabel),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (plan.targetGoal != null && plan.targetGoal!.isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.track_changes, size: 14),
                    label: Text(plan.targetGoal!),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (plan.difficulty != null && plan.difficulty!.isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.speed, size: 14),
                    label: Text(plan.difficulty!),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (plan.durationWeeks != null)
                  Chip(
                    avatar: const Icon(Icons.calendar_today_outlined, size: 14),
                    label: Text('${plan.durationWeeks} weeks'),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (plan.memberId != null)
                  Chip(
                    avatar: const Icon(Icons.person_outline, size: 14),
                    label: Text('Member #${plan.memberId}'),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
