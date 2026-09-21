import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';
import '../membership_strings.dart';
import 'membership_product_form_screen.dart';

/// Screen 5.1 — Membership Packages Catalog (FR-MEMB-001/002/003). Admin gets
/// create/edit; member/trainer get a read-only browse (`memberships.read`).
class MembershipPackagesCatalogScreen extends StatefulWidget {
  const MembershipPackagesCatalogScreen({super.key, this.readOnly = false});

  final bool readOnly;

  @override
  State<MembershipPackagesCatalogScreen> createState() =>
      _MembershipPackagesCatalogScreenState();
}

class _MembershipPackagesCatalogScreenState
    extends State<MembershipPackagesCatalogScreen> {
  final _getProducts = getIt<GetMembershipProductsUseCase>();

  bool _loading = true;
  String? _error;
  List<MembershipProduct> _items = const [];

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
    final result = await _getProducts(const GetMembershipProductsParams());
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

  Future<void> _openForm({MembershipProduct? product}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => MembershipProductFormScreen(product: product),
      ),
    );
    if (saved == true && mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = !widget.readOnly && context.can('memberships.create');
    final canUpdate = !widget.readOnly && context.can('memberships.update');

    return Scaffold(
      appBar: AppBar(
        title: const Text(MembershipStrings.catalogTitle),
        actions: [
          if (canCreate)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: MembershipStrings.addTooltip,
              onPressed: () => _openForm(),
            ),
        ],
      ),
      body: _buildBody(canUpdate),
    );
  }

  Widget _buildBody(bool canUpdate) {
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
          final product = _items[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(
              '${product.code} · ${product.durationDays}d · ${product.basePrice}',
            ),
            trailing: product.isActive
                ? null
                : const Icon(Icons.visibility_off_outlined, size: 18),
            onTap: canUpdate ? () => _openForm(product: product) : null,
          );
        },
      ),
    );
  }
}
