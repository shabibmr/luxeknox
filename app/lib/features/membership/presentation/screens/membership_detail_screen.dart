import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/membership_detail_cubit.dart';
import '../cubit/membership_freeze_cubit.dart';
import '../cubit/membership_history_cubit.dart';
import '../membership_date_format.dart';
import '../membership_strings.dart';
import '../widgets/membership_freeze_list.dart';
import '../widgets/membership_history_list.dart';
import '../widgets/membership_status_chip.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';

/// Screen 5.2 — Membership Details & Status. Admin/manager
/// (`memberships.approve`) get renew/upgrade/cancel and freeze
/// approve/reject/extend actions; everyone with `memberships.read` gets the
/// read-only contract, freeze history, and change history.
class MembershipDetailScreen extends StatelessWidget {
  const MembershipDetailScreen({super.key, required this.membershipId});

  final String membershipId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<MembershipDetailCubit>()..load(membershipId),
        ),
        BlocProvider(
          create: (_) => getIt<MembershipFreezeCubit>()..load(membershipId: membershipId),
        ),
        BlocProvider(
          create: (_) => getIt<MembershipHistoryCubit>()..load(membershipId: membershipId),
        ),
      ],
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
    final result = await context.push<bool>(
      Routes.adminMembershipsRenewById(membershipId),
    );
    if (result == true && context.mounted) {
      context.read<MembershipDetailCubit>().load(membershipId);
    }
  }

  Future<void> _handleFreeze(BuildContext context) async {
    final result = await context.push<bool>(
      Routes.adminMembershipsFreezeById(membershipId),
    );
    if (result == true && context.mounted) {
      context.read<MembershipDetailCubit>().load(membershipId);
    }
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
    List<MembershipProduct> products = [];
    if (getIt.isRegistered<GetMembershipProductsUseCase>()) {
      final res = await getIt<GetMembershipProductsUseCase>()(
        const GetMembershipProductsParams(),
      );
      res.fold((_) {}, (page) => products = page.items);
    }

    String? selectedProductId = products.isNotEmpty ? products.first.id : null;
    final reasonController = TextEditingController();

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(MembershipStrings.upgrade),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (products.isNotEmpty)
                DropdownButtonFormField<String>(
                  initialValue: selectedProductId,
                  decoration: const InputDecoration(
                    labelText: 'Target Package',
                  ),
                  items: products
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text('${p.name} (${p.durationDays}d)'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedProductId = v);
                  },
                )
              else
                const Text('Loading packages...'),
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
            FilledButton(
              onPressed: selectedProductId == null
                  ? null
                  : () => Navigator.of(dialogContext).pop(true),
              child: const Text(MembershipStrings.confirm),
            ),
          ],
        ),
      ),
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true || selectedProductId == null || !context.mounted) {
      return;
    }

    final failure = await context.read<MembershipDetailCubit>().upgrade(
      productId: selectedProductId!,
      reason: reason.isEmpty ? null : reason,
    );
    if (!context.mounted || failure == null) return;
    _showActionError(context, failure, 'upgrade');
  }

  @override
  Widget build(BuildContext context) {
    final canApprove = context.can('memberships.approve');
    final canUpdate = context.can('memberships.update');
    final hidePricing = !context.can('memberships.view_price');

    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.detailTitle)),
      body: BlocBuilder<MembershipDetailCubit, MembershipDetailState>(
        builder: (context, state) {
          return _buildBody(
            context,
            state,
            canApprove: canApprove,
            canUpdate: canUpdate,
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
    required bool canUpdate,
    required bool hidePricing,
  }) {
    final membership = state.membership;
    if (membership == null &&
        (state.status == LoadStatus.initial ||
            state.status == LoadStatus.loading)) {
      return const AppLoading();
    }
    if (membership == null) {
      void reload() => context.read<MembershipDetailCubit>().load(membershipId);

      if (state.failure != null) {
        return AppErrorView(
          message: failureMessage(state.failure!),
          onRetry: reload,
        );
      }
      return AppEmptyView(
        message: MembershipStrings.noneFound,
        action: reload,
        actionLabel: MembershipStrings.retry,
      );
    }

    final actionsLocked =
        state.actionInFlight || state.status == LoadStatus.loading;

    return RefreshIndicator(
      onRefresh: () =>
          context.read<MembershipDetailCubit>().load(membership.id),
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
            formatMembershipDate(membership.startDate),
          ),
          _infoRow(
            MembershipStrings.endDateLabel,
            formatMembershipDate(membership.endDate),
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
          if (canApprove || canUpdate) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (canApprove)
                  OutlinedButton(
                    onPressed: actionsLocked
                        ? null
                        : () => _handleRenew(context),
                    child: const Text(MembershipStrings.renew),
                  ),
                if (canUpdate)
                  OutlinedButton(
                    onPressed: actionsLocked
                        ? null
                        : () => _handleFreeze(context),
                    child: const Text(MembershipStrings.freezeSubmit),
                  ),
                if (canApprove)
                  OutlinedButton(
                    onPressed: actionsLocked
                        ? null
                        : () => _handleUpgrade(context),
                    child: const Text(MembershipStrings.upgrade),
                  ),
                if (canApprove)
                  OutlinedButton(
                    onPressed: actionsLocked
                        ? null
                        : () => _handleExtend(context),
                    child: const Text(MembershipStrings.grantExtension),
                  ),
                if (canApprove)
                  OutlinedButton(
                    onPressed: actionsLocked
                        ? null
                        : () => _handleCancel(context),
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
            onChanged: () =>
                context.read<MembershipDetailCubit>().load(membership.id),
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
        children: [
          Expanded(
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
