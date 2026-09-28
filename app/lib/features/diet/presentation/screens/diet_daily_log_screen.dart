import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/diet_adherence.dart';
import '../cubit/diet_daily_log_cubit.dart';
import '../diet_strings.dart';

class DietDailyLogScreen extends StatelessWidget {
  const DietDailyLogScreen({super.key, this.memberId});

  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DietDailyLogCubit>()
        ..init(memberId ?? ''),
      child: _DietDailyLogBody(memberId: memberId),
    );
  }
}

class _DietDailyLogBody extends StatefulWidget {
  const _DietDailyLogBody({this.memberId});

  final String? memberId;

  @override
  State<_DietDailyLogBody> createState() => _DietDailyLogBodyState();
}

class _DietDailyLogBodyState extends State<_DietDailyLogBody> {
  late final TextEditingController _caloriesController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _caloriesController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _syncControllers(DietDailyLogState state) {
    final calStr = state.caloriesConsumed?.toStringAsFixed(0) ?? '';
    if (_caloriesController.text != calStr) {
      _caloriesController.text = calStr;
    }
    if (_notesController.text != state.memberNotes) {
      _notesController.text = state.memberNotes;
    }
  }

  Future<void> _pickDate(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && mounted) {
      context.read<DietDailyLogCubit>().updateDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DietDailyLogCubit, DietDailyLogState>(
      listener: (context, state) {
        if (state.status == DietDailyLogStatus.ready) {
          _syncControllers(state);
        } else if (state.status == DietDailyLogStatus.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(DietStrings.logSaved)),
          );
        } else if (state.status == DietDailyLogStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final cubit = context.read<DietDailyLogCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(DietStrings.dailyLogTitle),
          ),
          body: state.status == DietDailyLogStatus.loading
              ? const AppLoading()
              : state.status == DietDailyLogStatus.failure && state.caloriesConsumed == null
                  ? AppErrorView(
                      message: state.errorMessage ?? DietStrings.saveFailed,
                      onRetry: () => cubit.init(widget.memberId ?? ''),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Date picker row
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    DateFormat.yMMMMEEEEd().format(state.date),
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () =>
                                      _pickDate(state.date),
                                  child: const Text('Change'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Calories and Adherence Section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.local_fire_department,
                                        color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text(
                                      DietStrings.caloriesLabel,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const Spacer(),
                                    if (state.targetCalories != null)
                                      Text(
                                        'Target: ${state.targetCalories!.toStringAsFixed(0)} kcal',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _caloriesController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: DietStrings.caloriesConsumedLabel,
                                    border: OutlineInputBorder(),
                                    suffixText: 'kcal',
                                  ),
                                  onChanged: (val) {
                                    final cal = num.tryParse(val.trim());
                                    if (cal != null) {
                                      cubit.updateCalories(cal);
                                    }
                                  },
                                ),
                                if (state.adherenceScore != null) ...[
                                  const SizedBox(height: 12),
                                  _AdherenceBadge(
                                    score: state.adherenceScore!,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Water intake section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.water_drop,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      DietStrings.waterIntakeLabel,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      DietStrings.waterMl(state.waterIntakeMl),
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (state.waterIntakeMl / 2500).clamp(0.0, 1.0),
                                    minHeight: 8,
                                    backgroundColor: Colors.blue.withValues(alpha: 0.15),
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DietStrings.waterGoalLabel,
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        icon: const Icon(Icons.add, size: 16),
                                        label: const Text(DietStrings.addWater250),
                                        onPressed: () => cubit.addWater(250),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        icon: const Icon(Icons.add, size: 16),
                                        label: const Text(DietStrings.addWater500),
                                        onPressed: () => cubit.addWater(500),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      tooltip: DietStrings.resetWater,
                                      icon: const Icon(Icons.refresh, size: 20),
                                      onPressed: () => cubit.updateWater(0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Member Notes section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DietStrings.memberNotesLabel,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _notesController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: DietStrings.memberNotesHint,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: cubit.updateNotes,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        FilledButton.icon(
                          icon: state.status == DietDailyLogStatus.saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check),
                          label: const Text(DietStrings.saveLog),
                          onPressed: state.status == DietDailyLogStatus.saving
                              ? null
                              : () => cubit.save(),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}

class _AdherenceBadge extends StatelessWidget {
  const _AdherenceBadge({required this.score});

  final num score;

  @override
  Widget build(BuildContext context) {
    final rating = DietAdherenceRating.fromScore(score);
    final (color, label) = switch (rating) {
      DietAdherenceRating.onTarget => (Colors.green, DietStrings.complianceOnTarget),
      DietAdherenceRating.moderate => (Colors.orange, DietStrings.complianceModerate),
      DietAdherenceRating.offTarget => (Colors.red, DietStrings.complianceOffTarget),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insights, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            '${DietStrings.adherencePercent(score)} · $label',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
