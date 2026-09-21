import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/schedule_history_cubit.dart';
import '../schedule_role.dart';
import '../scheduling_strings.dart';

/// Archive of past (completed / cancelled) sessions — used by both the
/// Member (`/schedule/history`) and Trainer (`/trainer/schedule/history`)
/// route branches, mirroring how [WorkoutHistoryScreen] is shared across
/// roles.
class ScheduleHistoryScreen extends StatelessWidget {
  const ScheduleHistoryScreen({
    super.key,
    required this.role,
    this.memberId,
    this.trainerId,
  });

  final ScheduleCalendarRole role;
  final String? memberId;
  final String? trainerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ScheduleHistoryCubit>()
            ..load(memberId: memberId, trainerId: trainerId),
      child: _ScheduleHistoryBody(role: role),
    );
  }
}

class _ScheduleHistoryBody extends StatelessWidget {
  const _ScheduleHistoryBody({required this.role});

  final ScheduleCalendarRole role;

  String _detailPath(String id) => switch (role) {
    ScheduleCalendarRole.member => Routes.memberScheduleById(id),
    ScheduleCalendarRole.trainer => Routes.trainerScheduleById(id),
    ScheduleCalendarRole.admin => '${Routes.adminSchedules}/$id',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(SchedulingStrings.historyTitle)),
      body: BlocBuilder<ScheduleHistoryCubit, ScheduleHistoryState>(
        builder: (context, state) {
          return switch (state) {
            ScheduleHistoryLoading() => const AppLoading(),
            ScheduleHistoryFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<ScheduleHistoryCubit>().load(),
            ),
            ScheduleHistoryLoaded(:final items, :final hasMore, :final loadingMore) =>
              items.isEmpty
                  ? const AppEmptyView(
                      message: SchedulingStrings.historyEmpty,
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<ScheduleHistoryCubit>().load(),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200) {
                            context.read<ScheduleHistoryCubit>().loadMore();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount:
                              items.length + (hasMore && loadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final session = items[index];
                            return ListTile(
                              title: Text(session.title),
                              subtitle: Text(
                                '${session.startTime.toLocal()} · '
                                '${session.status.name}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () =>
                                  context.go(_detailPath(session.id)),
                            );
                          },
                        ),
                      ),
                    ),
          };
        },
      ),
    );
  }
}
