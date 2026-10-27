import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/vendor.dart';
import '../accounting_strings.dart';
import '../cubit/vendors_cubit.dart';

class VendorsListScreen extends StatelessWidget {
  const VendorsListScreen({
    super.key,
    this.cubit,
  });

  final VendorsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.read')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.vendorsTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load();
      }
      return BlocProvider<VendorsCubit>.value(
        value: cubit!,
        child: const _VendorsListView(),
      );
    }

    return BlocProvider<VendorsCubit>(
      create: (_) => getIt<VendorsCubit>()..load(),
      child: const _VendorsListView(),
    );
  }
}

class _VendorsListView extends StatefulWidget {
  const _VendorsListView();

  @override
  State<_VendorsListView> createState() => _VendorsListViewState();
}

class _VendorsListViewState extends State<_VendorsListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<VendorsCubit>().searchVendors(query);
  }

  void _openVendorForm(BuildContext context, [Vendor? vendor]) async {
    final route = vendor != null
        ? Routes.adminAccountingVendorEditById(vendor.id)
        : Routes.adminAccountingVendorsCreate;
    final result = await context.push<dynamic>(route, extra: vendor);

    if (result != null && context.mounted) {
      context.read<VendorsCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.can('accounting.vendors_write');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.vendorsTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<VendorsCubit>().load(),
          ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton(
              key: const Key('create_vendor_fab'),
              tooltip: AccountingStrings.createVendorTitle,
              onPressed: () => _openVendorForm(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocConsumer<VendorsCubit, VendorsState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) {
          if (state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failureMessage(state.failure!)),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildFiltersBar(context, state),
              Expanded(
                child: _buildBody(context, state, canWrite),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFiltersBar(BuildContext context, VendorsState state) {
    final cubit = context.read<VendorsCubit>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          TextField(
            key: const Key('vendor_search_field'),
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AccountingStrings.searchVendors,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        cubit.searchVendors('');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  key: const Key('filter_all_vendors_chip'),
                  label: const Text(AccountingStrings.allStatuses),
                  selected: state.isActive == null,
                  onSelected: (selected) {
                    if (selected) {
                      cubit.filterByActive(null);
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('vendor_active_filter_chip'),
                  label: const Text(AccountingStrings.activeBadge),
                  selected: state.isActive == true,
                  onSelected: (selected) {
                    cubit.filterByActive(selected ? true : null);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  key: const Key('vendor_inactive_filter_chip'),
                  label: const Text(AccountingStrings.inactiveBadge),
                  selected: state.isActive == false,
                  onSelected: (selected) {
                    cubit.filterByActive(selected ? false : null);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, VendorsState state, bool canWrite) {
    if (state.status == LoadStatus.loading && state.vendors.isEmpty) {
      return const AppLoading();
    }

    if (state.status == LoadStatus.failure && state.vendors.isEmpty) {
      return AppErrorView(
        message: state.failure == null ? '' : failureMessage(state.failure!),
        onRetry: () => context.read<VendorsCubit>().load(),
      );
    }

    if (state.vendors.isEmpty) {
      return const AppEmptyView(message: AccountingStrings.noneFound);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<VendorsCubit>().load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            context.read<VendorsCubit>().loadNextPage();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: state.vendors.length + (state.hasReachedMax ? 0 : 1),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index >= state.vendors.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: AppLoading()),
              );
            }

            final vendor = state.vendors[index];
            return _buildVendorCard(context, vendor, canWrite);
          },
        ),
      ),
    );
  }

  Widget _buildVendorCard(
      BuildContext context, Vendor vendor, bool canWrite) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          vendor.name,
          key: Key('vendor_name_${vendor.id}'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vendor.phone != null && vendor.phone!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        vendor.phone!,
                        key: Key('vendor_phone_${vendor.id}'),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              if (vendor.contactEmail != null &&
                  vendor.contactEmail!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.email, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        vendor.contactEmail!,
                        key: Key('vendor_email_${vendor.id}'),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              if (vendor.taxNumber != null && vendor.taxNumber!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${AccountingStrings.gstinLabel}: ${vendor.taxNumber!}',
                        key: Key('vendor_gstin_${vendor.id}'),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        trailing: AppStatusChip(
          key: Key('vendor_status_chip_${vendor.id}'),
          label: vendor.isActive
              ? AccountingStrings.activeBadge
              : AccountingStrings.inactiveBadge,
          color: vendor.isActive ? Colors.green : Colors.grey,
        ),
        onTap: canWrite ? () => _openVendorForm(context, vendor) : null,
      ),
    );
  }
}
