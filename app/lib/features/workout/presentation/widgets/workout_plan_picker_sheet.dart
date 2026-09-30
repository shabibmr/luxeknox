import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/usecases/list_workout_plans_usecase.dart';
import '../workout_strings.dart';

/// Opens a bottom sheet displaying the member's available workout plans for selection.
Future<WorkoutPlan?> showWorkoutPlanPickerSheet(
  BuildContext context, {
  String? memberId,
  ListWorkoutPlansUseCase? listPlans,
}) {
  return showModalBottomSheet<WorkoutPlan>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => WorkoutPlanPickerSheet(
      memberId: memberId,
      listPlans: listPlans,
    ),
  );
}

class WorkoutPlanPickerSheet extends StatelessWidget {
  const WorkoutPlanPickerSheet({
    super.key,
    this.memberId,
    this.listPlans,
  });

  final String? memberId;
  final ListWorkoutPlansUseCase? listPlans;

  @override
  Widget build(BuildContext context) {
    final useCase = listPlans ?? getIt<ListWorkoutPlansUseCase>();

    return AppPagedPickerSheet<WorkoutPlan>(
      searchLabel: 'Search plans...',
      emptyMessage: WorkoutStrings.noneFound,
      retryLabel: WorkoutStrings.retry,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                WorkoutStrings.listTitle,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      fetcher: ({cursor, query}) async {
        final result = await useCase(
          ListWorkoutPlansParams(
            memberId: memberId,
            isTemplate: false,
            limit: 50,
            offset: cursor != null ? int.tryParse(cursor) : null,
          ),
        );
        if (query == null || query.trim().isEmpty) return result;
        return result.map(
          (page) => CursorPage(
            items: page.items
                .where((p) =>
                    p.title.toLowerCase().contains(query.trim().toLowerCase()))
                .toList(),
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
      itemBuilder: (ctx, plan) {
        final subtitleParts = [
          if (plan.targetGoal != null && plan.targetGoal!.isNotEmpty)
            plan.targetGoal!,
          if (plan.difficulty != null && plan.difficulty!.isNotEmpty)
            plan.difficulty!,
          if (plan.exercises.isNotEmpty)
            '${plan.exercises.length} exercises',
        ];
        return ListTile(
          title: Text(plan.title),
          subtitle: subtitleParts.isNotEmpty
              ? Text(subtitleParts.join(' · '))
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(ctx).pop(plan),
        );
      },
    );
  }
}

/// A form field widget for selecting a workout plan.
class WorkoutPlanPickerField extends StatelessWidget {
  const WorkoutPlanPickerField({
    super.key,
    this.selectedPlan,
    this.onChanged,
    this.memberId,
    this.listPlans,
    this.enabled = true,
  });

  final WorkoutPlan? selectedPlan;
  final ValueChanged<WorkoutPlan?>? onChanged;
  final String? memberId;
  final ListWorkoutPlansUseCase? listPlans;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<WorkoutPlan>(
      value: selectedPlan,
      labelText: 'Workout Plan',
      hintText: 'Select workout plan',
      labelBuilder: (plan) => plan.title,
      enabled: enabled,
      onPick: (ctx) => showWorkoutPlanPickerSheet(
        ctx,
        memberId: memberId,
        listPlans: listPlans,
      ),
      onChanged: onChanged ?? (_) {},
    );
  }
}
