import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/food.dart';
import '../bloc/food_list_bloc.dart';
import '../bloc/food_list_event.dart';
import '../cubit/food_detail_cubit.dart';
import '../foods_strings.dart';
import '../widgets/food_macro_breakdown.dart';
import 'food_form_screen.dart';

/// Food Details screen (screen 36). Pushed on phone; shown as the detail
/// pane on desktop/tablet via [embedded], which suppresses the back button
/// since there is nothing to pop in that layout.
class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({
    super.key,
    required this.foodId,
    this.embedded = false,
  });

  final String foodId;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FoodDetailCubit>()..loadFood(foodId),
      child: _FoodDetailView(foodId: foodId, embedded: embedded),
    );
  }
}

class _FoodDetailView extends StatelessWidget {
  const _FoodDetailView({required this.foodId, required this.embedded});

  final String foodId;
  final bool embedded;

  Future<void> _openEditor(BuildContext context, Food food) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => FoodFormScreen(food: food)),
    );
    if (saved != true || !context.mounted) return;

    // Reload detail; refresh the library list when this screen is under it.
    context.read<FoodDetailCubit>().loadFood(foodId);
    try {
      context.read<FoodListBloc>().add(const FoodListRefreshed());
    } catch (_) {
      // Opened outside the library shell (e.g. deep link) — no list to refresh.
    }
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = context.can('foods.update');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        title: const Text(FoodStrings.detailsTitle),
        actions: [
          if (canEdit)
            BlocBuilder<FoodDetailCubit, FoodDetailState>(
              buildWhen: (previous, current) => previous.food != current.food,
              builder: (context, state) {
                final food = state.food;
                if (food == null) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: FoodStrings.editTooltip,
                  onPressed: () => _openEditor(context, food),
                );
              },
            ),
        ],
      ),
      body: BlocBuilder<FoodDetailCubit, FoodDetailState>(
        builder: (context, state) {
          return switch (state.status) {
            FoodDetailStatus.initial || FoodDetailStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            FoodDetailStatus.failure => _ErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<FoodDetailCubit>().loadFood(foodId),
            ),
            FoodDetailStatus.success => _FoodDetailBody(food: state.food!),
          };
        },
      ),
    );
  }
}

class _FoodDetailBody extends StatelessWidget {
  const _FoodDetailBody({required this.food});

  final Food food;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(food.name, style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(food.servingUnit)),
            if (food.isVerified) const Chip(label: Text(FoodStrings.verified)),
          ],
        ),
        const SizedBox(height: 16),
        Text(FoodStrings.nutrition, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        _NutritionRow(
          label: FoodStrings.servingSizeLabel,
          value: food.servingSize,
        ),
        _NutritionRow(label: FoodStrings.caloriesLabel, value: food.calories),
        _NutritionRow(
          label: FoodStrings.proteinLabel,
          value: food.proteinGrams,
        ),
        _NutritionRow(label: FoodStrings.carbsLabel, value: food.carbsGrams),
        _NutritionRow(label: FoodStrings.fatLabel, value: food.fatGrams),
        _NutritionRow(label: FoodStrings.fiberLabel, value: food.fiberGrams),
        const SizedBox(height: 16),
        FoodMacroBreakdown(food: food),
      ],
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.label, required this.value});

  final String label;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value == null ? '-' : value!.toStringAsFixed(1)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text(FoodStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
