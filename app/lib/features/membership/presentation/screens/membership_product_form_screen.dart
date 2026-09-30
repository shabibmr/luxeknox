import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/currency/gym_currency_provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../../../../core/widgets/app_percent_field.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../../domain/entities/membership_product.dart';
import '../cubit/membership_product_form_cubit.dart';
import '../membership_strings.dart';

/// Create/edit form for `membership_products` (FR-MEMB-001), gated by
/// `memberships.create`/`memberships.update`.
class MembershipProductFormScreen extends StatelessWidget {
  const MembershipProductFormScreen({super.key, this.product});

  final MembershipProduct? product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembershipProductFormCubit>(),
      child: _MembershipProductFormBody(product: product),
    );
  }
}

class _MembershipProductFormBody extends StatefulWidget {
  const _MembershipProductFormBody({this.product});

  final MembershipProduct? product;

  bool get isEditing => product != null;

  @override
  State<_MembershipProductFormBody> createState() =>
      _MembershipProductFormBodyState();
}

class _MembershipProductFormBodyState
    extends State<_MembershipProductFormBody> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(
    text: widget.product?.name,
  );
  late final _descriptionController = TextEditingController(
    text: widget.product?.description,
  );
  late final _durationController = TextEditingController(
    text: widget.product?.durationDays.toString(),
  );
  late final _priceController = TextEditingController(
    text: widget.product?.basePrice,
  );
  late final _taxController = TextEditingController(
    text: widget.product?.taxPercentage ?? '0.00',
  );
  late bool _isActive = widget.product?.isActive ?? true;
  late final bool _initialIsActive = _isActive;

  bool _isDirty = false;

  String? _currencyCode;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<GymCurrencyProvider>()) {
      unawaited(
        getIt<GymCurrencyProvider>().currencyCode().then((code) {
          if (mounted) setState(() => _currencyCode = code);
        }),
      );
    }
    for (final c in [
      _nameController,
      _descriptionController,
      _durationController,
      _priceController,
      _taxController,
    ]) {
      c.addListener(_markDirty);
    }
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _descriptionController,
      _durationController,
      _priceController,
      _taxController,
    ]) {
      c.removeListener(_markDirty);
    }
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  /// Membership product `code` is a required, unique identifier server-side
  /// (`membership-product.dto.ts`), but the create form no longer collects it
  /// from staff. Derive one from the name plus a short uniqueness suffix so
  /// creation doesn't fail on an empty/duplicate code.
  String _generateCode(String name) {
    final slug = name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final suffix = DateTime.now().millisecondsSinceEpoch
        .toRadixString(36)
        .substring(0, 6);
    return slug.isEmpty ? suffix : '$slug-$suffix';
  }

  MembershipProduct _productFromFields() {
    final name = _nameController.text.trim();
    return MembershipProduct(
      id: widget.product?.id ?? '',
      name: name,
      code: widget.product?.code ?? _generateCode(name),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      durationDays: int.tryParse(_durationController.text.trim()) ?? 0,
      basePrice: _priceController.text.trim(),
      taxPercentage: _taxController.text.trim().isEmpty
          ? null
          : _taxController.text.trim(),
      maxFreezeDays: widget.product?.maxFreezeDays,
      ptSessionsIncluded: widget.product?.ptSessionsIncluded,
      accessFacilities: widget.product?.accessFacilities ?? const [],
      isActive: _isActive,
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<MembershipProductFormCubit>();
    final product = _productFromFields();
    if (!widget.isEditing) {
      await cubit.create(product);
    } else if (!product.isActive) {
      await cubit.deactivate(product);
    } else {
      await cubit.update(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MembershipProductFormCubit, MembershipProductFormState>(
      listenWhen: (previous, next) =>
          previous.status != LoadStatus.success &&
          next.status == LoadStatus.success,
      listener: (context, state) {
        setState(() => _isDirty = false);
        Navigator.of(context).pop(true);
      },
      builder: (context, state) {
        final requiredSlug = widget.isEditing
            ? 'memberships.update'
            : 'memberships.create';

        if (!context.can(requiredSlug)) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditing
                    ? MembershipStrings.editTitle
                    : MembershipStrings.addTitle,
              ),
            ),
            body: const Center(child: Text(MembershipStrings.noPermission)),
          );
        }

        final submitting = state.status == LoadStatus.loading;
        final dirty = _isDirty || _isActive != _initialIsActive;
        final errorMessage = state.failure == null
            ? null
            : failureMessage(state.failure!);

        return UnsavedChangesScope(
          hasUnsavedChanges: dirty && !submitting,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditing
                    ? MembershipStrings.editTitle
                    : MembershipStrings.addTitle,
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (errorMessage != null) ...[
                      MaterialBanner(
                        content: Text(errorMessage),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.errorContainer,
                        actions: const [SizedBox.shrink()],
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _nameController,
                      enabled: !submitting,
                      decoration: const InputDecoration(
                        labelText: MembershipStrings.nameLabel,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? MembershipStrings.nameRequired
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      enabled: !submitting,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: MembershipStrings.descriptionLabel,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _durationController,
                      enabled: !submitting,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: MembershipStrings.durationDaysLabel,
                      ),
                      validator: (v) => (int.tryParse(v?.trim() ?? '') == null)
                          ? MembershipStrings.durationDaysRequired
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppCurrencyField(
                      controller: _priceController,
                      label: MembershipStrings.basePriceLabel,
                      currencyCode: _currencyCode,
                      enabled: !submitting,
                      requiredMessage: MembershipStrings.basePriceRequired,
                    ),
                    const SizedBox(height: 16),
                    AppPercentField(
                      controller: _taxController,
                      label: MembershipStrings.taxPercentageLabel,
                      enabled: !submitting,
                      invalidMessage: MembershipStrings.taxPercentageInvalid,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text(MembershipStrings.active),
                      subtitle: const Text(MembershipStrings.activeSubtitle),
                      value: _isActive,
                      onChanged: submitting
                          ? null
                          : (v) => setState(() => _isActive = v),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: submitting ? null : () => _submit(context),
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(MembershipStrings.save),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
