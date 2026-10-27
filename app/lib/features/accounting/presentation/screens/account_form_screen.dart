import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/get_account_usecase.dart';
import '../accounting_strings.dart';
import '../cubit/account_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';

class AccountFormScreen extends StatelessWidget {
  const AccountFormScreen({
    super.key,
    this.accountId,
    this.account,
    this.cubit,
  });

  final String? accountId;
  final Account? account;
  final AccountFormCubit? cubit;

  bool get isEditing => accountId != null || account != null;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.accounts_write')) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing
                ? AccountingStrings.editAccountTitle
                : AccountingStrings.createAccountTitle,
          ),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    final formView = _AccountFormView(
      accountId: accountId,
      initialAccount: account,
      isEditing: isEditing,
    );

    if (cubit != null) {
      if (accountId != null && account == null) {
        cubit!.load(accountId!);
      }
      return BlocProvider<AccountFormCubit>.value(
        value: cubit!,
        child: formView,
      );
    }

    return BlocProvider<AccountFormCubit>(
      create: (_) {
        final c = getIt<AccountFormCubit>();
        if (accountId != null && account == null) {
          c.load(accountId!);
        }
        return c;
      },
      child: formView,
    );
  }
}

class _AccountFormView extends StatefulWidget {
  const _AccountFormView({
    this.accountId,
    this.initialAccount,
    required this.isEditing,
  });

  final String? accountId;
  final Account? initialAccount;
  final bool isEditing;

  @override
  State<_AccountFormView> createState() => _AccountFormViewState();
}

