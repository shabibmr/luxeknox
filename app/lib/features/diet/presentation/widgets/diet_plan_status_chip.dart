import 'package:flutter/material.dart';

import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/diet_plan_status.dart';
import '../diet_strings.dart';

class DietPlanStatusChip extends StatelessWidget {
  const DietPlanStatusChip({super.key, required this.status});

  final DietPlanStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      DietPlanStatus.draft => (DietStrings.statusDraft, Colors.orange),
      DietPlanStatus.active => (DietStrings.statusActive, Colors.green),
      DietPlanStatus.archived => (DietStrings.statusArchived, scheme.outline),
    };
    return AppStatusChip(label: label, color: color);
  }
}
