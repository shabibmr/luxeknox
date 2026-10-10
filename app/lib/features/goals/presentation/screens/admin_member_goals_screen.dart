import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/admin_member_goals_cubit.dart';
import '../goals_strings.dart';

/// Gym-wide goals monitor (admin More → Member Goals).
/// Cubit is provided on the GoRoute (ADR-0006 §8).
class AdminMemberGoalsScreen extends StatelessWidget {
  const AdminMemberGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.adminMemberGoalsTitle)),
      body: BlocBuilder<AdminMemberGoalsCubit, AdminMemberGoalsState>(
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.items.isNotEmpty;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<AdminMemberGoalsCubit>().load(
                status: 'in_progress',
              ),
            );
          }
          if (state.items.isEmpty) {
            return const AppEmptyView(
              message: GoalsStrings.adminMemberGoalsEmpty,
            );
          }
          return ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final goal = state.items[index];
              final metricName = goal.metric?.name ?? goal.metricId;
              return ListTile(
                title: Text(metricName),
                subtitle: Text(
                  'Member #${goal.memberId} · '
                  '${GoalsStrings.statusLabelFor(goal.status)}',
                ),
                trailing: goal.currentValue != null
                    ? Text('${goal.currentValue}')
                    : null,
                onTap: () => context.push(
                  Routes.adminMemberGoalById(goal.memberId, goal.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
