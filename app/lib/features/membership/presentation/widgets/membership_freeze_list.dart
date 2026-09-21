import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/membership_freeze.dart';
import '../../domain/entities/membership_status.dart';
import '../../domain/usecases/approve_freeze_usecase.dart';
import '../../domain/usecases/get_membership_freezes_usecase.dart';
import '../../domain/usecases/reject_freeze_usecase.dart';
import '../membership_strings.dart';

/// Lists the freeze requests for a membership. When [canApprove] is true
/// (admin/manager — `memberships.approve`) pending rows get approve/reject
/// actions (FR-MEMB-015); otherwise it is a read-only history.
class MembershipFreezeList extends StatefulWidget {
  const MembershipFreezeList({
    super.key,
    required this.membershipId,
    this.canApprove = false,
  });

  final String membershipId;
  final bool canApprove;

  @override
  State<MembershipFreezeList> createState() => _MembershipFreezeListState();
}

class _MembershipFreezeListState extends State<MembershipFreezeList> {
  final _getFreezes = getIt<GetMembershipFreezesUseCase>();
  final _approve = getIt<ApproveFreezeUseCase>();
  final _reject = getIt<RejectFreezeUseCase>();

  bool _loading = true;
  String? _error;
  List<MembershipFreeze> _items = const [];
  String? _busyId;

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
    final result = await _getFreezes(widget.membershipId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (page) => setState(() {
        _loading = false;
        _items = page.items;
      }),
    );
  }

  Future<void> _handleApprove(MembershipFreeze freeze) async {
    setState(() => _busyId = freeze.id);
    final result = await _approve(freeze.id);
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _busyId = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
      },
      (_) {
        setState(() => _busyId = null);
        _load();
      },
    );
  }

  Future<void> _handleReject(MembershipFreeze freeze) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(MembershipStrings.reject),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: MembershipStrings.reasonLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(MembershipStrings.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text(MembershipStrings.confirm),
          ),
        ],
      ),
    );
    if (reason == null) return;

    setState(() => _busyId = freeze.id);
    final result = await _reject(
      RejectFreezeParams(freezeId: freeze.id, reason: reason.isEmpty ? null : reason),
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() => _busyId = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(failure))));
      },
      (_) {
        setState(() => _busyId = null);
        _load();
      },
    );
  }

  String _statusLabel(FreezeStatus status) => switch (status) {
    FreezeStatus.pending => 'Pending',
    FreezeStatus.approved => 'Approved',
    FreezeStatus.rejected => 'Rejected',
  };

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _load,
              child: const Text(MembershipStrings.retry),
            ),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text(MembershipStrings.noneFound)),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final freeze = _items[index];
        final start = freeze.startDate.toString().split(' ').first;
        final end = freeze.endDate.toString().split(' ').first;
        final isBusy = _busyId == freeze.id;
        return ListTile(
          leading: const Icon(Icons.pause_circle_outline),
          title: Text('$start → $end'),
          subtitle: Text(
            [_statusLabel(freeze.status), if (freeze.reason != null) freeze.reason!]
                .join(' · '),
          ),
          trailing: widget.canApprove && freeze.status == FreezeStatus.pending
              ? isBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: MembershipStrings.approve,
                            onPressed: () => _handleApprove(freeze),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: MembershipStrings.reject,
                            onPressed: () => _handleReject(freeze),
                          ),
                        ],
                      )
              : null,
        );
      },
    );
  }
}
