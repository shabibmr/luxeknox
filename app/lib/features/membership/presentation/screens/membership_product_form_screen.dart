import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/create_membership_product_usecase.dart';
import '../../domain/usecases/update_membership_product_usecase.dart';
import '../membership_strings.dart';

/// Create/edit form for `membership_products` (FR-MEMB-001), gated by
/// `memberships.create`/`memberships.update`.
class MembershipProductFormScreen extends StatefulWidget {
  const MembershipProductFormScreen({super.key, this.product});

  final MembershipProduct? product;

  bool get isEditing => product != null;

  @override
  State<MembershipProductFormScreen> createState() =>
      _MembershipProductFormScreenState();
}

class _MembershipProductFormScreenState
    extends State<MembershipProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _createUseCase = getIt<CreateMembershipProductUseCase>();
  late final _updateUseCase = getIt<UpdateMembershipProductUseCase>();

  late final _nameController = TextEditingController(text: widget.product?.name);
  late final _codeController = TextEditingController(text: widget.product?.code);
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
    text: widget.product?.taxPercentage,
  );
  late final _maxFreezeController = TextEditingController(
    text: widget.product?.maxFreezeDays?.toString(),
  );
  late final _ptSessionsController = TextEditingController(
    text: widget.product?.ptSessionsIncluded?.toString(),
  );
  late final _facilitiesController = TextEditingController(
    text: widget.product?.accessFacilities.join(', '),
  );
  late bool _isActive = widget.product?.isActive ?? true;

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _taxController.dispose();
    _maxFreezeController.dispose();
    _ptSessionsController.dispose();
    _facilitiesController.dispose();
    super.dispose();
  }

  List<String> _splitList(String raw) =>
      raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final product = MembershipProduct(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      durationDays: int.tryParse(_durationController.text.trim()) ?? 0,
      basePrice: _priceController.text.trim(),
      taxPercentage: _taxController.text.trim().isEmpty
          ? null
          : _taxController.text.trim(),
      maxFreezeDays: int.tryParse(_maxFreezeController.text.trim()),
      ptSessionsIncluded: int.tryParse(_ptSessionsController.text.trim()),
      accessFacilities: _splitList(_facilitiesController.text),
      isActive: _isActive,
    );

    final result = widget.isEditing
        ? await _updateUseCase(product)
        : await _createUseCase(product);

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _isSubmitting = false;
        _errorMessage = failureMessage(failure);
      }),
      (_) => Navigator.of(context).pop(true),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? MembershipStrings.editTitle
              : MembershipStrings.addTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (_errorMessage != null) ...[
              MaterialBanner(
                content: Text(_errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                actions: const [SizedBox.shrink()],
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _nameController,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: MembershipStrings.nameLabel,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? MembershipStrings.nameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: MembershipStrings.codeLabel,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? MembershipStrings.codeRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              enabled: !_isSubmitting,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: MembershipStrings.descriptionLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: MembershipStrings.durationDaysLabel,
              ),
              validator: (v) => (int.tryParse(v?.trim() ?? '') == null)
                  ? MembershipStrings.durationDaysRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              enabled: !_isSubmitting,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: MembershipStrings.basePriceLabel,
                helperText: 'Two-decimal amount, e.g. 49.99',
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? MembershipStrings.basePriceRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _taxController,
              enabled: !_isSubmitting,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: MembershipStrings.taxPercentageLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxFreezeController,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: MembershipStrings.maxFreezeDaysLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ptSessionsController,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: MembershipStrings.ptSessionsIncludedLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _facilitiesController,
              enabled: !_isSubmitting,
              decoration: const InputDecoration(
                labelText: MembershipStrings.accessFacilitiesLabel,
                helperText: MembershipStrings.commaSeparatedHelper,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text(MembershipStrings.active),
              subtitle: const Text(MembershipStrings.activeSubtitle),
              value: _isActive,
              onChanged: _isSubmitting
                  ? null
                  : (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
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
    );
  }
}
