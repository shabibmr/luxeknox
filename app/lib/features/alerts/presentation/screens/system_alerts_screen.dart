import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../alerts_strings.dart';
import '../cubit/system_alerts_cubit.dart';

/// Admin-facing system alerts feed, backed by the append-only audit log.
class SystemAlertsScreen extends StatelessWidget {
  const SystemAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SystemAlertsCubit>()..load(),
      child: const _SystemAlertsBody(),
    );
  }
}

class _SystemAlertsBody extends StatelessWidget {
  const _SystemAlertsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AlertsStrings.title)),
      body: BlocConsumer<SystemAlertsCubit, SystemAlertsState>(
        listenWhen: (previous, next) =>
            next.status == LoadStatus.failure &&
            next.failure != previous.failure &&
            next.items.isNotEmpty,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure == null
                  ? ''
                  : failureMessage(state.failure!),
              onRetry: () => context.read<SystemAlertsCubit>().load(),
            );
          }
          final items = state.items;
          final hasMore = state.hasMore;
          final loadingMore = state.loadingMore;
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<SystemAlertsCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  AppEmptyView(message: AlertsStrings.empty),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<SystemAlertsCubit>().load(),
            child: ListView.separated(
              itemCount: items.length + (hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: loadingMore
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () => context
                                  .read<SystemAlertsCubit>()
                                  .loadMore(),
                              child: const Text(AlertsStrings.loadMore),
                            ),
                    ),
                  );
                }
                final alert = items[index];
                return ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: Text(alert.summary),
                  subtitle: Text(
                    'Actor #${alert.actorUserId} · '
                    '${alert.timestamp.toLocal()}',
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
