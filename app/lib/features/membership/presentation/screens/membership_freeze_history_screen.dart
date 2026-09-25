import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../cubit/membership_freeze_cubit.dart';
import '../membership_strings.dart';
import '../widgets/membership_freeze_list.dart';

/// Member: R (Self) — the caller's own freeze request history
/// (FR-MEMB-014). Read-only: members cannot approve/reject their own.
class MembershipFreezeHistoryScreen extends StatelessWidget {
  const MembershipFreezeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final session = context.read<SessionCubit>().state;
        final memberId = session is SessionAuthenticated
            ? session.principal.profileId
            : null;
        return getIt<MembershipFreezeCubit>()..load(memberId: memberId);
      },
      child: const _MembershipFreezeHistoryBody(),
    );
  }
}

class _MembershipFreezeHistoryBody extends StatelessWidget {
  const _MembershipFreezeHistoryBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.freezesTitle)),
      body: BlocBuilder<MembershipFreezeCubit, MembershipFreezeState>(
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
            child: MembershipFreezeList(membershipId: id),
          );
        },
      ),
    );
  }
}
