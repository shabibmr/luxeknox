import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
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
      body: BlocBuilder<SystemAlertsCubit, SystemAlertsState>(
        builder: (context, state) {
          return switch (state) {
            SystemAlertsLoading() => const AppLoading(),
            SystemAlertsFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<SystemAlertsCubit>().load(),
            ),
            SystemAlertsLoaded(
              :final items,
              :final hasMore,
              :final loadingMore,
            ) =>
              items.isEmpty
                  ? RefreshIndicator(
                      onRefresh: () => context.read<SystemAlertsCubit>().load(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 80),
                          AppEmptyView(message: AlertsStrings.empty),
                        ],
                      ),
                    )
                  : RefreshIndicator(
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
                                        child: const Text(
                                          AlertsStrings.loadMore,
                                        ),
                                      ),
                              ),
                            );
                          }
                          final alert = items[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.notifications_active_outlined,
                            ),
                            title: Text(alert.summary),
                            subtitle: Text(
                              'Actor #${alert.actorUserId} · '
                              '${alert.timestamp.toLocal()}',
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
