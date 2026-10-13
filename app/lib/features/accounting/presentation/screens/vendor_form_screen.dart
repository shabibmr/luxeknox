import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/vendor.dart';
import '../accounting_strings.dart';
import '../cubit/vendor_form_cubit.dart';

class VendorFormScreen extends StatelessWidget {
  const VendorFormScreen({
    super.key,
    this.vendorId,
    this.initialVendor,
    this.cubit,
  });

  final String? vendorId;
  final Vendor? initialVendor;
  final VendorFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.vendors_write')) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            vendorId != null || initialVendor != null
                ? AccountingStrings.editVendorTitle
                : AccountingStrings.createVendorTitle,
          ),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      if (initialVendor != null &&
          cubit!.state.vendor == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.setVendor(initialVendor!);
      } else if (vendorId != null &&
          cubit!.state.vendor == null &&
          cubit!.state.status == LoadStatus.initial) {
        cubit!.load(vendorId!);
      }
      return BlocProvider<VendorFormCubit>.value(
        value: cubit!,
        child: _VendorFormView(isEdit: vendorId != null || initialVendor != null),
      );
    }

    return BlocProvider<VendorFormCubit>(
      create: (_) {
        final c = getIt<VendorFormCubit>();
        if (initialVendor != null) {
          c.setVendor(initialVendor!);
        } else if (vendorId != null) {
          c.load(vendorId!);
        }
        return c;
      },
      child: _VendorFormView(isEdit: vendorId != null || initialVendor != null),
    );
  }
}

class _VendorFormView extends StatefulWidget {
  const _VendorFormView({required this.isEdit});

  final bool isEdit;

  @override
  State<_VendorFormView> createState() => _VendorFormViewState();
}

class _VendorFormViewState extends State<_VendorFormView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstinController = TextEditingController();
  bool _initializedFromState = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstinController.dispose();
    super.dispose();
  }

  void _syncControllers(VendorFormState state) {
    if (!_initializedFromState && state.vendor != null) {
      _nameController.text = state.name;
      _phoneController.text = state.phone;
      _emailController.text = state.email;
      _gstinController.text = state.gstin;
      _initializedFromState = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEdit
        ? AccountingStrings.editVendorTitle
        : AccountingStrings.createVendorTitle;

    return BlocConsumer<VendorFormCubit, VendorFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.savedVendor != current.savedVendor ||
          (current.failure != null && previous.failure != current.failure),
      listener: (context, state) {
        if (state.status == LoadStatus.success && state.savedVendor != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEdit
                    ? AccountingStrings.vendorUpdatedSuccess
                    : AccountingStrings.vendorCreatedSuccess,
              ),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(state.savedVendor);
          }
        } else if (state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(state.failure!)),
            ),
          );
        }
      },
      builder: (context, state) {
        _syncControllers(state);

        if (state.status == LoadStatus.loading && state.vendor == null) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: const AppLoading(),
          );
        }

        final cubit = context.read<VendorFormCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('vendor_name_field'),
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '${AccountingStrings.nameLabel} *',
                    errorText: state.nameError,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: cubit.nameChanged,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('vendor_phone_field'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AccountingStrings.phoneLabel,
                    errorText: state.phoneError,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: cubit.phoneChanged,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('vendor_email_field'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AccountingStrings.emailLabel,
                    errorText: state.emailError,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: cubit.emailChanged,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('vendor_gstin_field'),
                  controller: _gstinController,
                  decoration: InputDecoration(
                    labelText: AccountingStrings.gstinLabel,
                    errorText: state.gstinError,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: cubit.gstinChanged,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  key: const Key('vendor_active_switch'),
                  title: const Text(AccountingStrings.isActiveLabel),
                  value: state.isActive,
                  onChanged: cubit.isActiveChanged,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key('vendor_save_button'),
                  onPressed: state.isSubmitting ? null : () => cubit.submit(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          AccountingStrings.save,
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
