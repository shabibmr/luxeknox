import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
          final items = state.items;
          if (state.status == LoadStatus.loading && !state.hasLoaded) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !state.hasLoaded) {
            return AppErrorView(
              message: state.failure == null
                  ? 'Something went wrong'
                  : failureMessage(state.failure!),
              onRetry: () => context.read<TodaysSessionsCubit>().load(),
            );
          }
          if (items.isEmpty) {
            return const AppEmptyView(
              message: SchedulingStrings.todaysSessionsEmpty,
            );
          }
          return RefreshIndicator(
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
          );
        },
      ),
    );
  }
}
