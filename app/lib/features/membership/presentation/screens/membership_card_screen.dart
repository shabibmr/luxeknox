import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/usecases/request_membership_freeze_usecase.dart';
import '../cubit/membership_card_cubit.dart';
import '../membership_strings.dart';
import '../widgets/membership_status_chip.dart';

/// Screen 5.2 (Member: R/Self) — the member's own current contract, plus
/// a freeze request action (FR-MEMB-014).
class MembershipCardScreen extends StatelessWidget {
  const MembershipCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final session = context.read<SessionCubit>().state;
        final memberId = session is SessionAuthenticated
            ? session.principal.profileId
            : null;
        return getIt<MembershipCardCubit>()..load(memberId);
      },
      child: const _MembershipCardBody(),
    );
  }
}

class _MembershipCardBody extends StatelessWidget {
  const _MembershipCardBody();

  Future<void> _requestFreezeDialog(BuildContext context) async {
    final membership = context.read<MembershipCardCubit>().state.membership;
    if (membership == null) return;

    DateTime? start;
    DateTime? end;
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text(MembershipStrings.requestFreeze),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(MembershipStrings.startDateLabel),
                subtitle: Text(start?.toString().split(' ').first ?? '—'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dialogContext,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setDialogState(() => start = picked);
                },
              ),
              ListTile(
                title: const Text(MembershipStrings.endDateLabel),
                subtitle: Text(end?.toString().split(' ').first ?? '—'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dialogContext,
                    initialDate: start ?? DateTime.now(),
                    firstDate: start ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setDialogState(() => end = picked);
                },
              ),
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
              onPressed: start != null && end != null
                  ? () => Navigator.of(dialogContext).pop(true)
                  : null,
              child: const Text(MembershipStrings.confirm),
            ),
          ],
        ),
      ),
    );
    final reason = reasonController.text.trim();
    final startDate = start;
    final endDate = end;
    reasonController.dispose();
    if (confirmed != true ||
        startDate == null ||
        endDate == null ||
        !context.mounted) {
      return;
    }

    final result = await context.read<MembershipCardCubit>().requestFreeze(
      RequestMembershipFreezeParams(
        membershipId: membership.id,
        startDate: startDate,
        endDate: endDate,
        reason: reason.isEmpty ? null : reason,
      ),
    );
    if (!context.mounted || result == null) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failureMessage(failure)))),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Freeze request submitted.')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.cardTitle)),
      body: BlocBuilder<MembershipCardCubit, MembershipCardState>(
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MembershipCardState state) {
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
                    ? MembershipStrings.noActiveMembership
                    : failureMessage(state.failure!),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final session = context.read<SessionCubit>().state;
                  final memberId = session is SessionAuthenticated
                      ? session.principal.profileId
                      : null;
                  context.read<MembershipCardCubit>().load(memberId);
                },
                child: const Text(MembershipStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        final session = context.read<SessionCubit>().state;
        final memberId = session is SessionAuthenticated
            ? session.principal.profileId
            : null;
        return context.read<MembershipCardCubit>().load(memberId);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  membership.product?.name ?? 'Membership',
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
          if (membership.product?.accessFacilities.isNotEmpty ?? false)
            _infoRow(
              MembershipStrings.accessFacilitiesLabel,
              membership.product!.accessFacilities.join(', '),
            ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed:
                state.requestingFreeze || state.status == LoadStatus.loading
                ? null
                : () => _requestFreezeDialog(context),
            child: state.requestingFreeze
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(MembershipStrings.requestFreeze),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
