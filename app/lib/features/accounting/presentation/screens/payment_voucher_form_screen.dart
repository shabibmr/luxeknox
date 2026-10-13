import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../domain/usecases/create_payment_voucher_usecase.dart';
import '../accounting_strings.dart';
import '../cubit/payment_voucher_form_cubit.dart';
import '../widgets/account_picker_sheet.dart';

class PaymentVoucherFormScreen extends StatelessWidget {
  const PaymentVoucherFormScreen({
    super.key,
    this.cubit,
  });

  final PaymentVoucherFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (!context.can('accounting.payments_write')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AccountingStrings.createPaymentVoucherTitle),
        ),
        body: const Center(
          child: Text(AccountingStrings.noPermission),
        ),
      );
    }

    if (cubit != null) {
      return BlocProvider<PaymentVoucherFormCubit>.value(
        value: cubit!,
        child: const _PaymentVoucherFormView(),
      );
    }

    return BlocProvider<PaymentVoucherFormCubit>(
      create: (_) => getIt.isRegistered<PaymentVoucherFormCubit>()
          ? getIt<PaymentVoucherFormCubit>()
          : PaymentVoucherFormCubit(getIt<CreatePaymentVoucherUseCase>()),
      child: const _PaymentVoucherFormView(),
    );
  }
}

class _PaymentVoucherFormView extends StatefulWidget {
  const _PaymentVoucherFormView();

  @override
  State<_PaymentVoucherFormView> createState() =>
      _PaymentVoucherFormViewState();
}

class _PaymentVoucherFormViewState extends State<_PaymentVoucherFormView> {
  final _memoController = TextEditingController();
  final _totalAmountController = TextEditingController();

  @override
  void dispose() {
    _memoController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentVoucherFormCubit, PaymentVoucherFormState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == LoadStatus.success ||
              current.status == LoadStatus.failure),
      listener: (context, state) {
        if (state.status == LoadStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AccountingStrings.voucherCreatedSuccess),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(state.createdVoucher);
          } else if (state.createdVoucher != null) {
            try {
              context.pushReplacement(
                Routes.adminAccountingPaymentVoucherById(
                    state.createdVoucher!.id),
              );
            } catch (_) {}
          }
        } else if (state.status == LoadStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failureMessage(state.failure!)),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AccountingStrings.createPaymentVoucherTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Payment Date Picker
                InkWell(
                  key: const Key('payment_date_picker'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.paymentDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && context.mounted) {
                      context
                          .read<PaymentVoucherFormCubit>()
                          .setPaymentDate(picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: AccountingStrings.paymentDateLabel,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(_formatDate(state.paymentDate)),
                  ),
                ),
                const SizedBox(height: 16),

                // Bank Account Selector
                AccountPickerField(
                  fieldKey: const Key('bank_account_picker'),
                  labelText: AccountingStrings.bankAccountLabel,
                  value: state.bankAccount,
                  onChanged: (account) {
                    context
                        .read<PaymentVoucherFormCubit>()
                        .setBankAccount(account);
                  },
                ),
                const SizedBox(height: 16),

                // Total Amount
                TextFormField(
                  key: const Key('total_amount_field'),
                  controller: _totalAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.totalAmountLabel,
                    prefixText: '\$ ',
                  ),
                  onChanged: (val) {
                    context
                        .read<PaymentVoucherFormCubit>()
                        .setTotalAmount(val.trim());
                  },
                ),
                const SizedBox(height: 16),

                // Memo
                TextFormField(
                  key: const Key('memo_field'),
                  controller: _memoController,
                  decoration: const InputDecoration(
                    labelText: AccountingStrings.memoLabel,
                  ),
                  onChanged: (val) {
                    context.read<PaymentVoucherFormCubit>().setMemo(
                          val.trim().isEmpty ? null : val.trim(),
                        );
                  },
                ),
                const SizedBox(height: 24),

                // Allocations Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AccountingStrings.allocationsLabel} (${state.allocations.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      key: const Key('add_allocation_button'),
                      icon: const Icon(Icons.add),
                      label: const Text(AccountingStrings.addAllocation),
                      onPressed: () => context
                          .read<PaymentVoucherFormCubit>()
                          .addAllocation(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Allocations List
                for (int i = 0; i < state.allocations.length; i++)
                  _AllocationCard(
                    index: i,
                    allocation: state.allocations[i],
                    canRemove: state.allocations.length > 1,
                  ),

                const SizedBox(height: 12),

                // Allocation Sum Mismatch Warning
                if (state.hasAllocationMismatch)
                  Container(
                    key: const Key('allocations_sum_mismatch_warning'),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AccountingStrings.allocationsSumMismatch,
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Allocations Preview Summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AccountingStrings.allocationAmountLabel,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              AccountingStrings.formatAmount(
                                  state.allocationsSum),
                              key: const Key('allocations_sum_text'),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              AccountingStrings.totalAmountLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              AccountingStrings.formatAmount(
                                  state.parsedTotalAmount),
                              key: const Key('total_amount_preview_text'),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                FilledButton(
                  key: const Key('submit_voucher_button'),
                  onPressed: state.canSubmit
                      ? () =>
                          context.read<PaymentVoucherFormCubit>().submit()
                      : null,
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AccountingStrings.create),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({
    required this.index,
    required this.allocation,
    required this.canRemove,
  });

  final int index;
  final PaymentVoucherAllocationDraft allocation;
  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Allocation #${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (canRemove)
                  IconButton(
                    key: Key('remove_allocation_button_$index'),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => context
                        .read<PaymentVoucherFormCubit>()
                        .removeAllocation(index),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    key: Key('allocation_type_field_$index'),
                    initialValue: allocation.targetType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'bill',
                        child: Text(AccountingStrings.allocationTypeBill),
                      ),
                      DropdownMenuItem(
                        value: 'expense',
                        child: Text(AccountingStrings.allocationTypeExpense),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        context
                            .read<PaymentVoucherFormCubit>()
                            .updateAllocation(index, targetType: val);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    key: Key('allocation_target_id_field_$index'),
                    initialValue: allocation.targetId,
                    decoration: const InputDecoration(
                      labelText: 'Target ID / #',
                    ),
                    onChanged: (val) {
                      context.read<PaymentVoucherFormCubit>().updateAllocation(
                            index,
                            targetId: val.trim(),
                          );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: Key('allocation_amount_field_$index'),
              initialValue: allocation.amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: AccountingStrings.amountLabel,
                prefixText: '\$ ',
              ),
              onChanged: (amt) {
                context
                    .read<PaymentVoucherFormCubit>()
                    .updateAllocation(index, amount: amt.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}
