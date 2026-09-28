import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../cubit/diet_plan_builder_cubit.dart';
import '../diet_strings.dart';
import '../widgets/diet_macro_summary.dart';
import '../widgets/food_picker_sheet.dart';

class DietPlanBuilderScreen extends StatelessWidget {
  const DietPlanBuilderScreen({super.key, this.planId});

  final String? planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DietPlanBuilderCubit>()..init(planId: planId),
      child: _BuilderBody(planId: planId),
    );
  }
}

class _BuilderBody extends StatelessWidget {
  const _BuilderBody({this.planId});

  final String? planId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DietPlanBuilderCubit, DietPlanBuilderState>(
      builder: (context, state) {
        final showForm =
            state.status == LoadStatus.success ||
            state.planId != null ||
            state.title.isNotEmpty ||
            state.meals.isNotEmpty ||
            state.savedPlan != null;
        if (state.status == LoadStatus.loading && !showForm) {
          return Scaffold(
            appBar: AppBar(title: const Text(DietStrings.createTitle)),
            body: const AppLoading(),
          );
        }
        if (state.status == LoadStatus.failure && !showForm) {
          return Scaffold(
            appBar: AppBar(title: const Text(DietStrings.editTitle)),
            body: AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<DietPlanBuilderCubit>().init(planId: planId),
            ),
          );
        }
        return UnsavedChangesScope(
          hasUnsavedChanges: state.dirty && !state.saving,
          child: _BuilderForm(state: state),
        );
      },
    );
  }
}

class _BuilderForm extends StatefulWidget {
  const _BuilderForm({required this.state});

  final DietPlanBuilderState state;

  @override
  State<_BuilderForm> createState() => _BuilderFormState();
}

class _BuilderFormState extends State<_BuilderForm> {
  late final TextEditingController _title;
  late final TextEditingController _memberId;
  late final TextEditingController _calories;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final s = widget.state;
    _title = TextEditingController(text: s.title);
    _memberId = TextEditingController(text: s.memberId);
    _calories = TextEditingController(
      text: s.dailyCalorieTarget?.toString() ?? '',
    );
    _protein = TextEditingController(
      text: s.proteinTargetG?.toString() ?? '',
    );
    _carbs = TextEditingController(text: s.carbsTargetG?.toString() ?? '');
    _fat = TextEditingController(text: s.fatTargetG?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant _BuilderForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.savedPlan == null && widget.state.savedPlan != null) {
      final s = widget.state;
      _title.text = s.title;
      _memberId.text = s.memberId;
      _calories.text = s.dailyCalorieTarget?.toString() ?? '';
      _protein.text = s.proteinTargetG?.toString() ?? '';
      _carbs.text = s.carbsTargetG?.toString() ?? '';
      _fat.text = s.fatTargetG?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _memberId.dispose();
    _calories.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  Future<void> _pickFood(String mealKey) async {
    final food = await showFoodPickerSheet(context);
    if (food == null || !mounted) return;
    context.read<DietPlanBuilderCubit>().addFood(mealKey, food);
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<DietPlanBuilderCubit>();
    final ok = await cubit.save();
    if (!mounted) return;
    if (!ok) {
      final err = cubit.state;
      final message = err.failure != null
          ? failureMessage(err.failure!)
          : (err.validationMessage ?? DietStrings.saveFailed);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    final ready = cubit.state;
    if (ready.planId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(DietStrings.saved)),
      );
      context.go(Routes.trainerPlansDietById(ready.planId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<DietPlanBuilderCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.isEditMode ? DietStrings.editTitle : DietStrings.createTitle,
        ),
        actions: [
          TextButton(
            onPressed: state.saving ? null : _onSave,
            child: state.saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(DietStrings.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: DietStrings.titleLabel,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? DietStrings.titleRequired : null,
              onChanged: cubit.setTitle,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(DietStrings.isTemplateLabel),
              value: state.isTemplate,
              onChanged: cubit.setIsTemplate,
            ),
            TextFormField(
              controller: _memberId,
              decoration: const InputDecoration(
                labelText: DietStrings.memberIdLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: cubit.setMemberId,
            ),
            const SizedBox(height: 12),
            Text(
              DietStrings.targetsSection,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _calories,
              decoration: const InputDecoration(
                labelText: DietStrings.dailyCalorieTargetLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => cubit.setDailyCalorieTarget(
                v.trim().isEmpty ? null : int.tryParse(v.trim()),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _protein,
              decoration: const InputDecoration(
                labelText: DietStrings.proteinTargetLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => cubit.setProteinTargetG(
                v.trim().isEmpty ? null : num.tryParse(v.trim()),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _carbs,
              decoration: const InputDecoration(
                labelText: DietStrings.carbsTargetLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => cubit.setCarbsTargetG(
                v.trim().isEmpty ? null : num.tryParse(v.trim()),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _fat,
              decoration: const InputDecoration(
                labelText: DietStrings.fatTargetLabel,
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => cubit.setFatTargetG(
                v.trim().isEmpty ? null : num.tryParse(v.trim()),
              ),
            ),
            const SizedBox(height: 16),
            DietMacroSummary(
              macros: state.computedMacros,
              calorieTarget: state.dailyCalorieTarget,
              proteinTargetG: state.proteinTargetG,
              carbsTargetG: state.carbsTargetG,
              fatTargetG: state.fatTargetG,
            ),
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: Text(
                    DietStrings.mealsSection,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: state.saving ? null : () => cubit.addMeal(),
                  icon: const Icon(Icons.add),
                  label: const Text(DietStrings.addMeal),
                ),
              ],
            ),
            if (state.meals.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(DietStrings.emptyMeals),
              )
            else
              for (final meal in state.meals) ...[
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: meal.mealName,
                                decoration: const InputDecoration(
                                  labelText: DietStrings.mealNameLabel,
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) => cubit.updateMeal(
                                  meal.key,
                                  mealName: v,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: DietStrings.remove,
                              onPressed: state.saving
                                  ? null
                                  : () => cubit.removeMeal(meal.key),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: meal.scheduledTime ?? '',
                          decoration: const InputDecoration(
                            labelText: DietStrings.scheduledTimeLabel,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => cubit.updateMeal(
                            meal.key,
                            scheduledTime: v.trim().isEmpty ? null : v.trim(),
                            clearScheduledTime: v.trim().isEmpty,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var i = 0; i < meal.foods.length; i++)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              meal.foods[i].foodName ??
                                  'Food #${meal.foods[i].foodId}',
                            ),
                            subtitle: Text(
                              DietStrings.foodLineSubtitle(
                                quantity: meal.foods[i].quantity,
                                servingUnit: meal.foods[i].servingUnit,
                              ),
                            ),
                            trailing: IconButton(
                              tooltip: DietStrings.remove,
                              onPressed: state.saving
                                  ? null
                                  : () => cubit.removeFood(meal.key, i),
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: state.saving
                                ? null
                                : () => _pickFood(meal.key),
                            icon: const Icon(Icons.restaurant_outlined),
                            label: const Text(DietStrings.addFood),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
