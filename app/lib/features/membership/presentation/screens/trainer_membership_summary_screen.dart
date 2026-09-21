import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_memberships_usecase.dart';
import '../membership_strings.dart';
import '../widgets/membership_status_chip.dart';

/// Trainer: R (Assigned) — read-only summary for an assigned member's
/// contract. FR-MEMB-007: no pricing. The backend already omits the nested
/// `product` object for trainer-scoped reads, so there is nothing price-like
/// to accidentally render here — only plan-adjacent facts.
class TrainerMembershipSummaryScreen extends StatefulWidget {
  const TrainerMembershipSummaryScreen({super.key, required this.memberId});

  final String memberId;

  @override
  State<TrainerMembershipSummaryScreen> createState() =>
      _TrainerMembershipSummaryScreenState();
}

class _TrainerMembershipSummaryScreenState
    extends State<TrainerMembershipSummaryScreen> {
  final _getMemberships = getIt<GetMembershipsUseCase>();

  bool _loading = true;
  String? _error;
  Membership? _membership;

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
    final result = await _getMemberships(
      GetMembershipsParams(memberId: widget.memberId),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (page) => setState(() {
        _loading = false;
        _membership = page.items.isEmpty
            ? null
            : page.items.firstWhere(
                (m) => m.isActiveOrFrozen,
                orElse: () => page.items.first,
              );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.trainerSummaryTitle)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final membership = _membership;
    if (_error != null || membership == null) {
      return Center(
        child: Text(_error ?? MembershipStrings.noActiveMembership),
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
