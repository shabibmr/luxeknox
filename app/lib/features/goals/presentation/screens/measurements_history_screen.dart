import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class MeasurementsHistoryScreen extends StatefulWidget {
  const MeasurementsHistoryScreen({
    super.key,
    this.memberId,
  });

  final String? memberId;

  @override
  State<MeasurementsHistoryScreen> createState() =>
      _MeasurementsHistoryScreenState();
}

class _MeasurementsHistoryScreenState extends State<MeasurementsHistoryScreen> {
  String? _resolveMemberId() {
    if (widget.memberId != null && widget.memberId!.isNotEmpty) {
      return widget.memberId;
    }
    if (getIt.isRegistered<SessionCubit>()) {
      final session = getIt<SessionCubit>().state;
      if (session is SessionAuthenticated) {
        return session.principal.profileId;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<MeasurementsCubit>();
      if (cubit.state.status == LoadStatus.initial) {
        final id = _resolveMemberId();
        if (id != null && id.isNotEmpty) {
          cubit.load(id);
        }
      }
    });
  }

  Widget _metricChart(MeasurementsState state, GoalMetric metric) {
    final points = <MapEntry<DateTime, num>>[];
    for (final session in state.sessions) {
      for (final v in session.values) {
        if (v.metricId == metric.id) {
          points.add(MapEntry(session.recordedAt, v.value));
        }
      }
    }
    points.sort((a, b) => a.key.compareTo(b.key));
    final origin = points.isEmpty ? null : points.first.key;
    return AppLineChart(
      series: [
        AppLineSeries(
          name: metric.name,
          points: [
            for (final p in points)
              Offset(
                p.key.difference(origin!).inMicroseconds /
                    Duration.microsecondsPerDay,
                p.value.toDouble(),
              ),
          ],
        ),
      ],
      height: 160,
      emptyMessage: GoalsStrings.chartsEmpty,
      xLabelFormatter: origin == null
          ? null
          : (x) => DateFormat('MMM d').format(
              origin.add(
                Duration(
                  microseconds: (x * Duration.microsecondsPerDay).round(),
                ),
              ),
            ),
    );
  }

  Widget? _buildSessionSubtitle(
    MeasurementSession session,
    Map<String, GoalMetric> metricMap,
  ) {
    final valuesText = session.values.map((v) {
      final m = metricMap[v.metricId];
      if (m != null) {
        return '${m.name}: ${v.value} ${m.unitOfMeasure}'.trim();
      }
      return '${v.metricId}: ${v.value}';
    }).join(' · ');

    final hasNotes = session.notes != null && session.notes!.trim().isNotEmpty;
    final hasValues = valuesText.isNotEmpty;

    if (!hasNotes && !hasValues) return null;

    if (hasNotes && !hasValues) {
      return Text(session.notes!.trim());
    }

    if (!hasNotes && hasValues) {
      return Text(valuesText);
    }

    return Text('${session.notes!.trim()} · $valuesText');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.historyTitle)),
      body: BlocConsumer<MeasurementsCubit, MeasurementsState>(
        listener: (context, state) {
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
              message: state.failure != null
                  ? failureMessage(state.failure!)
                  : '',
              onRetry: () {
                final id = _resolveMemberId();
                if (id != null && id.isNotEmpty) {
                  context.read<MeasurementsCubit>().load(id);
                }
              },
            );
          }

          if (state.sessions.isEmpty && state.metrics.isEmpty) {
            return const AppEmptyView(
              message: GoalsStrings.measurementsEmpty,
            );
          }

          final metricMap = {for (final m in state.metrics) m.id: m};

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Trend curves section (A2.2)
              if (state.metrics.isNotEmpty) ...[
                Text(
                  GoalsStrings.chartsSection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final m in state.metrics) ...[
                  Text('${m.name} (${m.unitOfMeasure})'),
                  const SizedBox(height: 4),
                  _metricChart(state, m),
                  const SizedBox(height: 16),
                ],
                const Divider(),
                const SizedBox(height: 8),
              ],

              // Sessions section (A2.3)
              Text(
                GoalsStrings.measurementsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (state.sessions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(GoalsStrings.measurementsEmpty),
                )
              else
                for (final session in state.sessions)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        GoalsStrings.calendarDate(session.recordedAt.toLocal()),
                      ),
                      subtitle: _buildSessionSubtitle(session, metricMap),
                    ),
                  ),

              // Paging section (A2.4)
              if (state.hasMore) ...[
                const SizedBox(height: 16),
                if (state.loadingMore)
                  const Center(child: AppLoading())
                else
                  Center(
                    child: OutlinedButton(
                      onPressed: () =>
                          context.read<MeasurementsCubit>().loadMore(),
                      child: const Text(GoalsStrings.loadMore),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
