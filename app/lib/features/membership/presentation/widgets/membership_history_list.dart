import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/membership_history_entry.dart';
import '../../domain/entities/membership_status.dart';
import '../../domain/usecases/get_membership_history_usecase.dart';
import '../membership_strings.dart';

class MembershipHistoryList extends StatefulWidget {
  const MembershipHistoryList({super.key, required this.membershipId});

  final String membershipId;

  @override
  State<MembershipHistoryList> createState() => _MembershipHistoryListState();
}

class _MembershipHistoryListState extends State<MembershipHistoryList> {
  final _useCase = getIt<GetMembershipHistoryUseCase>();

  bool _loading = true;
  String? _error;
  List<MembershipHistoryEntry> _items = const [];

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
    final result = await _useCase(
      GetMembershipHistoryParams(membershipId: widget.membershipId),
    );
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
        final entry = _items[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(_actionLabel(entry.action)),
          subtitle: entry.newEndDate != null
              ? Text('New end date: ${entry.newEndDate!.toLocal()}'.split(' ').first)
              : null,
          trailing: Text(entry.timestamp.toLocal().toString().split(' ').first),
        );
      },
    );
  }
}
