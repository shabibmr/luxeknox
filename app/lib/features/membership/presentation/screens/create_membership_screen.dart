import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../people/presentation/widgets/member_picker_sheet.dart';
import '../../domain/entities/membership_replacement_preview.dart';
import '../bloc/create_membership_bloc.dart';
import '../membership_strings.dart';

/// Admin sales flow — create a membership contract for a member (FR-MEMB sales).
class CreateMembershipScreen extends StatelessWidget {
  const CreateMembershipScreen({super.key, this.memberId});

  /// When set (e.g. from `/admin/members/:id/assign-membership`), member is fixed.
  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CreateMembershipBloc>()
            ..add(CreateMembershipStarted(memberId: memberId)),
      child: _CreateMembershipBody(memberId: memberId),
    );
  }
}

class _CreateMembershipBody extends StatelessWidget {
  const _CreateMembershipBody({this.memberId});

  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateMembershipBloc, CreateMembershipState>(
      listenWhen: (prev, next) =>
          (prev.created == null && next.created != null) ||
          (prev.partnerReplacement == null && next.partnerReplacement != null),
      listener: (context, state) {
        final id = state.created?.id;
        if (id != null) {
          context.go('${Routes.adminMemberships}/$id');
          return;
        }
        final preview = state.partnerReplacement;
        if (preview == null) return;
        if (preview.isCouple) {
          unawaited(_showPartnerAlreadyCoupleDialog(context));
        } else {
          unawaited(_showReplacePartnerDialog(context, state, preview));
        }
      },
      builder: (context, state) {
        final noProducts = state.products.isEmpty;
        return Scaffold(
          appBar: AppBar(title: const Text(MembershipStrings.createTitle)),
          body:
              noProducts &&
                  (state.status == LoadStatus.initial ||
                      state.status == LoadStatus.loading)
              ? const AppLoading()
              : noProducts && state.status == LoadStatus.failure
              ? AppErrorView(
                  message: state.failure == null
                      ? MembershipStrings.noneFound
                      : failureMessage(state.failure!),
                  onRetry: () => context.read<CreateMembershipBloc>().add(
                    CreateMembershipStarted(memberId: memberId),
                  ),
                )
              : _CreateMembershipForm(
                  state: state,
                  memberLocked: memberId != null,
                ),
        );
      },
    );
  }
}

const _shortMonths = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// `03 Nov`-style label without pulling in locale data (keeps widget tests light).
String _shortDayMonth(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  return '$day ${_shortMonths[date.month - 1]}';
}

Future<void> _showReplacePartnerDialog(
  BuildContext context,
  CreateMembershipState state,
  MembershipReplacementPreview preview,
) async {
  final partnerName =
      state.selectedPartner?.fullName ?? MembershipStrings.partnerFallbackName;
  final endDateLabel = _shortDayMonth(preview.endDate);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(MembershipStrings.replacePartnerTitle),
      content: Text(
        MembershipStrings.replacePartnerMessage(
          partnerName: partnerName,
          productName: preview.productName,
          endDateLabel: endDateLabel,
          remainingDays: preview.remainingDays,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(MembershipStrings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(MembershipStrings.confirm),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  context.read<CreateMembershipBloc>().add(
    CreateMembershipReplaceConfirmed(confirmed == true),
  );
}

Future<void> _showPartnerAlreadyCoupleDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(MembershipStrings.partnerAlreadyCoupleTitle),
      content: const Text(MembershipStrings.partnerAlreadyCouple),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text(MembershipStrings.confirm),
        ),
      ],
    ),
  );
  if (!context.mounted) return;
  context.read<CreateMembershipBloc>().add(
    const CreateMembershipReplaceConfirmed(false),
  );
}

class _CreateMembershipForm extends StatelessWidget {
  const _CreateMembershipForm({
    required this.state,
    required this.memberLocked,
  });

  final CreateMembershipState state;
  final bool memberLocked;

  Set<int> get _excludePartnerIds {
    final raw = state.selectedMemberId;
    if (raw == null || raw.isEmpty) return const {};
    final id = int.tryParse(raw);
    return id == null ? const {} : {id};
  }

