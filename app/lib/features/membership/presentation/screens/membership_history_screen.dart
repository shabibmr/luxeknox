import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/usecases/get_memberships_usecase.dart';
import '../membership_strings.dart';
import '../widgets/membership_history_list.dart';

/// Member: R (Self) — resolves the caller's own membership id, then shows
/// its append-only history (FR-MEMB-013).
class MembershipHistoryScreen extends StatefulWidget {
  const MembershipHistoryScreen({super.key});

  @override
  State<MembershipHistoryScreen> createState() =>
      _MembershipHistoryScreenState();
}

class _MembershipHistoryScreenState extends State<MembershipHistoryScreen> {
  final _getMemberships = getIt<GetMembershipsUseCase>();

  bool _loading = true;
  String? _error;
  String? _membershipId;

  @override
  void initState() {
    super.initState();
    _resolveMembershipId();
  }

  Future<void> _resolveMembershipId() async {
    final state = context.read<SessionCubit>().state;
    final memberId = state is SessionAuthenticated
        ? state.principal.profileId
        : null;
    if (memberId == null) {
      setState(() {
        _loading = false;
        _error = MembershipStrings.noActiveMembership;
      });
      return;
    }
    final result = await _getMemberships(
      GetMembershipsParams(memberId: memberId),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (page) => setState(() {
        _loading = false;
        _membershipId = page.items.isEmpty ? null : page.items.first.id;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.historyTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_error != null || _membershipId == null)
          ? Center(
              child: Text(_error ?? MembershipStrings.noActiveMembership),
            )
          : SingleChildScrollView(
              child: MembershipHistoryList(membershipId: _membershipId!),
            ),
    );
  }
}
