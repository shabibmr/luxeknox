import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/goal_metric.dart';
import '../../domain/entities/measurement.dart';
import '../cubit/measurements_cubit.dart';
import '../goals_strings.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({
    super.key,
    this.memberId,
    this.focusMetricId,
    this.returnToCaller = false,
  });

  final String? memberId;
  final String? focusMetricId;
  final bool returnToCaller;

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _LatestMetricCardData {
  const _LatestMetricCardData({
    required this.metric,
    required this.latestValue,
  });

  final GoalMetric metric;
  final num? latestValue;
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  static const _targetMetricNames = [
    'Weight',
    'Body Fat %',
    'Chest',
    'Waist',
    'Biceps',
    'Thighs',
  ];

  var _sheetOpen = false;
  var _openedFocusSheet = false;

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

  void _navigateToHistory(BuildContext context) {
    String? currentPath;
    try {
      currentPath = GoRouterState.of(context).uri.path;
    } catch (_) {}

    if (currentPath != null && currentPath.endsWith('/measurements')) {
      context.push('$currentPath/history');
      return;
    }

    final id = widget.memberId ?? _resolveMemberId();
    if (currentPath != null && currentPath.contains('/trainer/') && id != null) {
      context.push('/trainer/members/$id/goals/measurements/history');
      return;
    }
    if (currentPath != null && currentPath.contains('/admin/') && id != null) {
      context.push('/admin/members/$id/goals/measurements/history');
      return;
    }

    context.push('/progress/measurements/history');
  }

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

  List<_LatestMetricCardData> _resolveLatestMetricCards(
    MeasurementsState state,
  ) {
    final cards = <_LatestMetricCardData>[];
    for (final target in _targetMetricNames) {
      final targetLower = target.trim().toLowerCase();
      GoalMetric? matchedMetric;
      for (final m in state.metrics) {
        if (m.name.trim().toLowerCase() == targetLower) {
          matchedMetric = m;
          break;
        }
      }
      if (matchedMetric == null) continue;

      final metric = matchedMetric;
      final matchingSessions = state.sessions
          .where((s) => s.values.any((v) => v.metricId == metric.id))
          .toList()
        ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

      final num? latestValue = matchingSessions.isNotEmpty
          ? matchingSessions.first.values
              .firstWhere((v) => v.metricId == metric.id)
              .value
          : null;

      cards.add(
        _LatestMetricCardData(
          metric: metric,
          latestValue: latestValue,
        ),
      );
    }
    return cards;
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
                              '${state.mandatoryMetricIds.contains(m.id) ? ' *' : ''}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(GoalsStrings.measurementsTitle),
        actions: [
          TextButton(
            onPressed: () => _navigateToHistory(context),
            child: const Text(GoalsStrings.historyLink),
          ),
        ],
      ),
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

          if (widget.focusMetricId != null &&
              state.metrics.isNotEmpty &&
              !_openedFocusSheet) {
            _openedFocusSheet = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _openCreate(context, state);
            });
          }

          final cards = _resolveLatestMetricCards(state);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    GoalsStrings.latestMeasurementsTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () => _navigateToHistory(context),
                    child: const Text(GoalsStrings.viewHistory),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (cards.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(GoalsStrings.measurementsEmpty),
                  ),
                )
              else
                for (final card in cards)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        '${card.metric.name} (${card.metric.unitOfMeasure})',
                      ),
                      trailing: Text(
                        card.latestValue != null ? '${card.latestValue}' : '—',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text(GoalsStrings.viewHistory),
                onPressed: () => _navigateToHistory(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
