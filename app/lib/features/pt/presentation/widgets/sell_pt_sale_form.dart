import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/package_grid_picker_field.dart';
import '../../../people/domain/entities/person.dart';
import '../../../people/domain/entities/profile_summary.dart';
import '../../../people/presentation/member_dossier_pt.dart'
    show formatCalendarDate;
import '../../../people/presentation/widgets/member_picker_sheet.dart';
import '../../domain/entities/pt_schedule_grid.dart';
import '../cubit/sell_pt_cubit.dart';
import '../pt_strings.dart';
import 'pt_schedule_grid_section.dart';

/// New PT sale: package, couple partner, start date, weekdays, schedule, pay.
class SellPtSaleForm extends StatelessWidget {
  const SellPtSaleForm({super.key, required this.state, required this.onBack});

  final SellPtState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    final theme = Theme.of(context);
    final product = state.product;
    final displayName =
        state.memberName ??
        state.member?.fullName ??
        'Member #${state.memberId}';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _MemberBanner(state: state, displayName: displayName),
        Text(PtStrings.stepPackage, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        PackageGridPickerField<int>(
          value: product?.id,
          labelText: PtStrings.summaryPackage,
          options: [
            for (final p in state.products)
              PackageGridOption(
                value: p.id,
                title: p.name,
                subtitle: '${p.durationDays} days · ${p.basePrice}',
                isCouple: p.isCouple,
              ),
          ],
          onChanged: (id) =>
              cubit.selectProduct(state.products.firstWhere((x) => x.id == id)),
        ),
        if (state.isCoupleSelected) ...[
          const SizedBox(height: 16),
          MemberPickerField(
            selectedMemberId: state.partner?.id.toString(),
            selectedMemberName: state.partner?.fullName,
            labelText: PtStrings.partnerLabel,
            hintText: PtStrings.partnerHint,
            enabled:
                !state.submitting &&
                state.partnerCheck is! SellPtPartnerCheckLoading,
            excludeMemberIds: {state.memberId},
            onChanged: (summary) =>
                cubit.selectPartner(_personFromSummary(summary)),
          ),
          if (state.partnerCheck is SellPtPartnerCheckLoading) ...[
            const SizedBox(height: 8),
            Text(PtStrings.partnerChecking, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            const LinearProgressIndicator(),
          ],
          if (state.partnerCheck case final SellPtPartnerCheckBlocked blocked)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                blocked.message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PtStrings.startDate),
          subtitle: Text(
            state.startDate == null
                ? '—'
                : formatCalendarDate(state.startDate!),
          ),
          trailing: const Icon(Icons.calendar_today_outlined),
          onTap: () async {
            final now = DateTime.now();
            final first = DateTime(now.year, now.month, now.day);
            final end = first.add(const Duration(days: 365));
            // showDatePicker asserts first <= initial <= last.
            final last = end.isBefore(first) ? first : end;
            final current = state.startDate ?? first;
            final initial = current.isBefore(first)
                ? first
                : (current.isAfter(last) ? last : current);
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: first,
              lastDate: last,
            );
            if (picked != null) cubit.setStartDate(picked);
          },
        ),
        const Divider(height: 32),
        _Weekdays(state: state),
        const Divider(height: 32),
        PtScheduleGridSection(state: state),
        const Divider(height: 32),
        Text(PtStrings.stepPay, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (state.paymentMethods.isEmpty)
          Text(
            PtStrings.noPaymentMethods,
            style: TextStyle(color: theme.colorScheme.error),
          )
        else
          DropdownButtonFormField<String>(
            initialValue: state.paymentMethodId,
            decoration: const InputDecoration(
              labelText: PtStrings.paymentMethod,
            ),
            items: [
              for (final m in state.paymentMethods)
                DropdownMenuItem(value: m.id, child: Text(m.methodName)),
            ],
            onChanged: cubit.setPaymentMethod,
          ),
        TextFormField(
          decoration: const InputDecoration(labelText: PtStrings.discount),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: cubit.setDiscount,
        ),
        const SizedBox(height: 16),
        _Summary(state: state),
        const SizedBox(height: 16),
        _Actions(
          state: state,
          onBack: onBack,
          confirmLabel: PtStrings.confirmSell,
        ),
      ],
    );
  }
}

class _MemberBanner extends StatelessWidget {
  const _MemberBanner({required this.state, required this.displayName});

  final SellPtState state;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state.member != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Membership: ${state.member!.membershipNumber} · Gender: ${state.member!.gender ?? 'Not set'}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Weekdays extends StatelessWidget {
  const _Weekdays({required this.state});

  final SellPtState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    final theme = Theme.of(context);
    final product = state.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PtStrings.stepDays, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          product == null
              ? PtStrings.pickDaysHint
              : PtStrings.daysChosen(state.weekdays.length),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final d in const [1, 2, 3, 4, 5, 6, 0])
              FilterChip(
                label: Text(ptWeekdayShortNames[d]),
                selected: state.weekdays.contains(d),
                onSelected: product == null
                    ? null
                    : (_) => cubit.toggleWeekday(d),
              ),
          ],
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.state,
    required this.onBack,
    required this.confirmLabel,
  });

  final SellPtState state;
  final VoidCallback onBack;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBack,
            child: const Text(PtStrings.back),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: state.canSubmit ? cubit.submit : null,
            child: state.submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final SellPtState state;

  @override
  Widget build(BuildContext context) {
    if (!state.slotChosen || state.product == null) {
      return const SizedBox.shrink();
    }
    final trainer = state.grid?.trainers
        .where((t) => t.id == state.trainerId)
        .firstOrNull;
    final end = state.startDate!.add(
      Duration(days: state.product!.durationDays),
    );
    final memberName =
        state.memberName ??
        state.member?.fullName ??
        'Member #${state.memberId}';

    Widget row(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(k, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
    Widget note(String text) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              PtStrings.stepConfirm,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            row('Member', memberName),
            row(PtStrings.summaryPackage, state.product!.name),
            row(
              PtStrings.summaryPeriod,
              '${formatCalendarDate(state.startDate!)} → ${formatCalendarDate(end)}',
            ),
            row(PtStrings.summaryDays, ptWeekdaysLabel(state.weekdays)),
            row(PtStrings.summaryHour, ptHourLabel(state.slotStart!)),
            row(PtStrings.summaryTrainer, trainer?.name ?? '—'),
            row(PtStrings.summaryAmount, state.product!.basePrice),
            if (!state.isReplan && state.preview != null) ...[
              if (state.preview!.discount != '0.00')
                row(PtStrings.summaryDiscount, state.preview!.discount),
              row(PtStrings.summaryTax, state.preview!.tax),
              row(PtStrings.summaryTotal, state.preview!.total),
            ],
            if (state.product!.isCouple) note(PtStrings.coupleTotalNote),
            note(
              state.product!.isCouple
                  ? PtStrings.membershipIncludedCouple
                  : PtStrings.membershipIncluded,
            ),
          ],
        ),
      ),
    );
  }
}

Person? _personFromSummary(ProfileSummary? summary) {
  if (summary == null) return null;
  final parts = summary.fullName.trim().split(RegExp(r'\s+'));
  final first = parts.isEmpty ? summary.fullName : parts.first;
  final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
  return Person(
    id: summary.id,
    userId: 0,
    membershipNumber: summary.membershipNumber,
    firstName: first,
    lastName: last,
  );
}
