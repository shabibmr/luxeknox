import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_memberships_usecase.dart';
import '../../domain/usecases/request_membership_freeze_usecase.dart';
import '../membership_strings.dart';
import '../widgets/membership_status_chip.dart';

/// Screen 5.2 (Member: R/Self) — the member's own current contract, plus
/// a freeze request action (FR-MEMB-014).
class MembershipCardScreen extends StatefulWidget {
  const MembershipCardScreen({super.key});

  @override
  State<MembershipCardScreen> createState() => _MembershipCardScreenState();
}

class _MembershipCardScreenState extends State<MembershipCardScreen> {
  final _getMemberships = getIt<GetMembershipsUseCase>();
  final _requestFreeze = getIt<RequestMembershipFreezeUseCase>();

  bool _loading = true;
  String? _error;
  Membership? _membership;
  bool _requestingFreeze = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String? get _memberId {
    final state = context.read<SessionCubit>().state;
    return state is SessionAuthenticated ? state.principal.profileId : null;
  }

  Future<void> _load() async {
    final memberId = _memberId;
    if (memberId == null) {
      setState(() {
        _loading = false;
        _error = MembershipStrings.noActiveMembership;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
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
        _membership = page.items.isEmpty
            ? null
            : page.items.firstWhere(
                (m) => m.isActiveOrFrozen,
                orElse: () => page.items.first,
              );
      }),
    );
  }

  Future<void> _requestFreezeDialog() async {
    final membership = _membership;
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
    if (confirmed != true || start == null || end == null) return;

    setState(() => _requestingFreeze = true);
    final result = await _requestFreeze(
      RequestMembershipFreezeParams(
        membershipId: membership.id,
        startDate: start!,
        endDate: end!,
        reason: reasonController.text.trim().isEmpty
            ? null
            : reasonController.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _requestingFreeze = false);
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final membership = _membership;
    if (_error != null || membership == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error ?? MembershipStrings.noActiveMembership,
                textAlign: TextAlign.center,
              ),
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
            onPressed: _requestingFreeze ? null : _requestFreezeDialog,
            child: _requestingFreeze
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
        children: [Text(label), Flexible(child: Text(value, textAlign: TextAlign.end))],
      ),
    );
  }
}
