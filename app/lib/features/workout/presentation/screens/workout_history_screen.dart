import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/workout_session.dart';
import '../cubit/workout_history_cubit.dart';
import '../workout_history_role.dart';
import '../workout_strings.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({
    super.key,
    required this.role,
    this.memberId,
  });

  final WorkoutHistoryRole role;
  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WorkoutHistoryCubit>()..load(memberId: memberId),
      child: _WorkoutHistoryBody(role: role, memberId: memberId),
    );
  }
}

class _WorkoutHistoryBody extends StatelessWidget {
  const _WorkoutHistoryBody({required this.role, this.memberId});

  final WorkoutHistoryRole role;
  final String? memberId;

  String get _title => switch (role) {
    WorkoutHistoryRole.admin => WorkoutStrings.historyTitleAdmin,
    WorkoutHistoryRole.member => WorkoutStrings.historyTitleMember,
    WorkoutHistoryRole.trainer => WorkoutStrings.historyTitleTrainer,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: BlocBuilder<WorkoutHistoryCubit, WorkoutHistoryState>(
        builder: (context, state) {
          final items = state.items;
          if (state.status == LoadStatus.loading && !state.hasLoaded) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !state.hasLoaded) {
            return AppErrorView(
              message: state.failure == null
                  ? 'Something went wrong'
                  : failureMessage(state.failure!),
              onRetry: () => context
                  .read<WorkoutHistoryCubit>()
                  .load(memberId: memberId),
            );
          }
          if (items.isEmpty) {
            return const AppEmptyView(message: WorkoutStrings.historyEmpty);
          }
          final personalRecords = state.personalRecords;
          final totalVolumeKg = state.totalVolumeKg;
          final hasMore = state.hasMore;
          final loadingMore = state.loadingMore;
          return RefreshIndicator(
                      onRefresh: () => context
                          .read<WorkoutHistoryCubit>()
                          .load(memberId: memberId),
                      child: CustomScrollView(
                        slivers: [
                          if (personalRecords.isNotEmpty)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      WorkoutStrings.personalRecordsSection,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (final pr in personalRecords)
                                          Chip(
                                            label: Text(
                                              WorkoutStrings.personalRecordChip(
                                                exerciseId: pr.exerciseId,
                                                maxKg: pr.maxWeightKg,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (totalVolumeKg > 0) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        WorkoutStrings.historyTotalVolume(
                                          totalVolumeKg,
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= items.length) {
                                  if (!loadingMore) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          context
                                              .read<WorkoutHistoryCubit>()
                                              .loadMore();
                                        });
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: AppLoading(),
                                  );
                                }
                                return _SessionTile(session: items[index]);
                              },
                              childCount: items.length + (hasMore ? 1 : 0),
                            ),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_jm().format(session.startedAt.toLocal());
    final duration = session.durationMinutes;
    final volume = session.totalVolumeKg;
    final subtitleParts = <String>[];
    if (duration != null) {
      subtitleParts.add(WorkoutStrings.historyDuration(duration));
    }
    if (volume != null) {
      subtitleParts.add(WorkoutStrings.historyVolume(volume));
    }
    if (!session.isCompleted) {
      subtitleParts.add(WorkoutStrings.historyInProgress);
    }

    return ListTile(
      title: Text(date),
      subtitle: subtitleParts.isEmpty ? null : Text(subtitleParts.join(' · ')),
      leading: Icon(
        session.isCompleted
            ? Icons.fitness_center
            : Icons.hourglass_bottom_outlined,
      ),
    );
  }
}
