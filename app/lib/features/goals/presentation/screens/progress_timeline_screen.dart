import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/progress_timeline_cubit.dart';
import '../goals_strings.dart';

class ProgressTimelineScreen extends StatelessWidget {
  const ProgressTimelineScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd().add_jm();
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.timelineTitle)),
      body: BlocBuilder<ProgressTimelineCubit, ProgressTimelineState>(
        builder: (context, state) {
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () => context.read<ProgressTimelineCubit>().retry(),
            );
          }
          if (state.items.isEmpty) {
            return const AppEmptyView(
              message: GoalsStrings.timelineEmpty,
              icon: Icons.timeline,
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ProgressTimelineCubit>().retry(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = state.items[index];
                final kindLabel = switch (item.kind) {
                  ProgressTimelineKind.goalCheckIn =>
                    GoalsStrings.timelineGoalCheckIn,
                  ProgressTimelineKind.measurementSession =>
                    GoalsStrings.timelineMeasurement,
                };
                return Card(
                  child: ListTile(
                    leading: Icon(
                      item.kind == ProgressTimelineKind.goalCheckIn
                          ? Icons.flag_outlined
                          : Icons.monitor_weight_outlined,
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      [
                        kindLabel,
                        dateFormat.format(item.at.toLocal()),
                        if (item.subtitle != null &&
                            item.subtitle!.trim().isNotEmpty)
                          item.subtitle!,
                      ].join(' · '),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
