import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/todays_sessions_cubit.dart';
import '../scheduling_strings.dart';

/// Trainer drill-down of sessions scheduled for the current calendar day.
class TodaysSessionsScreen extends StatelessWidget {
  const TodaysSessionsScreen({super.key, this.trainerId});

  final String? trainerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TodaysSessionsCubit>()..load(trainerId: trainerId),
      child: const _TodaysSessionsBody(),
    );
  }
}

class _TodaysSessionsBody extends StatelessWidget {
  const _TodaysSessionsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(SchedulingStrings.todaysSessionsTitle)),
      body: BlocBuilder<TodaysSessionsCubit, TodaysSessionsState>(
        builder: (context, state) {
          return switch (state) {
            TodaysSessionsLoading() => const AppLoading(),
            TodaysSessionsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<TodaysSessionsCubit>().load(),
            ),
            TodaysSessionsLoaded(:final items) => items.isEmpty
                ? const AppEmptyView(
                    message: SchedulingStrings.todaysSessionsEmpty,
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<TodaysSessionsCubit>().load(),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final session = items[index];
                        return ListTile(
                          title: Text(session.title),
                          subtitle: Text(
                            '${session.startTime.toLocal()} · '
                            '${session.status.name}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go(
                            Routes.trainerScheduleById(session.id),
                          ),
                        );
                      },
                    ),
                  ),
          };
        },
      ),
    );
  }
}
