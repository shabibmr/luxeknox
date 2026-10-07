import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership_freeze.dart';
import '../../domain/entities/membership_status.dart';
import '../cubit/membership_freeze_cubit.dart';
import '../membership_strings.dart';

/// Lists the freeze requests for a membership. When [canApprove] is true
/// (admin/manager — `memberships.approve`) pending rows get approve/reject
/// actions (FR-MEMB-015); otherwise it is a read-only history.
class MembershipFreezeList extends StatelessWidget {
  const MembershipFreezeList({
    super.key,
    required this.membershipId,
    this.canApprove = false,
    this.onChanged,
  });

  final String membershipId;
  final bool canApprove;

  /// Called after a freeze is approved or rejected, since that mutates the
  /// membership's own status server-side and the parent screen's status
  /// display won't otherwise know to reload.
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return _MembershipFreezeListBody(
      membershipId: membershipId,
      canApprove: canApprove,
      onChanged: onChanged,
    );
  }
}

class _MembershipFreezeListBody extends StatelessWidget {
  const _MembershipFreezeListBody({
    required this.membershipId,
    required this.canApprove,
    this.onChanged,
  });

  final String membershipId;
  final bool canApprove;
  final VoidCallback? onChanged;

  Future<void> _handleApprove(
    BuildContext context,
    MembershipFreeze freeze,
  ) async {
    final failure = await context.read<MembershipFreezeCubit>().approve(
      freeze.id,
    );
    if (!context.mounted) return;
    if (failure == null) {
      onChanged?.call();
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
  }

  Future<void> _handleReject(
    BuildContext context,
    MembershipFreeze freeze,
  ) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(MembershipStrings.reject),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: MembershipStrings.reasonLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(MembershipStrings.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text(MembershipStrings.confirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null || !context.mounted) return;

    final failure = await context.read<MembershipFreezeCubit>().reject(
      freeze.id,
      reason: reason.isEmpty ? null : reason,
    );
    if (!context.mounted) return;
    if (failure == null) {
      onChanged?.call();
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
  }

  String _statusLabel(FreezeStatus status) => switch (status) {
    FreezeStatus.pending => 'Pending',
    FreezeStatus.approved => 'Approved',
    FreezeStatus.rejected => 'Rejected',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembershipFreezeCubit, MembershipFreezeState>(
      builder: (context, state) {
        final noItems = state.items.isEmpty;
        if (noItems &&
            (state.status == LoadStatus.initial ||
                state.status == LoadStatus.loading)) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (noItems && state.status == LoadStatus.failure) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  state.failure == null
                      ? MembershipStrings.noneFound
                      : failureMessage(state.failure!),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.read<MembershipFreezeCubit>().load(
                    membershipId: membershipId,
                  ),
                  child: const Text(MembershipStrings.retry),
                ),
              ],
            ),
          );
        }
        if (noItems) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text(MembershipStrings.noneFound)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final freeze = state.items[index];
            final start = formatMembershipDate(freeze.startDate);
            final end = formatMembershipDate(freeze.endDate);
            final isBusy = state.busyId == freeze.id;
            final actionsLocked = isBusy || state.status == LoadStatus.loading;
            return ListTile(
              leading: const Icon(Icons.pause_circle_outline),
              title: Text('$start → $end'),
              subtitle: Text(
                [
                  _statusLabel(freeze.status),
                  if (freeze.reason != null) freeze.reason!,
                ].join(' · '),
              ),
              trailing: canApprove && freeze.status == FreezeStatus.pending
                  ? isBusy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                tooltip: MembershipStrings.approve,
                                onPressed: actionsLocked
                                    ? null
                                    : () => _handleApprove(context, freeze),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                tooltip: MembershipStrings.reject,
                                onPressed: actionsLocked
                                    ? null
                                    : () => _handleReject(context, freeze),
                              ),
                            ],
                          )
                  : null,
            );
          },
        );
      },
    );
  }
}
