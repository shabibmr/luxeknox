import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../domain/entities/go_live.dart';
import '../accounting_strings.dart';
import '../cubit/go_live_cubit.dart';
import '../widgets/account_picker_sheet.dart';

class GoLiveScreen extends StatelessWidget {
  const GoLiveScreen({super.key, this.cubit});

  final GoLiveCubit? cubit;

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider<GoLiveCubit>.value(
        value: cubit!,
        child: const _GoLiveScaffold(),
      );
    }
    return BlocProvider<GoLiveCubit>(
      create: (_) => getIt<GoLiveCubit>()..load(),
      child: const _GoLiveScaffold(),
    );
  }
}

class _GoLiveScaffold extends StatefulWidget {
  const _GoLiveScaffold();

  @override
  State<_GoLiveScaffold> createState() => _GoLiveScaffoldState();
}

class _GoLiveScaffoldState extends State<_GoLiveScaffold> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<GoLiveCubit>();
    if (cubit.state.status == LoadStatus.initial) {
      cubit.load();
    }
  }

  bool _hasPostingTogglePermission() {
    if (getIt.isRegistered<SessionCubit>()) {
      final session = getIt<SessionCubit>().state;
      if (session is SessionAuthenticated) {
        return session.capabilities.can('accounting.posting_toggle');
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AccountingStrings.goLiveTitle),
        actions: [
          IconButton(
            tooltip: AccountingStrings.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<GoLiveCubit>().load(),
          ),
        ],
      ),
      body: BlocConsumer<GoLiveCubit, GoLiveState>(
        listener: (context, state) {
          if (state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failureMessage(state.failure!)),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == LoadStatus.loading && state.checklist == null) {
            return const Center(child: AppLoading());
          }

          if (state.status == LoadStatus.failure && state.checklist == null) {
            return Center(
              child: AppErrorView(
                message: state.failure != null
                    ? failureMessage(state.failure!)
                    : 'Failed to load Go-Live checklist.',
                onRetry: () => context.read<GoLiveCubit>().load(),
              ),
            );
          }

          final checklist = state.checklist;
          if (checklist == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<GoLiveCubit>().load(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DatePickerCard(
                    selectedDate: state.selectedDate,
                    onDateChanged: (date) =>
                        context.read<GoLiveCubit>().changeDate(date),
                  ),
                  const SizedBox(height: 16),
                  _PaymentMethodMappingCard(
                    checklist: checklist,
                    isActionInProgress: state.isActionInProgress,
                  ),
                  const SizedBox(height: 16),
                  _OpeningBalanceComparisonCard(
                    checklist: checklist,
                  ),
                  const SizedBox(height: 16),
                  _ReadinessCard(
                    checklist: checklist,
                  ),
                  const SizedBox(height: 16),
                  _EnablePostingCard(
                    checklist: checklist,
                    isActionInProgress: state.isActionInProgress,
                    hasPermission: _hasPostingTogglePermission(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DatePickerCard extends StatelessWidget {
  const _DatePickerCard({
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.calendar_today,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AccountingStrings.goLiveDateLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(selectedDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_calendar, size: 18),
              label: const Text(AccountingStrings.changeDateLabel),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                );
                if (picked != null) {
                  onDateChanged(picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodMappingCard extends StatelessWidget {
  const _PaymentMethodMappingCard({
    required this.checklist,
    required this.isActionInProgress,
  });

  final GoLiveChecklist checklist;
  final bool isActionInProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeMethods =
        checklist.paymentMethods.where((m) => m.isActive).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AccountingStrings.paymentMethodMappingsTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AccountingStrings.paymentMethodMappingsSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (activeMethods.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  AccountingStrings.noneFound,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeMethods.length,
                separatorBuilder: (_, _) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final method = activeMethods[index];
                  final isMapped = method.accountId != null;

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          method.isDigital
                              ? Icons.credit_card
                              : Icons.payments_outlined,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.methodName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (isMapped)
                              Text(
                                method.accountCode != null
                                    ? '${method.accountCode} - ${method.accountName ?? ''}'
                                    : 'Account #${method.accountId}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            else
                              Text(
                                AccountingStrings.unmappedAccount,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      AppStatusChip(
                        label: isMapped
                            ? (method.accountCode ?? AccountingStrings.matchedBadge)
                            : AccountingStrings.unmappedAccount,
                        color: isMapped ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        key: Key('map_account_btn_${method.id}'),
                        onPressed: isActionInProgress
                            ? null
                            : () async {
                                final picked = await showAccountPickerSheet(
                                  context,
                                  activeOnly: true,
                                );
                                if (picked != null && context.mounted) {
                                  final accountId = int.tryParse(picked.id);
                                  context
                                      .read<GoLiveCubit>()
                                      .mapPaymentMethod(method.id, accountId);
                                }
                              },
                        child: Text(
                          isMapped
                              ? AccountingStrings.changeAccount
                              : AccountingStrings.mapAccount,
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _OpeningBalanceComparisonCard extends StatelessWidget {
  const _OpeningBalanceComparisonCard({
    required this.checklist,
  });

  final GoLiveChecklist checklist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.compare_arrows,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AccountingStrings.unearnedComparisonTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _ComparisonRow(
              accountLabel: AccountingStrings.unearnedMembershipAccountLabel,
              expectedAmount: checklist.membershipUnearned.preview,
              actualAmount: checklist.openingJournalFound
                  ? checklist.membershipUnearned.actual
                  : null,
              isMatched: checklist.membershipUnearned.isMatched,
              hasOpeningJournal: checklist.openingJournalFound,
            ),
            const Divider(height: 24),
            _ComparisonRow(
              accountLabel: AccountingStrings.unearnedPtAccountLabel,
              expectedAmount: checklist.ptUnearned.preview,
              actualAmount: checklist.openingJournalFound
                  ? checklist.ptUnearned.actual
                  : null,
              isMatched: checklist.ptUnearned.isMatched,
              hasOpeningJournal: checklist.openingJournalFound,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.accountLabel,
    required this.expectedAmount,
    required this.actualAmount,
    required this.isMatched,
    required this.hasOpeningJournal,
  });

  final String accountLabel;
  final String expectedAmount;
  final String? actualAmount;
  final bool isMatched;
  final bool hasOpeningJournal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String statusLabel;
    final Color statusColor;

    if (!hasOpeningJournal) {
      statusLabel = AccountingStrings.openingJournalMissing;
      statusColor = Colors.orange;
    } else if (isMatched) {
      statusLabel = AccountingStrings.matchedBadge;
      statusColor = Colors.green;
    } else {
      statusLabel = AccountingStrings.mismatchBadge;
      statusColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              accountLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppStatusChip(
              label: statusLabel,
              color: statusColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AccountingStrings.expectedPreviewLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AccountingStrings.formatMoney(expectedAmount),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AccountingStrings.actualOpeningLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    actualAmount != null
                        ? AccountingStrings.formatMoney(actualAmount!)
                        : '--',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({
    required this.checklist,
  });

  final GoLiveChecklist checklist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFailingChecks = checklist.failingReasons.isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hasFailingChecks
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : Colors.green.shade300,
        ),
      ),
      color: hasFailingChecks
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.1)
          : Colors.green.shade50.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasFailingChecks
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline,
                  color: hasFailingChecks ? theme.colorScheme.error : Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AccountingStrings.readinessTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: hasFailingChecks
                          ? theme.colorScheme.error
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (hasFailingChecks) ...[
              Text(
                AccountingStrings.prerequisitesNotMet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              ...checklist.failingReasons.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.value,
                          key: Key('failing_check_${entry.key}'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AccountingStrings.allPrerequisitesMet,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EnablePostingCard extends StatelessWidget {
  const _EnablePostingCard({
    required this.checklist,
    required this.isActionInProgress,
    required this.hasPermission,
  });

  final GoLiveChecklist checklist;
  final bool isActionInProgress;
  final bool hasPermission;

  void _showConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AccountingStrings.confirmGoLiveTitle),
          content: const Text(AccountingStrings.enablePostingConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AccountingStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<GoLiveCubit>().enablePosting();
              },
              child: const Text(AccountingStrings.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // CRITICAL: The enable action is hidden without accounting.posting_toggle.
    if (!hasPermission) {
      return const SizedBox.shrink();
    }

    if (checklist.isPostingEnabled) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green.shade300),
        ),
        color: Colors.green.shade50.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AccountingStrings.postingAlreadyEnabled,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              const AppStatusChip(
                label: AccountingStrings.activeBadge,
                color: Colors.green,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              key: const Key('enable_posting_btn'),
              icon: isActionInProgress
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.rocket_launch),
              label: const Text(AccountingStrings.enableAutomaticPosting),
              onPressed: (checklist.canEnable && !isActionInProgress)
                  ? () => _showConfirmDialog(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
