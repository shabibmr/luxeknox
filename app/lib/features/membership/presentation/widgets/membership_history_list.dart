import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership_status.dart';
import '../cubit/membership_history_cubit.dart';
import '../membership_strings.dart';

class MembershipHistoryList extends StatelessWidget {
  const MembershipHistoryList({super.key, required this.membershipId});

  final String membershipId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MembershipHistoryCubit>()..load(membershipId: membershipId),
      child: _MembershipHistoryListBody(membershipId: membershipId),
    );
  }
}

class _MembershipHistoryListBody extends StatelessWidget {
  const _MembershipHistoryListBody({required this.membershipId});

  final String membershipId;

  String _actionLabel(MembershipHistoryAction action) {
    switch (action) {
      case MembershipHistoryAction.created:
        return 'Created';
      case MembershipHistoryAction.renewed:
        return 'Renewed';
      case MembershipHistoryAction.upgraded:
        return 'Upgraded';
      case MembershipHistoryAction.frozen:
        return 'Frozen';
      case MembershipHistoryAction.expired:
        return 'Expired';
      case MembershipHistoryAction.cancelled:
        return 'Cancelled';
      case MembershipHistoryAction.extended:
        return 'Extended';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembershipHistoryCubit, MembershipHistoryState>(
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
                  onPressed: () => context.read<MembershipHistoryCubit>().load(
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
            final entry = state.items[index];
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(_actionLabel(entry.action)),
              subtitle: entry.newEndDate != null
                  ? Text(
                      'New end date: ${entry.newEndDate!.toLocal()}'
                          .split(' ')
                          .first,
                    )
                  : null,
              trailing: Text(
                entry.timestamp.toLocal().toString().split(' ').first,
              ),
            );
          },
        );
      },
    );
  }
}
