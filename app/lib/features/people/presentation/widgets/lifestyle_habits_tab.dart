import 'package:flutter/material.dart';

import '../../domain/entities/lifestyle_intake.dart';
import '../people_strings.dart';

/// "Lifestyle & Habits" dossier tab: stress, sleep and the four lifestyle
/// priorities as a 2x2 matrix, each with its agreed first action as a badge.
class LifestyleHabitsTab extends StatelessWidget {
  const LifestyleHabitsTab({
    super.key,
    required this.intake,
    required this.unavailable,
  });

  final LifestyleIntake? intake;
  final bool unavailable;

  @override
  Widget build(BuildContext context) {
    final intake = this.intake;
    if (unavailable || intake == null) {
      return Center(
        child: Text(
          unavailable
              ? PeopleStrings.lifestyleUnavailable
              : PeopleStrings.lifestyleNone,
        ),
      );
    }

    final byDomain = {for (final p in intake.priorities) p.domain: p};
    // Matrix order: sleep | nutrition over activity | recovery.
    const rows = [
      [LifestylePriorityDomain.sleep, LifestylePriorityDomain.nutrition],
      [LifestylePriorityDomain.activity, LifestylePriorityDomain.recovery],
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: PeopleStrings.lifestyleStress,
                value: PeopleStrings.stressScore(intake.stressLevel),
              ),
            ),
            if (intake.sleepHoursTypical != null)
              Expanded(
                child: _Metric(
                  label: PeopleStrings.lifestyleSleep,
                  value: PeopleStrings.sleepHours(intake.sleepHoursTypical!),
                ),
              ),
            if (intake.activityLevel != null)
              Expanded(
                child: _Metric(
                  label: PeopleStrings.lifestyleActivity,
                  value: PeopleStrings.activityLevelLabel(
                    intake.activityLevel!.name,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          PeopleStrings.lifestylePriorities,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final row in rows)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final domain in row)
                  Expanded(child: _Quadrant(domain, byDomain[domain])),
              ],
            ),
          ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.labelMedium),
        Text(value, style: theme.headlineSmall),
      ],
    );
  }
}

class _Quadrant extends StatelessWidget {
  const _Quadrant(this.domain, this.priority);

  final LifestylePriorityDomain domain;
  final LifestylePriority? priority;

  static String _label(LifestylePriorityDomain domain) => switch (domain) {
    LifestylePriorityDomain.sleep => PeopleStrings.lifestyleDomainSleep,
    LifestylePriorityDomain.nutrition =>
      PeopleStrings.lifestyleDomainNutrition,
    LifestylePriorityDomain.activity => PeopleStrings.lifestyleDomainActivity,
    LifestylePriorityDomain.recovery => PeopleStrings.lifestyleDomainRecovery,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final priority = this.priority;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_label(domain), style: theme.titleSmall),
            const SizedBox(height: 4),
            if (priority != null) ...[
              Text(priority.currentStatus),
              const SizedBox(height: 8),
              Chip(
                avatar: const Icon(Icons.flag_outlined, size: 16),
                label: Text(priority.firstAction),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
