import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/notification_detail_cubit.dart';
import '../notification_strings.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.notificationId});

  final String notificationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NotificationDetailCubit>()..load(notificationId),
      child: _DetailBody(notificationId: notificationId),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.notificationId});

  final String notificationId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationDetailCubit, NotificationDetailState>(
      listenWhen: (prev, next) =>
          next is NotificationDetailLoaded && next.actionError != null,
      listener: (context, state) {
        if (state is NotificationDetailLoaded && state.actionError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionError!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text(NotificationStrings.detailTitle)),
          body: switch (state) {
            NotificationDetailLoading() => const AppLoading(),
            NotificationDetailFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context
                  .read<NotificationDetailCubit>()
                  .load(notificationId),
            ),
            NotificationDetailLoaded(
              :final notification,
              :final deepLinkPath,
            ) =>
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().add_jm().format(
                      notification.createdAt.toLocal(),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      notification.unread
                          ? NotificationStrings.unreadLabel
                          : NotificationStrings.alreadyRead,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (deepLinkPath != null) ...[
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.push(deepLinkPath),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text(NotificationStrings.openRelated),
                    ),
                  ],
                  if (notification.unread) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<NotificationDetailCubit>().markRead(),
                      child: const Text(NotificationStrings.markRead),
                    ),
                  ],
                ],
              ),
          },
        );
      },
    );
  }
}
