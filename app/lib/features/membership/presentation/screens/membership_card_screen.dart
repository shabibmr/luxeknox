import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/usecases/request_membership_freeze_usecase.dart';
import '../cubit/membership_card_cubit.dart';
import '../membership_date_format.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (membership.product?.maxFreezeDays != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 16),
                  child: Text(
                    '${MembershipStrings.maxFreezeDaysLabel}: ${membership.product!.maxFreezeDays}',
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                ),
              ListTile(
                title: const Text(MembershipStrings.startDateLabel),
                subtitle: Text(
                  start == null ? '—' : formatMembershipDate(start!),
                ),
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
                subtitle: Text(end == null ? '—' : formatMembershipDate(end!)),
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
                onChanged: (_) => setDialogState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(MembershipStrings.cancel),
            ),
            TextButton(
              onPressed:
                  start != null &&
                      end != null &&
                      reasonController.text.trim().isNotEmpty
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

    await context.read<MembershipCardCubit>().requestFreeze(
      RequestMembershipFreezeParams(
        membershipId: membership.id,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.cardTitle)),
      body: BlocListener<MembershipCardCubit, MembershipCardState>(
        listenWhen: (previous, current) =>
            previous.requestingFreeze && !current.requestingFreeze,
        listener: (context, state) {
          final message = state.failure == null
              ? 'Freeze request submitted.'
              : failureMessage(state.failure!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
        child: BlocBuilder<MembershipCardCubit, MembershipCardState>(
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MembershipCardState state) {
    final membership = state.membership;
    if (membership == null &&
        (state.status == LoadStatus.initial ||
            state.status == LoadStatus.loading)) {
      return const AppLoading();
    }

    if (membership == null) {
      void reload() {
        final session = context.read<SessionCubit>().state;
        final memberId = session is SessionAuthenticated
            ? session.principal.profileId
            : null;
        context.read<MembershipCardCubit>().load(memberId);
      }

      if (state.failure != null) {
        return AppErrorView(
          message: failureMessage(state.failure!),
          onRetry: reload,
        );
      }
      return AppEmptyView(
        message: MembershipStrings.noActiveMembership,
        action: reload,
        actionLabel: MembershipStrings.retry,
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
          if (membership.product?.description?.isNotEmpty ?? false)
            _infoRow(
              MembershipStrings.descriptionLabel,
              membership.product!.description!,
            ),
          _infoRow(
            MembershipStrings.remainingDays,
            membership.daysUntilExpiry.clamp(0, 99999).toString(),
          ),
          if (membership.remainingPtSessions != null)
            _infoRow(
              MembershipStrings.remainingPtSessions,
              membership.remainingPtSessions.toString(),
            ),
          if (membership.product?.maxFreezeDays != null)
            _infoRow(
              MembershipStrings.maxFreezeDaysLabel,
              membership.product!.maxFreezeDays.toString(),
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
          const Divider(height: 32),
          ListTile(
            title: const Text(MembershipStrings.historyTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.memberMembershipHistory),
          ),
          ListTile(
            title: const Text(MembershipStrings.freezesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.memberMembershipFreezeHistory),
          ),
          ListTile(
            title: const Text(MembershipStrings.catalogTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.memberMembershipPackages),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
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
