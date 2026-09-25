import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
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
      listenWhen: (previous, next) =>
          next.notification != null &&
          next.status != LoadStatus.failure &&
          next.failure != null &&
          next.failure != previous.failure,
      listener: (context, state) {
        final failure = state.failure;
        if (failure == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
      },
      builder: (context, state) {
        final notification = state.notification;
        final deepLinkPath = state.deepLinkPath;
        final Widget body;
        if (state.status == LoadStatus.loading && notification == null) {
          body = const AppLoading();
        } else if (state.status == LoadStatus.failure &&
            notification == null) {
          body = AppErrorView(
            message: state.failure == null
                ? ''
                : failureMessage(state.failure!),
            onRetry: () => context.read<NotificationDetailCubit>().load(
              notificationId,
            ),
          );
        } else if (notification == null) {
          body = const AppLoading();
        } else {
          body = ListView(
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
              );
        }
        return Scaffold(
          appBar: AppBar(title: const Text(NotificationStrings.detailTitle)),
          body: body,
        );
      },
    );
  }
}
