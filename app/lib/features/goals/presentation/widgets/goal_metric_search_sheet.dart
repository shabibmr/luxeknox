import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_picker_cubit.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_metric_category.dart';
import '../../domain/usecases/goal_metrics_usecases.dart';
import '../goals_strings.dart';

/// Searchable metric picker. [category] filters by metric type.
Future<GoalMetric?> showGoalMetricSearchSheet(BuildContext context) {
  return showModalBottomSheet<GoalMetric>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const GoalMetricSearchSheet(),
  );
}

class GoalMetricSearchSheet extends StatefulWidget {
  const GoalMetricSearchSheet({super.key});

  @override
  State<GoalMetricSearchSheet> createState() => _GoalMetricSearchSheetState();
}

class _GoalMetricSearchSheetState extends State<GoalMetricSearchSheet> {
  late final AppPickerCubit<GoalMetric> _cubit;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  GoalMetricCategory? _category;

  @override
  void initState() {
    super.initState();
    final listMetrics = getIt<ListGoalMetricsUseCase>();
    _cubit = AppPickerCubit<GoalMetric>(
      fetcher: ({query, cursor}) {
        final typed = _searchController.text.trim();
        final text = typed.isNotEmpty ? typed : (query?.trim() ?? '');
        return listMetrics(
          ListGoalMetricsParams(
            query: text.isEmpty ? null : text,
            category: _category,
            isActive: true,
            cursor: cursor,
            limit: 50,
          ),
        );
      },
    );
    _scrollController.addListener(_onScroll);
    _cubit.load();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _cubit.loadMore();
    }
  }

  void _setCategory(GoalMetricCategory? category) {
    setState(() => _category = category);
    final text = _searchController.text.trim();
    _cubit.load(query: text.isEmpty ? null : text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPickerCubit<GoalMetric>, AppPickerState<GoalMetric>>(
      bloc: _cubit,
      builder: (context, state) {
        return AppPickerSheet<GoalMetric>(
          searchController: _searchController,
          searchLabel: GoalsStrings.searchMetrics,
          onSearchChanged: _cubit.onSearchChanged,
          onSearchSubmitted: (query) => _cubit.load(
            query: query.trim().isEmpty ? null : query.trim(),
          ),
          isLoading: state.status == LoadStatus.loading && state.items.isEmpty,
          isLoadingMore: state.isLoadingMore,
          items: state.items,
          emptyMessage: GoalsStrings.noMetricsFound,
          retryLabel: GoalsStrings.retry,
          heightFactor: 0.75,
          scrollController: _scrollController,
          errorMessage: state.failure != null && state.items.isEmpty
              ? failureMessage(state.failure!)
              : null,
          onRetry: () {
            final text = _searchController.text.trim();
            _cubit.load(query: text.isEmpty ? null : text);
          },
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GoalsStrings.metricTypeLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text(GoalsStrings.allMetricTypes),
                    selected: _category == null,
                    onSelected: (_) => _setCategory(null),
                  ),
                  for (final category in GoalMetricCategory.values)
                    FilterChip(
                      label: Text(GoalsStrings.categoryLabelFor(category)),
                      selected: _category == category,
                      onSelected: (_) => _setCategory(category),
                    ),
                ],
              ),
            ],
          ),
          itemBuilder: (context, metric) => ListTile(
            title: Text(metric.name),
            subtitle: Text(
              '${metric.unitOfMeasure} · ${GoalsStrings.categoryLabelFor(metric.category)}',
            ),
            onTap: () => Navigator.of(context).pop(metric),
          ),
        );
      },
    );
  }
}

/// Form field that opens [GoalMetricSearchSheet] instead of a plain dropdown.
class GoalMetricSearchField extends StatelessWidget {
  const GoalMetricSearchField({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.errorText,
  });

  final GoalMetric? value;
  final ValueChanged<GoalMetric?>? onChanged;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<GoalMetric>(
      value: value,
      enabled: enabled,
      errorText: errorText,
      labelText: GoalsStrings.metricLabel,
      hintText: GoalsStrings.selectMetricHint,
      labelBuilder: (metric) => '${metric.name} (${metric.unitOfMeasure})',
      onPick: showGoalMetricSearchSheet,
      onChanged: onChanged ?? (_) {},
    );
  }
}
