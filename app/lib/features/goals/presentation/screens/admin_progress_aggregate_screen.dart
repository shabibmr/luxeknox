import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/admin_progress_aggregate_cubit.dart';
import '../goals_strings.dart';

/// Gym-wide progress aggregate counts (admin More → Progress).
/// Cubit is provided on the GoRoute (ADR-0006 §8).
class AdminProgressAggregateScreen extends StatelessWidget {
  const AdminProgressAggregateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.adminProgressTitle)),
      body: BlocBuilder<AdminProgressAggregateCubit, AdminProgressAggregateState>(
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.counts != null;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<AdminProgressAggregateCubit>().load(),
            );
          }
          final counts = state.counts;
          if (counts == null) {
            return const AppLoading();
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _CountTile(
                label: GoalsStrings.adminProgressActiveGoals,
                value: counts.activeGoals,
              ),
              _CountTile(
                label: GoalsStrings.adminProgressAchievedGoals,
                value: counts.achievedGoals,
              ),
              _CountTile(
                label: GoalsStrings.adminProgressMembersMeasured,
                value: counts.membersMeasured30d,
              ),
              _CountTile(
                label: GoalsStrings.adminProgressPhotos,
                value: counts.photos30d,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          '$value',
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
