import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../cubit/trainer_membership_summary_cubit.dart';
import '../membership_strings.dart';
import '../widgets/membership_status_chip.dart';

/// Trainer: R (Assigned) — read-only summary for an assigned member's
/// contract. FR-MEMB-007: no pricing. The backend already omits the nested
/// `product` object for trainer-scoped reads, so there is nothing price-like
/// to accidentally render here — only plan-adjacent facts.
class TrainerMembershipSummaryScreen extends StatelessWidget {
  const TrainerMembershipSummaryScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrainerMembershipSummaryCubit>()..load(memberId),
      child: const _TrainerMembershipSummaryBody(),
    );
  }
}

class _TrainerMembershipSummaryBody extends StatelessWidget {
  const _TrainerMembershipSummaryBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.trainerSummaryTitle)),
      body: BlocBuilder<TrainerMembershipSummaryCubit, TrainerMembershipSummaryState>(
        builder: (context, state) {
          final membership = state.membership;
          if (membership == null &&
              (state.status == LoadStatus.initial ||
                  state.status == LoadStatus.loading)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (membership == null) {
            return Center(
              child: Text(
                state.failure == null
                    ? MembershipStrings.noActiveMembership
                    : failureMessage(state.failure!),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Membership #${membership.productId}',
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
            ],
          );
        },
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
