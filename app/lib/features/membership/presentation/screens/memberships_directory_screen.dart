import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_memberships_usecase.dart';
import '../membership_strings.dart';
import '../widgets/membership_status_chip.dart';
import 'membership_detail_screen.dart';

enum _DirectoryFilter { all, active, expiringSoon, expired, frozen, cancelled }

/// Admin directory (FR-MEMB-008): filter Active / Expiring (7-30d) / Expired
/// / Frozen / Cancelled. "Expiring soon" is computed client-side over the
/// `active` set since the API only filters by exact `status`.
class MembershipsDirectoryScreen extends StatefulWidget {
  const MembershipsDirectoryScreen({super.key});

  @override
  State<MembershipsDirectoryScreen> createState() =>
      _MembershipsDirectoryScreenState();
}

class _MembershipsDirectoryScreenState
    extends State<MembershipsDirectoryScreen> {
  final _getMemberships = getIt<GetMembershipsUseCase>();

  bool _loading = true;
  String? _error;
  List<Membership> _items = const [];
  _DirectoryFilter _filter = _DirectoryFilter.all;

  static const int _expiringWithinDays = 30;

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
    final apiStatus = switch (_filter) {
      _DirectoryFilter.all => null,
      _DirectoryFilter.active => 'active',
      _DirectoryFilter.expiringSoon => 'active',
      _DirectoryFilter.expired => 'expired',
      _DirectoryFilter.frozen => 'frozen',
      _DirectoryFilter.cancelled => 'cancelled',
    };
    final result = await _getMemberships(
      GetMembershipsParams(status: apiStatus),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
      }),
      (page) => setState(() {
        _loading = false;
        _items = _filter == _DirectoryFilter.expiringSoon
            ? page.items
                  .where((m) => m.daysUntilExpiry <= _expiringWithinDays)
                  .toList()
            : page.items;
      }),
    );
  }

  void _setFilter(_DirectoryFilter filter) {
    setState(() => _filter = filter);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.directoryTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Wrap(
              spacing: 8,
              children: [
                _filterChip(_DirectoryFilter.all, MembershipStrings.filterAll),
                _filterChip(
                  _DirectoryFilter.active,
                  MembershipStrings.filterActive,
                ),
                _filterChip(
                  _DirectoryFilter.expiringSoon,
                  MembershipStrings.filterExpiringSoon,
                ),
                _filterChip(
                  _DirectoryFilter.expired,
                  MembershipStrings.filterExpired,
                ),
                _filterChip(
                  _DirectoryFilter.frozen,
                  MembershipStrings.filterFrozen,
                ),
                _filterChip(
                  _DirectoryFilter.cancelled,
                  MembershipStrings.filterCancelled,
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _filterChip(_DirectoryFilter filter, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == filter,
      onSelected: (_) => _setFilter(filter),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
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
    if (_items.isEmpty) {
      return const Center(child: Text(MembershipStrings.noneFound));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final membership = _items[index];
          return ListTile(
            title: Text(membership.product?.name ?? 'Member #${membership.memberId}'),
            subtitle: Text(
              '${membership.startDate.toString().split(' ').first} → '
              '${membership.endDate.toString().split(' ').first}',
            ),
            trailing: MembershipStatusChip(status: membership.status),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    MembershipDetailScreen(membershipId: membership.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
