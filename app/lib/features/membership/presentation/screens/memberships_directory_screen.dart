import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/memberships_directory_cubit.dart';
import '../membership_strings.dart';
import '../widgets/membership_status_chip.dart';

/// Admin directory (FR-MEMB-008): filter Active / Expiring / Expired / Frozen /
/// Cancelled. "Expiring soon" is computed client-side over the `active` set.
class MembershipsDirectoryScreen extends StatelessWidget {
  const MembershipsDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembershipsDirectoryCubit>()..load(),
      child: const _MembershipsDirectoryBody(),
    );
  }
}

class _MembershipsDirectoryBody extends StatelessWidget {
  const _MembershipsDirectoryBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MembershipStrings.directoryTitle),
        actions: [
          IconButton(
            tooltip: MembershipStrings.packagesTooltip,
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => context.go('${Routes.adminMemberships}/packages'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(Routes.adminMembershipsCreate),
        icon: const Icon(Icons.add),
        label: const Text(MembershipStrings.createFab),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: BlocBuilder<MembershipsDirectoryCubit, MembershipsDirectoryState>(
              buildWhen: (p, n) => p.runtimeType != n.runtimeType ||
                  (p is MembershipsDirectoryLoaded &&
                      n is MembershipsDirectoryLoaded &&
                      p.filter != n.filter) ||
                  (p is MembershipsDirectoryLoading &&
                      n is MembershipsDirectoryLoading &&
                      p.filter != n.filter) ||
                  (p is MembershipsDirectoryFailure &&
                      n is MembershipsDirectoryFailure &&
                      p.filter != n.filter),
              builder: (context, state) {
                final filter = switch (state) {
                  MembershipsDirectoryLoading(:final filter) => filter,
                  MembershipsDirectoryLoaded(:final filter) => filter,
                  MembershipsDirectoryFailure(:final filter) => filter,
                };
                return Wrap(
                  spacing: 8,
                  children: [
                    for (final entry in _filters)
                      ChoiceChip(
                        label: Text(entry.$2),
                        selected: filter == entry.$1,
                        onSelected: (_) => context
                            .read<MembershipsDirectoryCubit>()
                            .setFilter(entry.$1),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MembershipsDirectoryCubit, MembershipsDirectoryState>(
              builder: (context, state) {
                return switch (state) {
                  MembershipsDirectoryLoading() => const AppLoading(),
                  MembershipsDirectoryFailure(:final message) => AppErrorView(
                    message: message,
                    onRetry: () =>
                        context.read<MembershipsDirectoryCubit>().load(),
                  ),
                  MembershipsDirectoryLoaded(:final items) => items.isEmpty
                      ? const AppEmptyView(message: MembershipStrings.noneFound)
                      : RefreshIndicator(
                          onRefresh: () =>
                              context.read<MembershipsDirectoryCubit>().load(),
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final membership = items[index];
                              return ListTile(
                                title: Text(
                                  membership.product?.name ??
                                      'Member #${membership.memberId}',
                                ),
                                subtitle: Text(
                                  '${membership.startDate.toString().split(' ').first} → '
                                  '${membership.endDate.toString().split(' ').first}',
                                ),
                                trailing: MembershipStatusChip(
                                  status: membership.status,
                                ),
                                onTap: () => context.go(
                                  '${Routes.adminMemberships}/${membership.id}',
                                ),
                              );
                            },
                          ),
                        ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _filters = <(MembershipDirectoryFilter, String)>[
  (MembershipDirectoryFilter.all, MembershipStrings.filterAll),
  (MembershipDirectoryFilter.active, MembershipStrings.filterActive),
  (
    MembershipDirectoryFilter.expiringSoon,
    MembershipStrings.filterExpiringSoon,
  ),
  (MembershipDirectoryFilter.expired, MembershipStrings.filterExpired),
  (MembershipDirectoryFilter.frozen, MembershipStrings.filterFrozen),
  (MembershipDirectoryFilter.cancelled, MembershipStrings.filterCancelled),
];
