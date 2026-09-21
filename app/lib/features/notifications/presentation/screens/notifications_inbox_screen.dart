import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/notifications_inbox_cubit.dart';
import '../notification_strings.dart';
import '../widgets/notification_list_tile.dart';

class NotificationsInboxScreen extends StatelessWidget {
  const NotificationsInboxScreen({
    super.key,
    required this.detailPathBuilder,
    this.showBroadcastAction = false,
    this.broadcastPath,
  });

  final String Function(String id) detailPathBuilder;
  final bool showBroadcastAction;
  final String? broadcastPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsInboxCubit>()..load(),
      child: _InboxBody(
        detailPathBuilder: detailPathBuilder,
        showBroadcastAction: showBroadcastAction,
        broadcastPath: broadcastPath,
      ),
    );
  }
}

class _InboxBody extends StatelessWidget {
  const _InboxBody({
    required this.detailPathBuilder,
    required this.showBroadcastAction,
    required this.broadcastPath,
  });

  final String Function(String id) detailPathBuilder;
  final bool showBroadcastAction;
  final String? broadcastPath;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsInboxCubit, NotificationsInboxState>(
      listenWhen: (prev, next) {
        if (next is! NotificationsInboxLoaded) return false;
        return next.actionError != null || next.actionMessage != null;
      },
      listener: (context, state) {
        if (state is! NotificationsInboxLoaded) return;
        final messenger = ScaffoldMessenger.of(context);
        final msg = state.actionError ?? state.actionMessage;
        if (msg != null) {
          messenger.showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        final unread = state is NotificationsInboxLoaded ? state.unread : 0;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Text(NotificationStrings.inboxTitle),
                if (unread > 0) ...[
                  const SizedBox(width: 8),
                  Badge(label: Text('$unread')),
                ],
              ],
            ),
            actions: [
              if (showBroadcastAction &&
                  broadcastPath != null &&
                  (context.can('notifications.send') ||
                      context.can('notifications.broadcast')))
                IconButton(
                  tooltip: NotificationStrings.broadcastTitle,
                  onPressed: () => context.push(broadcastPath!),
                  icon: const Icon(Icons.campaign_outlined),
                ),
              PopupMenuButton<_InboxMenu>(
                onSelected: (value) {
                  final cubit = context.read<NotificationsInboxCubit>();
                  switch (value) {
                    case _InboxMenu.markAllRead:
                      cubit.markAllRead();
                    case _InboxMenu.registerDevice:
                      cubit.registerDevice();
                    case _InboxMenu.rotateToken:
                      cubit.registerDevice(rotate: true);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _InboxMenu.markAllRead,
                    child: Text(NotificationStrings.markAllRead),
                  ),
                  PopupMenuItem(
                    value: _InboxMenu.registerDevice,
                    child: Text(NotificationStrings.registerDevice),
                  ),
                  PopupMenuItem(
                    value: _InboxMenu.rotateToken,
                    child: Text(NotificationStrings.rotateToken),
                  ),
                ],
              ),
            ],
          ),
          body: switch (state) {
            NotificationsInboxLoading() => const AppLoading(),
            NotificationsInboxFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<NotificationsInboxCubit>().load(),
            ),
            NotificationsInboxLoaded() => _LoadedInbox(
              state: state,
              detailPathBuilder: detailPathBuilder,
            ),
          },
        );
      },
    );
  }
}

enum _InboxMenu { markAllRead, registerDevice, rotateToken }

class _LoadedInbox extends StatelessWidget {
  const _LoadedInbox({
    required this.state,
    required this.detailPathBuilder,
  });

  final NotificationsInboxLoaded state;
  final String Function(String id) detailPathBuilder;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsInboxCubit>();
    final visible = state.visibleItems;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SegmentedButton<InboxFilter>(
            segments: const [
              ButtonSegment(
                value: InboxFilter.all,
                label: Text(NotificationStrings.filterAll),
              ),
              ButtonSegment(
                value: InboxFilter.unread,
                label: Text(NotificationStrings.filterUnread),
              ),
            ],
            selected: {state.filter},
            onSelectionChanged: (values) => cubit.setFilter(values.first),
          ),
        ),
        if (state.unread > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${state.unread} ${NotificationStrings.unreadBanner}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: cubit.refresh,
            child: visible.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      AppEmptyView(
                        message: state.filter == InboxFilter.unread
                            ? NotificationStrings.emptyUnread
                            : NotificationStrings.emptyInbox,
                      ),
                    ],
                  )
                : ListView.separated(
                    itemCount: visible.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index >= visible.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: state.loadingMore
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: cubit.loadMore,
                                    child: const Text(
                                      NotificationStrings.loadMore,
                                    ),
                                  ),
                          ),
                        );
                      }
                      final n = visible[index];
                      return NotificationListTile(
                        notification: n,
                        onTap: () => context.push(detailPathBuilder(n.id)),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
