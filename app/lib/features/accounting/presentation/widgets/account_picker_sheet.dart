import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/account.dart';
import '../accounting_strings.dart';
import '../cubit/accounts_cubit.dart';

/// Shows a modal bottom sheet allowing the user to search and select an [Account].
///
/// When [activeOnly] is true (default for new documents), inactive accounts
/// are excluded so only active accounts can be picked.
/// When [activeOnly] is false, inactive accounts are shown disabled with an
/// "Inactive" badge and cannot be selected.
Future<Account?> showAccountPickerSheet(
  BuildContext context, {
  bool activeOnly = true,
  String? accountType,
  AccountsCubit? cubit,
}) {
  return showModalBottomSheet<Account>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => AccountPickerSheet(
      activeOnly: activeOnly,
      accountType: accountType,
      cubit: cubit,
    ),
  );
}

/// Bottom sheet widget for picking an [Account].
class AccountPickerSheet extends StatelessWidget {
  const AccountPickerSheet({
    super.key,
    this.activeOnly = true,
    this.accountType,
    this.cubit,
  });

  final bool activeOnly;
  final String? accountType;
  final AccountsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      if (cubit!.state.status == LoadStatus.initial) {
        cubit!.load(
          accountType: accountType,
          isActive: activeOnly ? true : null,
        );
      }
      return BlocProvider<AccountsCubit>.value(
        value: cubit!,
        child: _AccountPickerView(
          activeOnly: activeOnly,
          accountType: accountType,
        ),
      );
    }
    return BlocProvider<AccountsCubit>(
      create: (_) => getIt<AccountsCubit>()
        ..load(
          accountType: accountType,
          isActive: activeOnly ? true : null,
        ),
      child: _AccountPickerView(
        activeOnly: activeOnly,
        accountType: accountType,
      ),
    );
  }
}

class _AccountPickerView extends StatefulWidget {
  const _AccountPickerView({
    required this.activeOnly,
    this.accountType,
  });

  final bool activeOnly;
  final String? accountType;

  @override
  State<_AccountPickerView> createState() => _AccountPickerViewState();
}

class _AccountPickerViewState extends State<_AccountPickerView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<AccountsCubit>().setSearch(
      query.trim().isEmpty ? null : query.trim(),
    );
  }

  void _onRetry() {
    context.read<AccountsCubit>().load(
      accountType: widget.accountType,
      isActive: widget.activeOnly ? true : null,
      search: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
    );
  }

  List<Account> _visibleAccounts(List<Account> accounts) {
    if (widget.activeOnly) {
      return accounts.where((a) => a.isActive).toList();
    }
    return accounts;
  }

  static Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'asset':
        return Colors.blue;
      case 'liability':
        return Colors.orange;
      case 'equity':
        return Colors.purple;
      case 'income':
        return Colors.teal;
      case 'expense':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  static String _formatType(String type) {
    if (type.isEmpty) return type;
    return type[0].toUpperCase() + type.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsCubit, AccountsState>(
      builder: (context, state) {
        final visible = _visibleAccounts(state.accounts);

        return AppPickerSheet<Account>(
          searchController: _searchController,
          searchLabel: AccountingStrings.searchAccounts,
          searchFieldKey: const Key('account_picker_search_field'),
          onSearchChanged: _onSearchChanged,
          onSearchSubmitted: _onSearchChanged,
          isLoading:
              state.status == LoadStatus.loading && state.accounts.isEmpty,
          items: visible,
          errorMessage:
              state.status == LoadStatus.failure && state.accounts.isEmpty
                  ? (state.failure == null ? '' : failureMessage(state.failure!))
                  : null,
          onRetry: _onRetry,
          emptyMessage: AccountingStrings.noneFound,
          retryLabel: AccountingStrings.retry,
          itemBuilder: (context, account) {
            final isSelectable = account.isActive;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isSelectable
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text(AccountingStrings.cannotPickDeactivated),
                        ),
                      );
                    },
              child: ListTile(
                enabled: isSelectable,
                title: Text(
                  account.name,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AppStatusChip(
                        label: _formatType(account.type),
                        color: _typeColor(account.type),
                      ),
                      if (account.isBank)
                        const AppStatusChip(
                          icon: Icons.account_balance,
                          label: 'Bank',
                          color: Colors.teal,
                        ),
                      if (account.isControl)
                        const AppStatusChip(
                          icon: Icons.lock_outline,
                          label: 'Control',
                          color: Colors.deepPurple,
                        ),
                      AppStatusChip(
                        label: account.isActive
                            ? AccountingStrings.activeBadge
                            : AccountingStrings.inactiveBadge,
                        color: account.isActive ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ),
                onTap: isSelectable
                    ? () => Navigator.of(context).pop(account)
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              AccountingStrings.cannotPickDeactivated,
                            ),
                          ),
                        );
                      },
              ),
            );
          },
        );
      },
    );
  }
}

/// A form field widget for selecting an [Account] via bottom sheet picker.
class AccountPickerField extends StatelessWidget {
  const AccountPickerField({
    super.key,
    this.value,
    this.onChanged,
    this.activeOnly = true,
    this.accountType,
    this.labelText = AccountingStrings.selectAccount,
    this.hintText = AccountingStrings.selectAccount,
    this.errorText,
    this.enabled = true,
    this.allowClear = true,
    this.fieldKey,
    this.cubit,
  });

  final Account? value;
  final ValueChanged<Account?>? onChanged;
  final bool activeOnly;
  final String? accountType;
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool enabled;
  final bool allowClear;
  final Key? fieldKey;
  final AccountsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<Account>(
      fieldKey: fieldKey,
      value: value,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
      allowClear: allowClear,
      labelBuilder: (account) => account.name,
      onPick: (ctx) => showAccountPickerSheet(
        ctx,
        activeOnly: activeOnly,
        accountType: accountType,
        cubit: cubit,
      ),
      onChanged: onChanged ?? (_) {},
    );
  }
}
