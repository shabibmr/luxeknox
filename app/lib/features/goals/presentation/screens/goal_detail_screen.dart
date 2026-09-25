import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/goal_detail_cubit.dart';
import '../goals_strings.dart';
import '../widgets/goal_progress_bar.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key, required this.goalId});

  final String goalId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GoalDetailCubit>()..load(goalId),
      child: _GoalDetailBody(goalId: goalId),
    );
  }
}

class _GoalDetailBody extends StatefulWidget {
  const _GoalDetailBody({required this.goalId});

  final String goalId;

  @override
  State<_GoalDetailBody> createState() => _GoalDetailBodyState();
}

class _GoalDetailBodyState extends State<_GoalDetailBody> {
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final raw = _valueController.text.trim();
    final value = num.tryParse(raw);
    if (value == null) return;
    final ok = await context.read<GoalDetailCubit>().submitCheckIn(
      recordedValue: value,
      recordedDate: _date,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    if (ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(GoalsStrings.checkInSaved)));
      _valueController.clear();
      _notesController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.goalDetailTitle)),
      body: BlocConsumer<GoalDetailCubit, GoalDetailState>(
        listener: (context, state) {
          if (state.goal != null && state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          final goal = state.goal;
          final submitting = state.submitting;
          if (state.status == LoadStatus.loading && goal == null) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && goal == null) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<GoalDetailCubit>().load(widget.goalId),
            );
          }
          if (goal == null) return const SizedBox.shrink();
          return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GoalProgressBar(goal: goal),
                  const SizedBox(height: 24),
                  Text(
                    GoalsStrings.checkInTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: GoalsStrings.checkInValueLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(GoalsStrings.checkInDateLabel),
                    subtitle: Text(
                      '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    ),
                  ),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: GoalsStrings.checkInNotesLabel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: submitting ? null : _submit,
                    child: submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(GoalsStrings.checkInSubmit),
                  ),
                ],
              );
        },
      ),
    );
  }
}
