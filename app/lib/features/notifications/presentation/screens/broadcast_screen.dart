import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/broadcast_audience.dart';
import '../cubit/broadcast_cubit.dart';
import '../notification_strings.dart';
import '../widgets/notification_list_tile.dart';

class BroadcastScreen extends StatelessWidget {
  const BroadcastScreen({
    super.key,
    this.trainerOnlyAssigned = false,
  });

  /// Trainer compose locks audience to assigned_clients.
  final bool trainerOnlyAssigned;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<BroadcastCubit>()
          ..configure(trainerOnlyAssigned: trainerOnlyAssigned);
        cubit.loadHistory();
        return cubit;
      },
      child: const _BroadcastBody(),
    );
  }
}

class _BroadcastBody extends StatelessWidget {
  const _BroadcastBody();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocConsumer<BroadcastCubit, BroadcastState>(
        listenWhen: (prev, next) {
          if (next is! BroadcastFormState) return false;
          return next.submitted != null ||
              next.submitError != null ||
              next.validationError != null;
        },
        listener: (context, state) {
          if (state is! BroadcastFormState) return;
          final msg = state.validationError ??
              state.submitError ??
              (state.submitted != null
                  ? NotificationStrings.broadcastSent
                  : null);
          if (msg != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        builder: (context, state) {
          final form = state is BroadcastFormState
              ? state
              : const BroadcastFormState();

          return Scaffold(
            appBar: AppBar(
              title: const Text(NotificationStrings.broadcastTitle),
              bottom: const TabBar(
                tabs: [
                  Tab(text: NotificationStrings.composeTab),
                  Tab(text: NotificationStrings.historyTab),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _ComposeTab(form: form),
                _HistoryTab(form: form),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ComposeTab extends StatefulWidget {
  const _ComposeTab({required this.form});

  final BroadcastFormState form;

  @override
  State<_ComposeTab> createState() => _ComposeTabState();
}

class _ComposeTabState extends State<_ComposeTab> {
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  late final TextEditingController _roleIdController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.form.title);
    _messageController = TextEditingController(text: widget.form.message);
    _roleIdController = TextEditingController(text: widget.form.roleId);
  }

  @override
  void didUpdateWidget(covariant _ComposeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Clear fields after successful submit.
    if (oldWidget.form.submitted == null && widget.form.submitted != null) {
      _titleController.clear();
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _roleIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BroadcastCubit>();
    final form = widget.form;
    final locked = form.lockedAudience != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: NotificationStrings.titleLabel,
            border: OutlineInputBorder(),
          ),
          onChanged: cubit.setTitle,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _messageController,
          decoration: const InputDecoration(
            labelText: NotificationStrings.messageLabel,
            border: OutlineInputBorder(),
          ),
          minLines: 3,
          maxLines: 6,
          onChanged: cubit.setMessage,
        ),
        const SizedBox(height: 16),
        if (locked)
          InputDecorator(
            decoration: const InputDecoration(
              labelText: NotificationStrings.audienceLabel,
              border: OutlineInputBorder(),
            ),
            child: Text(_audienceLabel(form.effectiveAudience)),
          )
        else
          DropdownButtonFormField<BroadcastAudience>(
            initialValue: form.effectiveAudience,
            decoration: const InputDecoration(
              labelText: NotificationStrings.audienceLabel,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: BroadcastAudience.allMembers,
                child: Text(NotificationStrings.audienceAllMembers),
              ),
              DropdownMenuItem(
                value: BroadcastAudience.assignedClients,
                child: Text(NotificationStrings.audienceAssignedClients),
              ),
              DropdownMenuItem(
                value: BroadcastAudience.role,
                child: Text(NotificationStrings.audienceRole),
              ),
            ],
            onChanged: (v) {
              if (v != null) cubit.setAudience(v);
            },
          ),
        if (form.effectiveAudience == BroadcastAudience.role) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _roleIdController,
            decoration: const InputDecoration(
              labelText: NotificationStrings.roleIdLabel,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: cubit.setRoleId,
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: form.submitting ? null : cubit.submit,
          child: form.submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(NotificationStrings.sendBroadcast),
        ),
      ],
    );
  }

  String _audienceLabel(BroadcastAudience audience) {
    return switch (audience) {
      BroadcastAudience.allMembers => NotificationStrings.audienceAllMembers,
      BroadcastAudience.assignedClients =>
        NotificationStrings.audienceAssignedClients,
      BroadcastAudience.role => NotificationStrings.audienceRole,
    };
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.form});

  final BroadcastFormState form;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BroadcastCubit>();

    if (form.historyLoading && form.history.isEmpty) {
      return const AppLoading();
    }
    if (form.historyError != null && form.history.isEmpty) {
      return AppErrorView(
        message: form.historyError!,
        onRetry: () => cubit.loadHistory(),
      );
    }
    if (form.history.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => cubit.loadHistory(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 80),
            AppEmptyView(message: NotificationStrings.emptyHistory),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.loadHistory(),
      child: ListView.separated(
        itemCount: form.history.length + (form.historyHasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= form.history.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: form.historyLoading
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () => cubit.loadHistory(refresh: false),
                        child: const Text(NotificationStrings.loadMore),
                      ),
              ),
            );
          }
          final n = form.history[index];
          return NotificationListTile(
            notification: n,
            onTap: () {},
          );
        },
      ),
    );
  }
}
