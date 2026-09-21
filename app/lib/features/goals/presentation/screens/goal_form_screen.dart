import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/goal_status.dart';
import '../cubit/goal_form_cubit.dart';
import '../goals_strings.dart';

class GoalFormScreen extends StatelessWidget {
  const GoalFormScreen({super.key, required this.memberId, this.goalId});

  final String memberId;
  final String? goalId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<GoalFormCubit>()..init(memberId: memberId, goalId: goalId),
      child: _GoalFormBody(isEdit: goalId != null),
    );
  }
}

class _GoalFormBody extends StatefulWidget {
  const _GoalFormBody({required this.isEdit});

  final bool isEdit;

  @override
  State<_GoalFormBody> createState() => _GoalFormBodyState();
}

class _GoalFormBodyState extends State<_GoalFormBody> {
  String? _metricId;
  final _baselineController = TextEditingController();
  final _targetController = TextEditingController();
  DateTime? _startDate;
  DateTime? _targetDate;
  GoalStatus _status = GoalStatus.inProgress;
  var _seeded = false;

  @override
  void dispose() {
    _baselineController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _seedFrom(GoalFormReady state) {
    if (_seeded || state.existing == null) return;
    final g = state.existing!;
    _metricId = g.metricId;
    if (g.baselineValue != null) {
      _baselineController.text = '${g.baselineValue}';
    }
    if (g.targetValue != null) {
      _targetController.text = '${g.targetValue}';
    }
    _startDate = g.startDate;
    _targetDate = g.targetDate;
    _status = g.status;
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
      body: BlocConsumer<GoalFormCubit, GoalFormState>(
        listener: (context, state) {
          if (state is GoalFormSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(GoalsStrings.goalSaved)),
            );
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          return switch (state) {
            GoalFormLoading() => const AppLoading(),
            GoalFormFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => Navigator.of(context).maybePop(),
            ),
            GoalFormSaved() => const AppLoading(),
            final GoalFormReady ready => _buildReadyForm(context, ready),
          };
        },
      ),
    );
  }

  Widget _buildReadyForm(BuildContext context, GoalFormReady ready) {
    if (!_seeded && ready.existing != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _seeded) return;
        setState(() => _seedFrom(ready));
      });
    }
    final metrics = ready.metrics;
    final submitting = ready.submitting;
    final error = ready.error;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: _metricId,
          decoration: const InputDecoration(
            labelText: GoalsStrings.metricLabel,
          ),
          items: [
            for (final m in metrics)
              DropdownMenuItem(
                value: m.id,
                child: Text('${m.name} (${m.unitOfMeasure})'),
              ),
          ],
          onChanged: submitting ? null : (v) => setState(() => _metricId = v),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _baselineController,
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
          subtitle: Text(
            _startDate == null
                ? '—'
                : _startDate!.toIso8601String().split('T').first,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _pickDate(start: true),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(GoalsStrings.targetDateLabel),
          subtitle: Text(
            _targetDate == null
                ? '—'
                : _targetDate!.toIso8601String().split('T').first,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _pickDate(start: false),
          ),
        ),
        DropdownButtonFormField<GoalStatus>(
          // ignore: deprecated_member_use
          value: _status,
          decoration: const InputDecoration(
            labelText: GoalsStrings.statusLabel,
          ),
          items: [
            for (final s in GoalStatus.values)
              DropdownMenuItem(
                value: s,
                child: Text(GoalsStrings.statusLabelFor(s)),
              ),
          ],
          onChanged: submitting
              ? null
              : (v) {
                  if (v != null) setState(() => _status = v);
                },
        ),
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
