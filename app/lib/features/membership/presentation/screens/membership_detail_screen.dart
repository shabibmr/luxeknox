import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../cubit/membership_detail_cubit.dart';
import '../membership_strings.dart';
import '../widgets/membership_freeze_list.dart';
import '../widgets/membership_history_list.dart';
import '../widgets/membership_status_chip.dart';

/// Screen 5.2 — Membership Details & Status. Admin/manager
/// (`memberships.approve`) get renew/upgrade/cancel and freeze
/// approve/reject/extend actions; everyone with `memberships.read` gets the
/// read-only contract, freeze history, and change history.
class MembershipDetailScreen extends StatelessWidget {
  const MembershipDetailScreen({super.key, required this.membershipId});

  final String membershipId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembershipDetailCubit>()..load(membershipId),
      child: _MembershipDetailView(membershipId: membershipId),
    );
  }
}

class _MembershipDetailView extends StatelessWidget {
  const _MembershipDetailView({required this.membershipId});

  final String membershipId;

  void _showActionError(BuildContext context, Failure failure, String action) {
    final message = failure is ConflictFailure
        ? MembershipStrings.rowVersionConflict(action)
        : failureMessage(failure);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleRenew(BuildContext context) async {
    final failure = await context.read<MembershipDetailCubit>().renew();
    if (!context.mounted || failure == null) return;
    _showActionError(context, failure, 'renew');
  }

  Future<void> _handleCancel(BuildContext context) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(MembershipStrings.cancelMembership),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(MembershipStrings.cancelConfirm),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: MembershipStrings.reasonLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(MembershipStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(MembershipStrings.confirm),
          ),
        ],
      ),
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true || !context.mounted) return;

    final failure = await context.read<MembershipDetailCubit>().cancel(
      reason: reason.isEmpty ? null : reason,
    );
    if (!context.mounted || failure == null) return;
    _showActionError(context, failure, 'cancel');
  }

  Future<void> _handleExtend(BuildContext context) async {
    final daysController = TextEditingController();
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(MembershipStrings.grantExtension),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: MembershipStrings.daysExtendedLabel,
                ),
                validator: (v) => (int.tryParse(v?.trim() ?? '') == null)
                    ? MembershipStrings.daysExtendedRequired
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: MembershipStrings.reasonLabel,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(MembershipStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(dialogContext).pop(true);
              }
            },
            child: const Text(MembershipStrings.confirm),
          ),
        ],
      ),
    );
    final days = int.tryParse(daysController.text.trim());
    final reason = reasonController.text.trim();
    daysController.dispose();
    reasonController.dispose();
    if (confirmed != true || days == null || !context.mounted) return;

    final failure = await context.read<MembershipDetailCubit>().extend(
      daysExtended: days,
      reason: reason.isEmpty ? null : reason,
    );
    if (!context.mounted || failure == null) return;
    _showActionError(context, failure, 'extend');
  }

  Future<void> _handleUpgrade(BuildContext context) async {
    final productController = TextEditingController();
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(MembershipStrings.upgrade),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productController,
              decoration: const InputDecoration(labelText: 'Product ID'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: MembershipStrings.reasonLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(MembershipStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(MembershipStrings.confirm),
          ),
        ],
      ),
    );
    final productId = productController.text.trim();
    final reason = reasonController.text.trim();
    productController.dispose();
    reasonController.dispose();
    if (confirmed != true || productId.isEmpty || !context.mounted) return;

    final failure = await context.read<MembershipDetailCubit>().upgrade(
      productId: productId,
      reason: reason.isEmpty ? null : reason,
    );
    if (!context.mounted || failure == null) return;
    _showActionError(context, failure, 'upgrade');
  }

  @override
  Widget build(BuildContext context) {
    final canApprove = context.can('memberships.approve');
    final session = context.watch<SessionCubit>().state;
    final hidePricing =
        session is SessionAuthenticated &&
        session.principal.userType == UserType.trainer;

    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.detailTitle)),
      body: BlocBuilder<MembershipDetailCubit, MembershipDetailState>(
        builder: (context, state) {
          return _buildBody(
            context,
            state,
            canApprove: canApprove,
            hidePricing: hidePricing,
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MembershipDetailState state, {
    required bool canApprove,
    required bool hidePricing,
  }) {
    final membership = state.membership;
    if (membership == null &&
        (state.status == LoadStatus.initial ||
            state.status == LoadStatus.loading)) {
      return const Center(child: CircularProgressIndicator());
    }
    if (membership == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.failure == null
                    ? MembershipStrings.noneFound
                    : failureMessage(state.failure!),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    context.read<MembershipDetailCubit>().load(membershipId),
                child: const Text(MembershipStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    final actionsLocked =
        state.actionInFlight || state.status == LoadStatus.loading;

    return RefreshIndicator(
      onRefresh: () => context.read<MembershipDetailCubit>().load(membership.id),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  membership.product?.name ?? 'Member #${membership.memberId}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              MembershipStatusChip(status: membership.status),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(
            MembershipStrings.startDateLabel,
            membership.startDate.toString().split(' ').first,
          ),
          _infoRow(
            MembershipStrings.endDateLabel,
            membership.endDate.toString().split(' ').first,
          ),
          if (membership.remainingPtSessions != null)
            _infoRow(
              MembershipStrings.remainingPtSessions,
              membership.remainingPtSessions.toString(),
            ),
          if (membership.lockerNumber != null)
            _infoRow(
              MembershipStrings.lockerNumberLabel,
              membership.lockerNumber!,
            ),
          if (membership.product != null && !hidePricing)
            _infoRow(
              MembershipStrings.basePriceLabel,
              membership.product!.basePrice,
            ),
          if (canApprove) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: actionsLocked ? null : () => _handleRenew(context),
                  child: const Text(MembershipStrings.renew),
                ),
                OutlinedButton(
                  onPressed: actionsLocked
                      ? null
                      : () => _handleUpgrade(context),
                  child: const Text(MembershipStrings.upgrade),
                ),
                OutlinedButton(
                  onPressed: actionsLocked
                      ? null
                      : () => _handleExtend(context),
                  child: const Text(MembershipStrings.grantExtension),
                ),
                OutlinedButton(
                  onPressed: actionsLocked ? null : () => _handleCancel(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text(MembershipStrings.cancelMembership),
                ),
              ],
            ),
          ],
          const Divider(height: 32),
          Text(
            MembershipStrings.freezesTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          MembershipFreezeList(
            membershipId: membership.id,
            canApprove: canApprove,
          ),
          const Divider(height: 32),
          Text(
            MembershipStrings.historyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          MembershipHistoryList(membershipId: membership.id),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
