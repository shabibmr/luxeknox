import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/membership_product.dart';
import '../cubit/membership_packages_catalog_cubit.dart';
import '../membership_strings.dart';
import 'membership_product_form_screen.dart';

/// Screen 5.1 — Membership Packages Catalog (FR-MEMB-001/002/003). Admin gets
/// create/edit; member/trainer get a read-only browse (`memberships.read`).
class MembershipPackagesCatalogScreen extends StatelessWidget {
  const MembershipPackagesCatalogScreen({super.key, this.readOnly = false});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembershipPackagesCatalogCubit>()..load(activeOnly: readOnly),
      child: _CatalogBody(readOnly: readOnly),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({required this.readOnly});

  final bool readOnly;

  Future<void> _openForm(
    BuildContext context, {
    MembershipProduct? product,
  }) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => MembershipProductFormScreen(product: product),
      ),
    );
    if (saved == true && context.mounted) {
      await context.read<MembershipPackagesCatalogCubit>().load(activeOnly: readOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = !readOnly && context.can('memberships.create');
    final canUpdate = !readOnly && context.can('memberships.update');
    final hidePricing = !context.can('memberships.view_price');

    return Scaffold(
      appBar: AppBar(
        title: const Text(MembershipStrings.catalogTitle),
        actions: [
          if (canCreate)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: MembershipStrings.addTooltip,
              onPressed: () => _openForm(context),
            ),
        ],
      ),
      body:
          BlocBuilder<
            MembershipPackagesCatalogCubit,
            MembershipPackagesCatalogState
          >(
            builder: (context, state) => _buildBody(
              context,
              state,
              canUpdate: canUpdate,
              hidePricing: hidePricing,
            ),
          ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MembershipPackagesCatalogState state, {
    required bool canUpdate,
    required bool hidePricing,
  }) {
    final noItems = state.items.isEmpty;
    if (noItems &&
        (state.status == LoadStatus.initial ||
            state.status == LoadStatus.loading)) {
      return const AppLoading();
    }
    if (noItems && state.status == LoadStatus.failure) {
      return AppErrorView(
        message: state.failure == null
            ? MembershipStrings.noneFound
            : failureMessage(state.failure!),
        onRetry: () => context.read<MembershipPackagesCatalogCubit>().load(activeOnly: readOnly),
      );
    }
    if (noItems) {
      return const AppEmptyView(message: MembershipStrings.noneFound);
    }
    return RefreshIndicator(
      onRefresh: () => context.read<MembershipPackagesCatalogCubit>().load(activeOnly: readOnly),
      child: ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final product = state.items[index];
          final subtitle = hidePricing
              ? '${product.code} · ${product.durationDays}d'
              : '${product.code} · ${product.durationDays}d · ${product.basePrice}';
          return ListTile(
            title: Text(product.name),
            subtitle: Text(subtitle),
            trailing: product.isActive
                ? null
                : const Icon(Icons.visibility_off_outlined, size: 18),
            onTap: canUpdate
                ? () => _openForm(context, product: product)
                : null,
          );
        },
      ),
    );
  }
}
