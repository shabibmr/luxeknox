import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
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
      listenWhen: (previous, next) {
        final messageChanged =
            next.actionMessage != null &&
            next.actionMessage != previous.actionMessage &&
            next.failure == null;
        final failureWithData =
            next.failure != previous.failure &&
            next.failure != null &&
            next.items.isNotEmpty;
        return messageChanged || failureWithData;
      },
      listener: (context, state) {
        final failure = state.failure;
        final text = failure != null && state.items.isNotEmpty
            ? failureMessage(failure)
            : state.actionMessage;
        if (text == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      },
      builder: (context, state) {
        final unread = state.unread;

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
          body: state.status == LoadStatus.loading && state.items.isEmpty
              ? const AppLoading()
              : state.status == LoadStatus.failure && state.items.isEmpty
              ? AppErrorView(
                  message: state.failure == null
                      ? ''
                      : failureMessage(state.failure!),
                  onRetry: () => context.read<NotificationsInboxCubit>().load(),
                )
              : _LoadedInbox(
                  state: state,
                  detailPathBuilder: detailPathBuilder,
                ),
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

  final NotificationsInboxState state;
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
