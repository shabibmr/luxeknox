import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../accounting_strings.dart';
import '../cubit/fund_transfer_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';

class FundTransferFormScreen extends StatelessWidget {
  const FundTransferFormScreen({
    super.key,
    this.cubit,
  });

  final FundTransferFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.payments_write')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.createTransferTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      return BlocProvider<FundTransferFormCubit>.value(
        value: cubit!,
        child: const _FundTransferFormView(),
      );
    }

    return BlocProvider<FundTransferFormCubit>(
      create: (_) => getIt<FundTransferFormCubit>(),
      child: const _FundTransferFormView(),
    );
  }
}

class _FundTransferFormView extends StatefulWidget {
  const _FundTransferFormView();

  @override
  State<_FundTransferFormView> createState() => _FundTransferFormViewState();
}

class _FundTransferFormViewState extends State<_FundTransferFormView> {
  final _amountController = TextEditingController();
  final _feeAmountController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _feeAmountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDate(
      BuildContext context, FundTransferFormCubit cubit, DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      cubit.transferDateChanged(picked);
    }
  }

  Future<void> _pickFromAccount(
      BuildContext context, FundTransferFormCubit cubit) async {
    final account = await showAccountPickerSheet(context, activeOnly: true);
    if (account != null) {
      cubit.fromAccountSelected(account);
    }
  }

  Future<void> _pickToAccount(
      BuildContext context, FundTransferFormCubit cubit) async {
    final account = await showAccountPickerSheet(context, activeOnly: true);
    if (account != null) {
      cubit.toAccountSelected(account);
    }
  }

  Future<void> _pickFeeAccount(
      BuildContext context, FundTransferFormCubit cubit) async {
    final account = await showAccountPickerSheet(context, activeOnly: true);
    if (account != null) {
      cubit.feeAccountSelected(account);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FundTransferFormCubit, FundTransferFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.createdTransfer != current.createdTransfer ||
          (current.failure != null && previous.failure != current.failure),
      listener: (context, state) {
        if (state.status == LoadStatus.success &&
            state.createdTransfer != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.transferCreatedSuccess),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(state.createdTransfer);
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
        final cubit = context.read<FundTransferFormCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.createTransferTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transfer Date Picker
                InkWell(
                  key: const Key('transfer_date_picker'),
                  onTap: () => _pickDate(context, cubit, state.transferDate),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '${AccountingStrings.transferDateLabel} *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(_formatDate(state.transferDate)),
                  ),
                ),
                const SizedBox(height: 16),

                // From Account Picker
                InkWell(
                  key: const Key('from_account_picker'),
                  onTap: () => _pickFromAccount(context, cubit),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '${AccountingStrings.fromAccountLabel} *',
                      errorText: state.fromAccountError,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      state.fromAccount != null
                          ? state.fromAccount!.name
                          : (state.fromAccountId.isNotEmpty
                              ? '#${state.fromAccountId}'
                              : AccountingStrings.selectAccount),
                      style: TextStyle(
                        color: state.fromAccount != null ||
                                state.fromAccountId.isNotEmpty
                            ? null
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // To Account Picker
                InkWell(
                  key: const Key('to_account_picker'),
                  onTap: () => _pickToAccount(context, cubit),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '${AccountingStrings.toAccountLabel} *',
                      errorText: state.toAccountError,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      state.toAccount != null
                          ? state.toAccount!.name
                          : (state.toAccountId.isNotEmpty
                              ? '#${state.toAccountId}'
                              : AccountingStrings.selectAccount),
                      style: TextStyle(
                        color: state.toAccount != null ||
                                state.toAccountId.isNotEmpty
                            ? null
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Transfer Amount Field
                AppCurrencyField(
                  key: const Key('transfer_amount_field'),
                  controller: _amountController,
                  label: '${AccountingStrings.amountLabel} *',
                  errorText: state.amountError,
                  onChanged: cubit.amountChanged,
                ),
                const SizedBox(height: 16),

                // Fee Amount Field
                AppCurrencyField(
                  key: const Key('transfer_fee_amount_field'),
                  controller: _feeAmountController,
                  label: AccountingStrings.feeAmountLabel,
                  required: false,
                  errorText: state.feeAmountError,
                  helperText: 'Optional processing fee',
                  onChanged: cubit.feeAmountChanged,
                ),
                const SizedBox(height: 16),

                // Fee Account Picker
                InkWell(
                  key: const Key('fee_account_picker'),
                  onTap: () => _pickFeeAccount(context, cubit),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AccountingStrings.feeAccountLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: state.feeAccount != null ||
                              state.feeAccountId != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => cubit.feeAccountSelected(null),
                            )
                          : const Icon(Icons.arrow_drop_down),
                      helperText: 'Expense account for fee',
                    ),
                    child: Text(
                      state.feeAccount != null
                          ? state.feeAccount!.name
                          : (state.feeAccountId != null &&
                                  state.feeAccountId!.isNotEmpty
                              ? '#${state.feeAccountId}'
                              : AccountingStrings.none),
                      style: TextStyle(
                        color: state.feeAccount != null ||
                                (state.feeAccountId != null &&
                                    state.feeAccountId!.isNotEmpty)
                            ? null
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Memo Field
                TextFormField(
                  key: const Key('transfer_memo_field'),
                  controller: _memoController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.memoLabel,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: cubit.memoChanged,
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  key: const Key('transfer_submit_button'),
                  onPressed:
                      state.isSubmitting ? null : () => cubit.submit(),
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
