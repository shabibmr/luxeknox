import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../people/presentation/widgets/member_trainer_header.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/goal_status.dart';
import '../widgets/achievement_chip.dart';
import '../cubit/goal_form_cubit.dart';
import '../goals_strings.dart';
import '../widgets/goal_metric_search_sheet.dart';

class GoalFormScreen extends StatelessWidget {
  const GoalFormScreen({super.key, required this.memberId, this.goalId});

  final String memberId;
  final String? goalId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<GoalFormCubit>()..init(memberId: memberId, goalId: goalId),
      child: _GoalFormBody(isEdit: goalId != null, memberId: memberId),
    );
  }
}

class _GoalFormBody extends StatefulWidget {
  const _GoalFormBody({required this.isEdit, required this.memberId});

  final bool isEdit;
  final String memberId;

  @override
  State<_GoalFormBody> createState() => _GoalFormBodyState();
}

class _GoalFormBodyState extends State<_GoalFormBody> {
  String? _metricId;
  GoalMetric? _metric;
  final _baselineController = TextEditingController();
  final _targetController = TextEditingController();
  DateTime? _startDate;
  DateTime? _targetDate;
  GoalStatus _status = GoalStatus.inProgress;
  var _seeded = false;
  var _reopenHint = false;

  @override
  void dispose() {
    _baselineController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _seedFrom(GoalFormState state) {
    if (_seeded || state.existing == null) return;
    final g = state.existing!;
    _metricId = g.metricId;
    _metric = g.metric;
    if (_metric == null) {
      for (final metric in state.metrics) {
        if (metric.id == g.metricId) {
          _metric = metric;
          break;
        }
      }
    }
    if (g.baselineValue != null) {
      _baselineController.text = '${g.baselineValue}';
    }
    if (g.targetValue != null) {
      _targetController.text = '${g.targetValue}';
    }
    _startDate = g.startDate;
    _targetDate = g.targetDate;
    _status = g.status;
    _reopenHint = g.status == GoalStatus.abandoned;
    _seeded = true;
  }

  Future<void> _pickDate({required bool start}) async {
    final initial = (start ? _startDate : _targetDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _startDate = picked;
      } else {
        _targetDate = picked;
      }
    });
  }

  Future<void> _submit() async {
    final metricId = _metricId;
    if (metricId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(GoalsStrings.metricRequired)),
      );
      return;
    }
    await context.read<GoalFormCubit>().submit(
      metricId: metricId,
      baselineValue: num.tryParse(_baselineController.text.trim()),
      targetValue: num.tryParse(_targetController.text.trim()),
      startDate: _startDate,
      targetDate: _targetDate,
      status: _status,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? GoalsStrings.goalFormEditTitle
              : GoalsStrings.goalFormCreateTitle,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: MemberTrainerHeader(memberId: widget.memberId),
          ),
          Expanded(
            child: BlocConsumer<GoalFormCubit, GoalFormState>(
              listener: (context, state) {
                if (state.savedGoal != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(GoalsStrings.goalSaved)),
                  );
                  Navigator.of(context).pop(true);
                }
              },
              builder: (context, state) {
                final showForm =
                    state.status == LoadStatus.success ||
                    state.metrics.isNotEmpty ||
                    state.existing != null;
                if (state.status == LoadStatus.loading && !showForm) {
                  return const AppLoading();
                }
                if (state.status == LoadStatus.failure &&
                    !showForm &&
                    state.savedGoal == null) {
                  return AppErrorView(
                    message: failureMessage(state.failure!),
                    onRetry: () => Navigator.of(context).maybePop(),
                  );
                }
                if (state.savedGoal != null) return const AppLoading();
                return _buildReadyForm(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _statusControls(bool submitting) {
    if (!widget.isEdit) {
      return [
        DropdownButtonFormField<GoalStatus>(
          // ignore: deprecated_member_use
          value: _status,
          decoration: const InputDecoration(labelText: GoalsStrings.statusLabel),
          items: [
            for (final s in GoalStatus.values)
              DropdownMenuItem(
                value: s,
                child: Text(GoalsStrings.statusLabelFor(s)),
              ),
          ],
          onChanged: submitting
              ? null
              : (value) {
                  if (value != null) setState(() => _status = value);
                },
        ),
      ];
    }
    final choices = switch (_status) {
      GoalStatus.achieved => const <GoalStatus>[],
      GoalStatus.abandoned => const [
        GoalStatus.abandoned,
        GoalStatus.inProgress,
      ],
      GoalStatus.inProgress => const [
        GoalStatus.inProgress,
        GoalStatus.abandoned,
      ],
    };
    if (_status == GoalStatus.achieved) {
      return [
        const AchievementChip(status: GoalStatus.achieved),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: submitting
              ? null
              : () {
                  setState(() => _status = GoalStatus.abandoned);
                  _submit();
                },
          child: const Text(GoalsStrings.abandonGoal),
        ),
      ];
    }
    return [
      DropdownButtonFormField<GoalStatus>(
        // ignore: deprecated_member_use
        value: _status,
        decoration: const InputDecoration(labelText: GoalsStrings.statusLabel),
        items: [
          for (final status in choices)
            DropdownMenuItem(
              value: status,
              child: Text(GoalsStrings.statusLabelFor(status)),
            ),
        ],
        onChanged: submitting
            ? null
            : (value) {
                if (value != null) setState(() => _status = value);
              },
      ),
      if (_reopenHint) ...[
        const SizedBox(height: 8),
        Text(
          GoalsStrings.reopenMayAchieve,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ];
  }

  Widget _buildReadyForm(BuildContext context, GoalFormState ready) {
    if (!_seeded && ready.existing != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _seeded) return;
        setState(() => _seedFrom(ready));
      });
    }
    final submitting = ready.submitting;
    final error = ready.failure == null ? null : failureMessage(ready.failure!);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GoalMetricSearchField(
          value: _metric,
          enabled: !widget.isEdit && !submitting,
          onChanged: (metric) => setState(() {
            _metric = metric;
            _metricId = metric?.id;
          }),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _baselineController,
          readOnly: widget.isEdit,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: GoalsStrings.baselineLabel,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _targetController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: GoalsStrings.targetLabel,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(GoalsStrings.startDateLabel),
          subtitle: Text(GoalsStrings.calendarDate(_startDate)),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: widget.isEdit ? null : () => _pickDate(start: true),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(GoalsStrings.targetDateLabel),
          subtitle: Text(GoalsStrings.calendarDate(_targetDate)),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _pickDate(start: false),
          ),
        ),
        ..._statusControls(submitting),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: submitting ? null : _submit,
          child: submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(GoalsStrings.save),
        ),
      ],
    );
  }
}