class _AccountFormViewState extends State<_AccountFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _controlRoleController;

  String? _parentId;
  Account? _parentAccount;
  String? _accountType;
  bool _isBank = false;
  bool _isControl = false;
  bool _isActive = true;

  Account? _loadedAccount;
  bool _initializedFromAccount = false;

  Account? get _currentAccount => widget.initialAccount ?? _loadedAccount;

  static const List<MapEntry<String, String>> _accountTypeOptions = [
    MapEntry('asset', AccountingStrings.accountTypeAsset),
    MapEntry('liability', AccountingStrings.accountTypeLiability),
    MapEntry('equity', AccountingStrings.accountTypeEquity),
    MapEntry('income', AccountingStrings.accountTypeIncome),
    MapEntry('expense', AccountingStrings.accountTypeExpense),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _controlRoleController = TextEditingController();

    if (widget.initialAccount != null) {
      _applyAccount(widget.initialAccount!);
    }
  }

  void _applyAccount(Account account) {
    _loadedAccount = account;
    _nameController.text = account.name;
    _accountType = account.type;
    _isBank = account.isBank;
    _isControl = account.isControl;
    _isActive = account.isActive;
    _parentId = account.parentId;
    _controlRoleController.text = account.description ?? '';
    _initializedFromAccount = true;

    if (account.parentId != null) {
      _parentAccount = Account(
        id: account.parentId!,
        name: 'Account #${account.parentId}',
        type: '',
        isBank: false,
        isControl: false,
        isActive: true,
      );
      _loadParentAccount(account.parentId!);
    }
  }

  Future<void> _loadParentAccount(String parentId) async {
    if (!getIt.isRegistered<GetAccountUseCase>()) return;
    final useCase = getIt<GetAccountUseCase>();
    final result = await useCase(GetAccountParams(id: parentId));
    result.fold(
      (_) {},
      (acc) {
        if (mounted && _parentId == parentId) {
          setState(() {
            _parentAccount = acc;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controlRoleController.dispose();
    super.dispose();
  }

  Future<void> _onActiveChanged(bool value) async {
    if (widget.isEditing && !value) {
      final isControlAccount = _currentAccount?.isControl ?? _isControl;
      if (isControlAccount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AccountingStrings.cannotDeactivateControl),
          ),
        );
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(AccountingStrings.deactivateAccount),
          content: const Text(AccountingStrings.deactivateAccountConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(AccountingStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(AccountingStrings.deactivateAccount),
            ),
          ],
        ),
      );

      if (confirmed == true && mounted) {
        setState(() => _isActive = false);
      }
    } else {
      setState(() => _isActive = value);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<AccountFormCubit>();
    final parentId = _parentId;

    bool success;
    if (widget.isEditing) {
      final id = widget.accountId ?? _currentAccount?.id;
      if (id == null) return;

      success = await cubit.update(
        id: id,
        name: _nameController.text.trim(),
        parentId: parentId,
        clearParentId: parentId == null,
        isActive: _isActive,
        isBank: _isBank,
      );
    } else {
      final controlRoleText = _controlRoleController.text.trim();
      final controlRole = controlRoleText.isEmpty ? null : controlRoleText;

      success = await cubit.create(
        name: _nameController.text.trim(),
        accountType: _accountType!,
        parentId: parentId,
        isActive: _isActive,
        isBank: _isBank,
        isControl: _isControl,
        controlRole: controlRole,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AccountingStrings.accountSavedSuccess),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      final failure = cubit.state.failure;
      final msg = failure != null
          ? failureMessage(failure)
          : 'Failed to save account';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountFormCubit, AccountFormState>(
      listener: (context, state) {
        if (!_initializedFromAccount &&
            widget.accountId != null &&
            widget.initialAccount == null &&
            state.account != null) {
          setState(() {
            _applyAccount(state.account!);
          });
        }
      },
      builder: (context, state) {
        final isLoadingInitial = widget.accountId != null &&
            widget.initialAccount == null &&
            !_initializedFromAccount &&
            state.status == LoadStatus.loading;

        if (isLoadingInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditing
                    ? AccountingStrings.editAccountTitle
                    : AccountingStrings.createAccountTitle,
              ),
            ),
            body: const AppLoading(),
          );
        }

        final isInitialLoadFailure = widget.accountId != null &&
            widget.initialAccount == null &&
            !_initializedFromAccount &&
            state.status == LoadStatus.failure;

        if (isInitialLoadFailure) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isEditing
                    ? AccountingStrings.editAccountTitle
                    : AccountingStrings.createAccountTitle,
              ),
            ),
            body: AppErrorView(
              message: state.failure != null
                  ? failureMessage(state.failure!)
                  : 'Failed to load account',
              onRetry: () =>
                  context.read<AccountFormCubit>().load(widget.accountId!),
            ),
          );
        }

        final isSubmitting = state.isSubmitting;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isEditing
                  ? AccountingStrings.editAccountTitle
                  : AccountingStrings.createAccountTitle,
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : _submit,
                child: Text(
                  widget.isEditing
                      ? AccountingStrings.save
                      : AccountingStrings.create,
                ),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.nameLabel,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AccountingStrings.nameRequired;
                    }
                    if (value.trim().length > 150) {
                      return 'Account name must not exceed 150 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _accountType,
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.typeLabel,
                  ),
                  items: _accountTypeOptions
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: widget.isEditing
                      ? null
                      : (val) => setState(() => _accountType = val),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AccountingStrings.typeRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AccountPickerField(
                  fieldKey: const Key('account_form_parent_id_field'),
                  value: _parentAccount,
                  labelText: AccountingStrings.parentAccountLabel,
                  hintText: AccountingStrings.selectAccount,
                  excludeAccountId: widget.accountId ?? _currentAccount?.id,
                  allowClear: true,
                  onChanged: (account) {
                    setState(() {
                      _parentAccount = account;
                      _parentId = account?.id;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(AccountingStrings.isBankLabel),
                  value: _isBank,
                  onChanged: (val) => setState(() => _isBank = val),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(AccountingStrings.isControlLabel),
                  value: _isControl,
                  onChanged: widget.isEditing
                      ? null
                      : (val) => setState(() => _isControl = val),
                ),
                if (_isControl) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controlRoleController,
                    decoration: const InputDecoration(
                      labelText: AccountingStrings.controlRoleLabel,
                    ),
                    enabled: !widget.isEditing,
                  ),
                ],
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(AccountingStrings.isActiveLabel),
                  value: _isActive,
                  onChanged: _onActiveChanged,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.isEditing
                              ? AccountingStrings.save
                              : AccountingStrings.create,
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
