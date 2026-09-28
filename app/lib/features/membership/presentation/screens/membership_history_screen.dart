import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../cubit/membership_history_cubit.dart';
import '../membership_strings.dart';
import '../widgets/membership_history_list.dart';

/// Member: R (Self) — resolves the caller's own membership id, then shows
/// its append-only history (FR-MEMB-013).
class MembershipHistoryScreen extends StatelessWidget {
  const MembershipHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final session = context.read<SessionCubit>().state;
        final memberId = session is SessionAuthenticated
            ? session.principal.profileId
            : null;
        return getIt<MembershipHistoryCubit>()..load(memberId: memberId);
      },
      child: const _MembershipHistoryBody(),
    );
  }
}

class _MembershipHistoryBody extends StatelessWidget {
  const _MembershipHistoryBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.historyTitle)),
      body: BlocBuilder<MembershipHistoryCubit, MembershipHistoryState>(
        builder: (context, state) {
          final id = state.membershipId;
          if (id == null &&
              (state.status == LoadStatus.initial ||
                  state.status == LoadStatus.loading)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (id == null && state.status == LoadStatus.failure) {
            return Center(
              child: Text(
                state.failure == null
                    ? MembershipStrings.noActiveMembership
                    : failureMessage(state.failure!),
              ),
            );
          }
          if (id == null) {
            return const Center(
              child: Text(MembershipStrings.noActiveMembership),
            );
          }
          return SingleChildScrollView(
            child: MembershipHistoryList(membershipId: id),
          );
        },
      ),
    );
  }
}
