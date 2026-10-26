import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../people/presentation/member_dossier_pt.dart'
    show formatCalendarDate;
import '../../domain/entities/pt_schedule_grid.dart';
import '../../domain/entities/pt_subscription.dart';
import '../cubit/sell_pt_cubit.dart';
import '../pt_strings.dart';
import 'pt_schedule_grid_section.dart';

/// Trainer or slot change on an existing PT. No package, partner, or payment.
class SellPtReplanForm extends StatelessWidget {
  const SellPtReplanForm({
    super.key,
    required this.state,
    required this.onBack,
  });

  final SellPtState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    final theme = Theme.of(context);
    final product = state.product;
    final subscription = state.replanning!;
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
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(subscription.productName),
          subtitle: Text(
            '${formatCalendarDate(subscription.startDate)} → ${formatCalendarDate(subscription.endDate)}',
          ),
        ),
        if (subscription.isCouple) ...[
          const SizedBox(height: 8),
          Text(
            PtStrings.replanCoupleNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PtStrings.effectiveFrom),
          subtitle: Text(
            state.startDate == null
                ? '—'
                : formatCalendarDate(state.startDate!),
          ),
          trailing: const Icon(Icons.calendar_today_outlined),
          onTap: () async {
            final now = DateTime.now();
            final first = DateTime(now.year, now.month, now.day);
            final end = subscription.endDate;
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
        _Weekdays(state: state, productReady: product != null),
        const Divider(height: 32),
        PtScheduleGridSection(state: state),
        const Divider(height: 32),
        TextFormField(
          decoration: const InputDecoration(labelText: PtStrings.reason),
          onChanged: cubit.setReason,
        ),
        const SizedBox(height: 16),
        _Summary(state: state, subscription: subscription),
        const SizedBox(height: 16),
        _Actions(state: state, onBack: onBack),
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
  const _Weekdays({required this.state, required this.productReady});

  final SellPtState state;
  final bool productReady;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PtStrings.stepDays, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          productReady
              ? PtStrings.daysChosen(state.weekdays.length)
              : PtStrings.pickDaysHint,
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
                onSelected: productReady ? (_) => cubit.toggleWeekday(d) : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.state, required this.onBack});

  final SellPtState state;
  final VoidCallback onBack;

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
                : const Text(PtStrings.confirmReplan),
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.state, required this.subscription});

  final SellPtState state;
  final PtSubscription subscription;

  @override
  Widget build(BuildContext context) {
    if (!state.slotChosen || state.product == null) {
      return const SizedBox.shrink();
    }
    final trainer = state.grid?.trainers
        .where((t) => t.id == state.trainerId)
        .firstOrNull;
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
              '${formatCalendarDate(state.startDate!)} → ${formatCalendarDate(subscription.endDate)}',
            ),
            row(PtStrings.summaryDays, ptWeekdaysLabel(state.weekdays)),
            row(PtStrings.summaryHour, ptHourLabel(state.slotStart!)),
            row(PtStrings.summaryTrainer, trainer?.name ?? '—'),
          ],
        ),
      ),
    );
  }
}
