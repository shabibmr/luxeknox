import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/measurement.dart';
import '../cubit/measurements_cubit.dart';
import '../goals_strings.dart';
import '../widgets/metric_chart.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({
    super.key,
    this.memberId,
    this.mandatoryMetricIds = const [],
  });

  final String? memberId;
  final List<String> mandatoryMetricIds;

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
      create: (_) => getIt<MeasurementsCubit>()
        ..load(id, mandatoryMetricIds: mandatoryMetricIds),
      child: _MeasurementsBody(
        memberId: id,
        mandatoryMetricIds: mandatoryMetricIds,
      ),
    );
  }
}

class _MeasurementsBody extends StatelessWidget {
  const _MeasurementsBody({
    required this.memberId,
    required this.mandatoryMetricIds,
  });

  final String memberId;
  final List<String> mandatoryMetricIds;

  Future<void> _openCreate(BuildContext context, MeasurementsLoaded state) async {
    final controllers = <String, TextEditingController>{
      for (final m in state.metrics) m.id: TextEditingController(),
    };
    final notesController = TextEditingController();
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
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
                for (final m in state.metrics) ...[
                  TextField(
                    controller: controllers[m.id],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText:
                          '${m.name} (${m.unitOfMeasure})'
                          '${mandatoryMetricIds.contains(m.id) ? ' *' : ''}',
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
                FilledButton(
                  onPressed: () async {
                    final values = <MeasurementValueEntry>[];
                    for (final m in state.metrics) {
                      final raw = controllers[m.id]!.text.trim();
                      if (raw.isEmpty) continue;
                      final v = num.tryParse(raw);
                      if (v == null) continue;
                      values.add(
                        MeasurementValueEntry(metricId: m.id, value: v),
                      );
                    }
                    final ok = await context.read<MeasurementsCubit>().create(
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                      values: values,
                    );
                    if (ctx.mounted) Navigator.of(ctx).pop(ok);
                  },
                  child: const Text(GoalsStrings.save),
                ),
              ],
            ),
          ),
        );
      },
    );
    for (final c in controllers.values) {
      c.dispose();
    }
    notesController.dispose();
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(GoalsStrings.measurementSaved)),
      );
    }
  }

  List<MetricChartPoint> _chartPoints(
    MeasurementsLoaded state,
    String metricId,
  ) {
    final points = <MetricChartPoint>[];
    for (final session in state.sessions) {
      for (final v in session.values) {
        if (v.metricId == metricId) {
          points.add(MetricChartPoint(at: session.recordedAt, value: v.value));
        }
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.measurementsTitle)),
      floatingActionButton: BlocBuilder<MeasurementsCubit, MeasurementsState>(
        builder: (context, state) {
          if (state is! MeasurementsLoaded) return const SizedBox.shrink();
          return FloatingActionButton(
            tooltip: GoalsStrings.addMeasurement,
            onPressed: () => _openCreate(context, state),
            child: const Icon(Icons.add),
          );
        },
      ),
      body: BlocConsumer<MeasurementsCubit, MeasurementsState>(
        listener: (context, state) {
          if (state is MeasurementsLoaded && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            MeasurementsLoading() => const AppLoading(),
            MeasurementsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<MeasurementsCubit>().load(
                memberId,
                mandatoryMetricIds: mandatoryMetricIds,
              ),
            ),
            MeasurementsLoaded(
              :final sessions,
              :final metrics,
            ) =>
              sessions.isEmpty && metrics.isEmpty
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
                          MetricChart(points: _chartPoints(state, m.id)),
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
                                title: Text(
                                  s.recordedAt.toIso8601String(),
                                ),
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
                    ),
          };
        },
      ),
    );
  }
}
