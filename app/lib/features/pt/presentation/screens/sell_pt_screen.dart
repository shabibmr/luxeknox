import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../people/presentation/member_dossier_pt.dart' show formatCalendarDate;
import '../../domain/entities/pt_product.dart';
import '../../domain/entities/pt_schedule_grid.dart';
import '../../domain/entities/pt_subscription.dart';
import '../cubit/sell_pt_cubit.dart';
import '../pt_strings.dart';
import '../widgets/pt_schedule_grid_view.dart';

/// "Add Personal Training" for a member: package → days → trainer/hour → pay.
/// With [replanning] set, the same screen changes trainer and/or slot of an
/// existing PT from an effective date (no payment).
class SellPtScreen extends StatelessWidget {
  const SellPtScreen({super.key, required this.memberId, this.replanning, this.products});

  final int memberId;
  final PtSubscription? replanning;
  final List<PtProduct>? products;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<SellPtCubit>();
        if (replanning != null && products != null) {
          cubit.initReplan(replanning!, products!);
        } else {
          cubit.init(memberId);
        }
        return cubit;
      },
      child: const _SellPtView(),
    );
  }
}

class _SellPtView extends StatelessWidget {
  const _SellPtView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellPtCubit, SellPtState>(
      listenWhen: (a, b) => a.result != b.result || a.failure != b.failure,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.result != null) {
          messenger.showSnackBar(
            SnackBar(content: Text(state.isReplan ? PtStrings.replanned : PtStrings.sold)),
          );
          if (context.canPop()) {
            context.pop(true);
          } else {
            Navigator.of(context).maybePop(true);
          }
        } else if (state.failure != null && state.status == LoadStatus.success) {
          messenger.showSnackBar(SnackBar(content: Text(failureMessage(state.failure!))));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(state.isReplan ? PtStrings.replanTitle : PtStrings.sellTitle)),
          body: switch (state.status) {
            LoadStatus.initial || LoadStatus.loading => const AppLoading(),
            LoadStatus.failure => AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<SellPtCubit>().init(state.memberId),
            ),
            LoadStatus.success => _Form(state: state),
          },
        );
      },
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.state});

  final SellPtState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    final theme = Theme.of(context);
    final product = state.product;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Package & start/effective date
        Text(PtStrings.stepPackage, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (!state.isReplan)
          DropdownButtonFormField<int>(
            initialValue: product?.id,
            decoration: const InputDecoration(labelText: PtStrings.summaryPackage),
            items: [
              for (final p in state.products)
                DropdownMenuItem(
                  value: p.id,
                  child: Text('${p.name} · ${p.sessionsPerWeek}×/week · ${p.durationDays} days · ${p.basePrice}'),
                ),
            ],
            onChanged: (id) {
              final p = state.products.firstWhere((x) => x.id == id);
              cubit.selectProduct(p);
            },
          )
        else
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(state.replanning!.productName),
            subtitle: Text(
              '${formatCalendarDate(state.replanning!.startDate)} → ${formatCalendarDate(state.replanning!.endDate)}',
            ),
          ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(state.isReplan ? PtStrings.effectiveFrom : PtStrings.startDate),
          subtitle: Text(state.startDate == null ? '—' : formatCalendarDate(state.startDate!)),
          trailing: const Icon(Icons.calendar_today_outlined),
          onTap: () async {
            final now = DateTime.now();
            final first = DateTime(now.year, now.month, now.day);
            final last = state.isReplan ? state.replanning!.endDate : first.add(const Duration(days: 365));
            final picked = await showDatePicker(
              context: context,
              initialDate: state.startDate ?? first,
              firstDate: first,
              lastDate: last,
            );
            if (picked != null) cubit.setStartDate(picked);
          },
        ),
        const Divider(height: 32),

        // 2. Weekdays
        Text(PtStrings.stepDays, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          product == null
              ? PtStrings.pickDaysHint
              : PtStrings.daysChosen(state.weekdays.length, state.sessionsPerWeek!),
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
                onSelected: product == null ? null : (_) => cubit.toggleWeekday(d),
              ),
          ],
        ),
        const Divider(height: 32),

        // 3. Trainer × hour grid
        Text(PtStrings.stepSlot, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(PtStrings.gridHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        if (!state.canLoadGrid)
          const SizedBox.shrink()
        else if (state.gridStatus == LoadStatus.loading)
          const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
        else if (state.gridStatus == LoadStatus.failure)
          AppErrorView(
            message: state.failure == null ? '' : failureMessage(state.failure!),
            onRetry: cubit.loadGrid,
          )
        else if (state.grid != null)
          PtScheduleGridView(
            grid: state.grid!,
            selectedTrainerId: state.trainerId,
            selectedSlot: state.slotStart,
            onSelect: cubit.selectSlot,
          ),
        const Divider(height: 32),

        // 4. Payment (sell) / reason (re-plan)
        if (!state.isReplan) ...[
          Text(PtStrings.stepPay, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (state.paymentMethods.isEmpty)
            Text(PtStrings.noPaymentMethods, style: TextStyle(color: theme.colorScheme.error))
          else
            DropdownButtonFormField<String>(
              initialValue: state.paymentMethodId,
              decoration: const InputDecoration(labelText: PtStrings.paymentMethod),
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
        ] else
          TextFormField(
            decoration: const InputDecoration(labelText: PtStrings.reason),
            onChanged: cubit.setReason,
          ),
        const SizedBox(height: 16),
        _Summary(state: state),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: state.canSubmit ? cubit.submit : null,
          child: state.submitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(state.isReplan ? PtStrings.confirmReplan : PtStrings.confirmSell),
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
    if (!state.slotChosen || state.product == null) return const SizedBox.shrink();
    final trainer = state.grid?.trainers.where((t) => t.id == state.trainerId).firstOrNull;
    final end = state.isReplan
        ? state.replanning!.endDate
        : state.startDate!.add(Duration(days: state.product!.durationDays));
    Widget row(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 96, child: Text(k, style: Theme.of(context).textTheme.bodySmall)),
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
            Text(PtStrings.stepConfirm, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            row(PtStrings.summaryPackage, state.product!.name),
            row(PtStrings.summaryPeriod, '${formatCalendarDate(state.startDate!)} → ${formatCalendarDate(end)}'),
            row(PtStrings.summaryDays, ptWeekdaysLabel(state.weekdays)),
            row(PtStrings.summaryHour, ptHourLabel(state.slotStart!)),
            row(PtStrings.summaryTrainer, trainer?.name ?? '—'),
            if (!state.isReplan) row(PtStrings.summaryAmount, state.product!.basePrice),
          ],
        ),
      ),
    );
  }
}
