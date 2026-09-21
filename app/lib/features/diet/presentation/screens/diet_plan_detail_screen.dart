import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/diet_macros.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_status.dart';
import '../cubit/diet_plan_detail_cubit.dart';
import '../diet_strings.dart';
import '../widgets/diet_macro_summary.dart';
import '../widgets/diet_plan_status_chip.dart';

class DietPlanDetailScreen extends StatelessWidget {
  const DietPlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DietPlanDetailCubit>()..load(planId),
      child: _DietPlanDetailBody(planId: planId),
    );
  }
}

class _DietPlanDetailBody extends StatelessWidget {
  const _DietPlanDetailBody({required this.planId});

  final String planId;

  Future<void> _assign(BuildContext context) async {
    final controller = TextEditingController();
    final memberId = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(DietStrings.assignDialogTitle),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: DietStrings.assignDialogHint,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(DietStrings.assignCancel),
            ),
            FilledButton(
              onPressed: () {
                final raw = controller.text.trim();
                if (raw.isEmpty) return;
                Navigator.of(dialogContext).pop(raw);
              },
              child: const Text(DietStrings.assignConfirm),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (memberId == null || !context.mounted) return;

    final cubit = context.read<DietPlanDetailCubit>();
    await cubit.assignToMember(memberId);
    if (!context.mounted) return;
    final next = cubit.state;
    if (next is DietPlanDetailLoaded && next.assignedPlan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(DietStrings.assigned)),
      );
      final assignedId = next.assignedPlan!.id;
      cubit.clearAssignedPlan();
      context.push(Routes.trainerPlansDietById(assignedId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DietPlanDetailCubit, DietPlanDetailState>(
      builder: (context, state) {
        final plan = switch (state) {
          DietPlanDetailLoaded(:final plan) => plan,
          DietPlanDetailActionInFlight(:final plan) => plan,
          _ => null,
        };
        final inFlight = state is DietPlanDetailActionInFlight;

        return Scaffold(
          appBar: AppBar(
            title: const Text(DietStrings.detailTitle),
            actions: [
              if (plan != null) ...[
                IconButton(
                  tooltip: DietStrings.viewVersions,
                  icon: const Icon(Icons.history),
                  onPressed: inFlight
                      ? null
                      : () => context.push(
                          Routes.trainerPlansDietVersionsById(plan.id),
                        ),
                ),
                IconButton(
                  tooltip: DietStrings.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: inFlight
                      ? null
                      : () => context.push(
                          Routes.trainerPlansDietEditById(plan.id),
                        ),
                ),
                if (plan.isTemplate)
                  IconButton(
                    tooltip: DietStrings.assignToMember,
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    onPressed: inFlight ? null : () => _assign(context),
                  ),
                if (plan.status == DietPlanStatus.draft)
                  IconButton(
                    tooltip: DietStrings.publish,
                    icon: const Icon(Icons.publish_outlined),
                    onPressed: inFlight
                        ? null
                        : () async {
                            final cubit = context.read<DietPlanDetailCubit>();
                            await cubit.publish();
                            if (!context.mounted) return;
                            final next = cubit.state;
                            if (next is DietPlanDetailLoaded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(DietStrings.published),
                                ),
                              );
                            }
                          },
                  ),
                if (plan.status != DietPlanStatus.archived)
                  IconButton(
                    tooltip: DietStrings.archive,
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: inFlight
                        ? null
                        : () async {
                            final cubit = context.read<DietPlanDetailCubit>();
                            await cubit.archive();
                            if (!context.mounted) return;
                            final next = cubit.state;
                            if (next is DietPlanDetailLoaded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(DietStrings.archived),
                                ),
                              );
                            }
                          },
                  ),
              ],
            ],
          ),
          body: switch (state) {
            DietPlanDetailLoading() => const AppLoading(),
            DietPlanDetailFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<DietPlanDetailCubit>().load(planId),
            ),
            DietPlanDetailLoaded(:final plan) ||
            DietPlanDetailActionInFlight(:final plan) => Stack(
              children: [
                _DetailContent(plan: plan),
                if (inFlight)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          },
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.plan});

  final DietPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final macros = computeMacrosFromMeals(plan.meals);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(plan.title, style: theme.textTheme.headlineSmall),
            ),
            DietPlanStatusChip(status: plan.status),
          ],
        ),
        if (plan.isTemplate) ...[
          const SizedBox(height: 8),
          Chip(
            label: Text(
              DietStrings.isTemplateLabel,
              style: theme.textTheme.labelMedium,
            ),
            avatar: const Icon(Icons.copy, size: 16),
          ),
        ],
        if (plan.memberId != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(DietStrings.memberIdLabel),
            subtitle: Text('#${plan.memberId}'),
          ),
        const SizedBox(height: 8),
        DietMacroSummary(
          macros: macros,
          calorieTarget: plan.dailyCalorieTarget,
          proteinTargetG: plan.proteinTargetG,
          carbsTargetG: plan.carbsTargetG,
          fatTargetG: plan.fatTargetG,
        ),
        const Divider(height: 32),
        Text(DietStrings.mealsSection, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (plan.meals.isEmpty)
          const Text(DietStrings.emptyMeals)
        else
          for (final meal in plan.meals) ...[
            Text(meal.mealName, style: theme.textTheme.titleSmall),
            if (meal.scheduledTime != null)
              Text(
                meal.scheduledTime!,
                style: theme.textTheme.bodySmall,
              ),
            for (final food in meal.foods)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(food.foodName ?? 'Food #${food.foodId}'),
                subtitle: Text(
                  DietStrings.foodLineSubtitle(
                    quantity: food.quantity,
                    servingUnit: food.servingUnit,
                  ),
                ),
              ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}