  bool get _showCoupleSummary {
    if (!state.isCoupleSelected || state.selectedPartner == null) {
      return false;
    }
    if (state.checkingPartner) return false;
    final preview = state.partnerReplacement;
    if (preview == null) return true;
    if (preview.isCouple) return false;
    return state.replaceConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateMembershipBloc>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          MembershipStrings.createSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (!memberLocked) ...[
          MemberPickerField(
            selectedMember: state.selectedMember,
            selectedMemberId: state.selectedMemberId,
            selectedMemberName: state.selectedMember?.fullName,
            labelText: MembershipStrings.memberLabel,
            hintText: MembershipStrings.selectMemberHint,
            enabled: !state.submitting,
            onChanged: (member) {
              if (member != null) {
                bloc.add(CreateMembershipMemberSelected(member));
              }
            },
          ),
          const SizedBox(height: 16),
        ] else ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(MembershipStrings.memberLabel),
            subtitle: Text('Member #${state.selectedMemberId}'),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          MembershipStrings.packageLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: state.selectedProductId,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: MembershipStrings.selectPackageHint,
          ),
          items: state.products
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text('${p.name} · ${p.basePrice}'),
                ),
              )
              .toList(),
          onChanged: state.submitting
              ? null
              : (value) {
                  if (value != null) {
                    bloc.add(CreateMembershipProductSelected(value));
                  }
                },
        ),
        if (state.isCoupleSelected) ...[
          const SizedBox(height: 16),
          MemberPickerField(
            selectedMember: state.selectedPartner,
            selectedMemberId: state.selectedPartner?.id.toString(),
            selectedMemberName: state.selectedPartner?.fullName,
            labelText: MembershipStrings.partnerLabel,
            hintText: MembershipStrings.selectPartnerHint,
            enabled: !state.submitting && !state.checkingPartner,
            excludeMemberIds: _excludePartnerIds,
            onChanged: (member) {
              if (member != null) {
                bloc.add(CreateMembershipPartnerSelected(member));
              }
            },
          ),
          if (state.checkingPartner) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
        ],
        if (_showCoupleSummary) ...[
          const SizedBox(height: 16),
          _CouplePriceSummary(state: state),
        ],
        const SizedBox(height: 16),
        if (state.paymentMethods.isEmpty)
          Text(
            MembershipStrings.noPaymentMethods,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )
        else
          DropdownButtonFormField<String>(
            initialValue: state.selectedPaymentMethodId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: MembershipStrings.paymentMethodLabel,
              hintText: MembershipStrings.selectPaymentMethodHint,
            ),
            items: [
              for (final m in state.paymentMethods)
                DropdownMenuItem(value: m.id, child: Text(m.methodName)),
            ],
            onChanged: state.submitting
                ? null
                : (value) {
                    if (value != null) {
                      bloc.add(CreateMembershipPaymentMethodSelected(value));
                    }
                  },
          ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(MembershipStrings.startDateLabel),
          subtitle: Text(
            state.startDate?.toIso8601String().split('T').first ?? '—',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: state.submitting
                ? null
                : () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.startDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      bloc.add(CreateMembershipStartDateChanged(picked));
                    }
                  },
          ),
        ),
        TextFormField(
          initialValue: state.lockerNumber,
          decoration: const InputDecoration(
            labelText: MembershipStrings.lockerNumberLabel,
            border: OutlineInputBorder(),
          ),
          enabled: !state.submitting,
          onChanged: (value) => bloc.add(CreateMembershipLockerChanged(value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(MembershipStrings.autoRenewLabel),
          value: state.autoRenew,
          onChanged: state.submitting
              ? null
              : (value) => bloc.add(CreateMembershipAutoRenewChanged(value)),
        ),
        if (state.failure != null) ...[
          const SizedBox(height: 8),
          Text(
            failureMessage(state.failure!),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (state.fieldError != null) ...[
          const SizedBox(height: 8),
          Text(
            state.fieldError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (state.submitError != null) ...[
          const SizedBox(height: 8),
          Text(
            state.submitError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: state.submitting
              ? null
              : () => bloc.add(const CreateMembershipSubmitted()),
          child: state.submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(MembershipStrings.createSubmit),
        ),
      ],
    );
  }
}

class _CouplePriceSummary extends StatefulWidget {
  const _CouplePriceSummary({required this.state});

  final CreateMembershipState state;

  @override
  State<_CouplePriceSummary> createState() => _CouplePriceSummaryState();
}

class _CouplePriceSummaryState extends State<_CouplePriceSummary> {
  late final TextEditingController _discountController;
  var _syncingFromState = false;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(
      text: widget.state.discountAmount ?? '',
    )..addListener(_onDiscountEdited);
  }

  @override
  void didUpdateWidget(covariant _CouplePriceSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.state.discountAmount ?? '';
    if (_discountController.text != next) {
      _syncingFromState = true;
      _discountController.text = next;
      _syncingFromState = false;
    }
  }

  @override
  void dispose() {
    _discountController
      ..removeListener(_onDiscountEdited)
      ..dispose();
    super.dispose();
  }

  void _onDiscountEdited() {
    if (_syncingFromState || !mounted) return;
    context.read<CreateMembershipBloc>().add(
      CreateMembershipDiscountChanged(_discountController.text),
    );
  }

  String get _totalLabel {
    final price = double.tryParse(
      widget.state.selectedProduct?.basePrice ?? '',
    );
    final discount = double.tryParse(widget.state.discountAmount ?? '0') ?? 0;
    if (price == null) return '—';
    final total = (price - discount).clamp(0, double.infinity);
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = widget.state.selectedProduct?.basePrice ?? '—';
    final showDiscount = widget.state.partnerReplacement != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  MembershipStrings.packagePriceLabel,
                  style: theme.textTheme.titleSmall,
                ),
                Text(price, style: theme.textTheme.titleSmall),
              ],
            ),
            if (showDiscount) ...[
              const SizedBox(height: 12),
              AppCurrencyField(
                controller: _discountController,
                label: MembershipStrings.discountForRemainingDays,
                enabled: !widget.state.submitting,
                required: false,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  MembershipStrings.totalDueLabel,
                  style: theme.textTheme.titleMedium,
                ),
                Text(_totalLabel, style: theme.textTheme.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
