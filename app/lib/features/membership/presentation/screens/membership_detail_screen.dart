import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/cancel_membership_usecase.dart';
import '../../domain/usecases/extend_membership_usecase.dart';
import '../../domain/usecases/get_membership_usecase.dart';
import '../../domain/usecases/renew_membership_usecase.dart';
import '../membership_strings.dart';
import '../widgets/membership_freeze_list.dart';
import '../widgets/membership_history_list.dart';
import '../widgets/membership_status_chip.dart';

/// Screen 5.2 — Membership Details & Status. Admin/manager
/// (`memberships.approve`) get renew/upgrade/cancel and freeze
/// approve/reject/extend actions; everyone with `memberships.read` gets the
/// read-only contract, freeze history, and change history.
class MembershipDetailScreen extends StatefulWidget {
  const MembershipDetailScreen({super.key, required this.membershipId});

  final String membershipId;

  @override
  State<MembershipDetailScreen> createState() =>
      _MembershipDetailScreenState();
}

class _MembershipDetailScreenState extends State<MembershipDetailScreen> {
  final _getMembership = getIt<GetMembershipUseCase>();
  final _renew = getIt<RenewMembershipUseCase>();
  final _cancel = getIt<CancelMembershipUseCase>();
  final _extend = getIt<ExtendMembershipUseCase>();

  bool _loading = true;
  String? _error;
  Membership? _membership;
  bool _actionInFlight = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _getMembership(widget.membershipId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (membership) => setState(() {
        _loading = false;
        _membership = membership;
      }),
    );
  }

  void _showError(Failure failure) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
  }

  Future<void> _handleRenew() async {
    final membership = _membership;
    if (membership == null) return;
    setState(() => _actionInFlight = true);
    final result = await _renew(
      MembershipActionParams(
        membershipId: membership.id,
        rowVersion: membership.rowVersion,
      ),
    );
    if (!mounted) return;
    setState(() => _actionInFlight = false);
    result.fold(_showError, (_) => _load());
  }

  Future<void> _handleCancel() async {
    final membership = _membership;
    if (membership == null) return;

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
    if (confirmed != true) return;

    setState(() => _actionInFlight = true);
    final result = await _cancel(
      MembershipActionParams(
        membershipId: membership.id,
        rowVersion: membership.rowVersion,
        reason: reasonController.text.trim().isEmpty
            ? null
            : reasonController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _actionInFlight = false);
    result.fold(_showError, (_) => _load());
  }

  Future<void> _handleExtend() async {
    final membership = _membership;
    if (membership == null) return;

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
    if (confirmed != true) return;

    setState(() => _actionInFlight = true);
    final result = await _extend(
      ExtendMembershipParams(
        membershipId: membership.id,
        daysExtended: int.parse(daysController.text.trim()),
        reason: reasonController.text.trim().isEmpty
            ? null
            : reasonController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _actionInFlight = false);
    result.fold(_showError, (_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final canApprove = context.can('memberships.approve');

    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.detailTitle)),
      body: _buildBody(canApprove),
    );
  }

  Widget _buildBody(bool canApprove) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null || _membership == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error ?? MembershipStrings.noneFound, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                child: const Text(MembershipStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    final membership = _membership!;
    return RefreshIndicator(
      onRefresh: _load,
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
            _infoRow(MembershipStrings.lockerNumberLabel, membership.lockerNumber!),
          if (membership.product != null)
            _infoRow('Base price', membership.product!.basePrice),
          if (canApprove) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: _actionInFlight ? null : _handleRenew,
                  child: const Text(MembershipStrings.renew),
                ),
                OutlinedButton(
                  onPressed: _actionInFlight ? null : _handleExtend,
                  child: const Text(MembershipStrings.grantExtension),
                ),
                OutlinedButton(
                  onPressed: _actionInFlight ? null : _handleCancel,
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
