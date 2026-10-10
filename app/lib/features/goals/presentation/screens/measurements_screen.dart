import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_chart_types.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_line_chart.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/measurement.dart';
import '../cubit/measurements_cubit.dart';
import '../goals_strings.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({
    super.key,
    this.memberId,
    this.mandatoryMetricIds = const [],
    this.focusMetricId,
    this.returnToCaller = false,
  });

  final String? memberId;
  final List<String> mandatoryMetricIds;
  final String? focusMetricId;
  final bool returnToCaller;

  String? _resolveMemberId() {
    if (memberId != null) return memberId;
    final session = getIt<SessionCubit>().state;
    if (session is SessionAuthenticated) {
      return session.principal.profileId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final id = _resolveMemberId();
    if (id == null || id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(GoalsStrings.measurementsTitle)),
        body: const AppEmptyView(message: GoalsStrings.measurementsEmpty),
      );
    }

    return BlocProvider(
      create: (_) =>
          getIt<MeasurementsCubit>()
            ..load(id, mandatoryMetricIds: mandatoryMetricIds),
      child: _MeasurementsBody(
        memberId: id,
        mandatoryMetricIds: mandatoryMetricIds,
        focusMetricId: focusMetricId,
        returnToCaller: returnToCaller,
      ),
    );
  }
}

class _MeasurementsBody extends StatefulWidget {
  const _MeasurementsBody({
    required this.memberId,
    required this.mandatoryMetricIds,
    this.focusMetricId,
    this.returnToCaller = false,
  });

  final String memberId;
  final List<String> mandatoryMetricIds;
  final String? focusMetricId;
  final bool returnToCaller;

  @override
  State<_MeasurementsBody> createState() => _MeasurementsBodyState();
}

class _MeasurementsBodyState extends State<_MeasurementsBody> {
  var _sheetOpen = false;
  var _openedFocusSheet = false;

  List<GoalMetric> _orderedMetrics(List<GoalMetric> metrics) {
    final focus = widget.focusMetricId;
    if (focus == null) return metrics;
    final index = metrics.indexWhere((metric) => metric.id == focus);
    if (index <= 0) return metrics;
    final ordered = [...metrics];
    final focused = ordered.removeAt(index);
    ordered.insert(0, focused);
    return ordered;
  }

  Future<void> _openCreate(
    BuildContext context,
    MeasurementsState state,
  ) async {
    final metrics = _orderedMetrics(state.metrics);
    final controllers = <String, TextEditingController>{
      for (final m in metrics) m.id: TextEditingController(),
    };
    final notesController = TextEditingController();
    final cubit = context.read<MeasurementsCubit>();
    setState(() => _sheetOpen = true);
    bool? saved;
    try {
      saved = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return BlocProvider.value(
            value: cubit,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.viewInsetsOf(ctx).bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      GoalsStrings.addMeasurement,
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    for (final m in metrics) ...[
                      TextField(
                        controller: controllers[m.id],
                        autofocus: m.id == widget.focusMetricId,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText:
                              '${m.name} (${m.unitOfMeasure})'
                              '${widget.mandatoryMetricIds.contains(m.id) ? ' *' : ''}',
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: GoalsStrings.measurementNotesLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<MeasurementsCubit, MeasurementsState>(
                      builder: (context, sheetState) {
                        final message = sheetState.failure == null
                            ? null
                            : failureMessage(sheetState.failure!);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (message != null) ...[
                              Text(
                                message,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            FilledButton(
                              onPressed: () async {
                                final values = <MeasurementValueEntry>[];
                                for (final m in metrics) {
                                  final raw = controllers[m.id]!.text.trim();
                                  if (raw.isEmpty) continue;
                                  final v = num.tryParse(raw);
                                  if (v == null) continue;
                                  values.add(
                                    MeasurementValueEntry(
                                      metricId: m.id,
                                      value: v,
                                    ),
                                  );
                                }
                                final ok = await cubit.create(
                                  notes: notesController.text.trim().isEmpty
                                      ? null
                                      : notesController.text.trim(),
                                  values: values,
                                );
                                if (!ctx.mounted || !ok) return;
                                Navigator.of(ctx).pop(true);
                              },
                              child: const Text(GoalsStrings.save),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _sheetOpen = false);
    }
    for (final c in controllers.values) {
      c.dispose();
    }
    notesController.dispose();
    if (saved == true && context.mounted) {
      if (widget.returnToCaller) {
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(GoalsStrings.measurementSaved)),
        );
      }
    }
  }

  AppLineSeries _chartSeries(
    MeasurementsState state,
    String metricId,
    String name,
  ) {
    final points = <MapEntry<DateTime, num>>[];
    for (final session in state.sessions) {
      for (final v in session.values) {
        if (v.metricId == metricId) {
          points.add(MapEntry(session.recordedAt, v.value));
        }
      }
    }
    points.sort((a, b) => a.key.compareTo(b.key));
    return AppLineSeries(
      name: name,
      points: [
        for (final p in points)
          Offset(p.key.millisecondsSinceEpoch.toDouble(), p.value.toDouble()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.measurementsTitle)),
      floatingActionButton: BlocBuilder<MeasurementsCubit, MeasurementsState>(
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success ||
              state.sessions.isNotEmpty ||
              state.metrics.isNotEmpty;
          if (!showData) return const SizedBox.shrink();
          return FloatingActionButton(
            tooltip: GoalsStrings.addMeasurement,
            onPressed: () => _openCreate(context, state),
            child: const Icon(Icons.add),
          );
        },
      ),
      body: BlocConsumer<MeasurementsCubit, MeasurementsState>(
        listener: (context, state) {
          if (_sheetOpen) return;
          final showData =
              state.status == LoadStatus.success ||
              state.sessions.isNotEmpty ||
              state.metrics.isNotEmpty;
          if (state.failure != null && showData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success ||
              state.sessions.isNotEmpty ||
              state.metrics.isNotEmpty;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<MeasurementsCubit>().load(
                widget.memberId,
                mandatoryMetricIds: widget.mandatoryMetricIds,
              ),
            );
          }
          final sessions = state.sessions;
          final metrics = state.metrics;
          if (widget.focusMetricId != null &&
              metrics.isNotEmpty &&
              !_openedFocusSheet) {
            _openedFocusSheet = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _openCreate(context, state);
            });
          }
          return sessions.isEmpty && metrics.isEmpty
              ? const AppEmptyView(message: GoalsStrings.measurementsEmpty)
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      GoalsStrings.chartsSection,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (final m in metrics.take(3)) ...[
                      Text('${m.name} (${m.unitOfMeasure})'),
                      AppLineChart(
                        series: [_chartSeries(state, m.id, m.name)],
                        height: 160,
                        emptyMessage: GoalsStrings.chartsEmpty,
                        xLabelFormatter: (x) => DateFormat('MMM d').format(
                          DateTime.fromMillisecondsSinceEpoch(x.round()),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const Divider(),
                    Text(
                      GoalsStrings.measurementsTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (sessions.isEmpty)
                      const Text(GoalsStrings.measurementsEmpty)
                    else
                      for (final s in sessions)
                        Card(
                          child: ListTile(
                            title: Text(s.recordedAt.toIso8601String()),
                            subtitle: Text(
                              [
                                if (s.notes != null && s.notes!.isNotEmpty)
                                  s.notes!,
                                for (final v in s.values)
                                  '${v.metricId}: ${v.value}',
                              ].join(' · '),
                            ),
                          ),
                        ),
                  ],
                );
        },
      ),
    );
  }
}
