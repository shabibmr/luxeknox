import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_currency_field.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/package_grid_picker_field.dart';
import '../../../people/domain/usecases/get_member_usecase.dart';
import '../../../people/presentation/widgets/member_picker_sheet.dart';
import '../../domain/entities/membership_replacement_preview.dart';
import '../cubit/create_membership_cubit.dart';
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
          getIt<CreateMembershipCubit>()..started(memberId: memberId),
      child: _CreateMembershipBody(memberId: memberId),
    );
  }
}

class _CreateMembershipBody extends StatelessWidget {
  const _CreateMembershipBody({this.memberId});

  final String? memberId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateMembershipCubit, CreateMembershipState>(
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
                  onRetry: () => context.read<CreateMembershipCubit>().started(
                    memberId: memberId,
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
  context.read<CreateMembershipCubit>().replaceConfirmed(confirmed == true);
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
  context.read<CreateMembershipCubit>().replaceConfirmed(false);
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

  bool get _showPriceSummary {
    if (state.selectedProduct == null) return false;
    if (!state.isCoupleSelected) return true;
    if (state.selectedPartner == null) return false;
    if (state.checkingPartner) return false;
    final preview = state.partnerReplacement;
    if (preview == null) return true;
    if (preview.isCouple) return false;
    return state.replaceConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateMembershipCubit>();

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
                cubit.memberSelected(member);
              }
            },
          ),
          const SizedBox(height: 16),
        ] else ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(MembershipStrings.memberLabel),
            subtitle: _LockedMemberName(memberId: state.selectedMemberId),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          MembershipStrings.packageLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        PackageGridPickerField<String>(
          value: state.selectedProductId,
          hintText: MembershipStrings.selectPackageHint,
          enabled: !state.submitting,
          options: [
            for (final p in state.products)
              PackageGridOption(
                value: p.id,
                title: p.name,
                subtitle: p.basePrice,
                isCouple: p.isCouple,
              ),
          ],
          onChanged: (value) => cubit.productSelected(value),
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
                cubit.partnerSelected(member);
              }
            },
          ),
          if (state.checkingPartner) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
        ],
        if (_showPriceSummary) ...[
          const SizedBox(height: 16),
          _PriceSummary(state: state),
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
                      cubit.paymentMethodSelected(value);
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
                      cubit.startDateChanged(picked);
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
          onChanged: (value) => cubit.lockerChanged(value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(MembershipStrings.autoRenewLabel),
          value: state.autoRenew,
          onChanged: state.submitting
              ? null
              : (value) => cubit.autoRenewChanged(value),
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
          onPressed: state.submitting ? null : () => cubit.submitted(),
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

/// Shows the name of the member the sale is locked to (e.g. from the member
/// dossier), falling back to the id while loading or if the lookup fails.
class _LockedMemberName extends StatefulWidget {
  const _LockedMemberName({required this.memberId});

  final String? memberId;

  @override
  State<_LockedMemberName> createState() => _LockedMemberNameState();
}

class _LockedMemberNameState extends State<_LockedMemberName> {
  String? _name;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant _LockedMemberName oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memberId != widget.memberId) {
      _name = null;
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    final id = int.tryParse(widget.memberId ?? '');
    if (id == null) return;
    final result = await getIt<GetMemberUseCase>()(id);
    if (!mounted || widget.memberId != id.toString()) return;
    result.fold((_) {}, (person) {
      final name = '${person.firstName} ${person.lastName}'.trim();
      if (name.isNotEmpty) setState(() => _name = name);
    });
  }

  @override
  Widget build(BuildContext context) =>
      Text(_name ?? 'Member #${widget.memberId}');
}

class _PriceSummary extends StatefulWidget {
  const _PriceSummary({required this.state});

  final CreateMembershipState state;

  @override
  State<_PriceSummary> createState() => _PriceSummaryState();
}

class _PriceSummaryState extends State<_PriceSummary> {
  late final TextEditingController _discountController;
  late final TextEditingController _percentController;
  var _syncing = false;

  int? get _priceCents => _parseCents(widget.state.selectedProduct?.basePrice);

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(
      text: widget.state.discountAmount ?? '',
    )..addListener(_onDiscountEdited);
    _percentController = TextEditingController()..addListener(_onPercentEdited);
    _syncPercentFromValue();
  }

  @override
  void didUpdateWidget(covariant _PriceSummary oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.state.discountAmount ?? '';
    final oldPrice = _parseCents(oldWidget.state.selectedProduct?.basePrice);
    if (oldPrice != _priceCents && _percentController.text.isNotEmpty) {
      // Package changed: keep the percentage, recompute the value.
      _onPercentEdited();
    } else if (_discountController.text != next) {
      _syncing = true;
      _discountController.text = next;
      _syncing = false;
      _syncPercentFromValue();
    }
  }

  @override
  void dispose() {
    _discountController
      ..removeListener(_onDiscountEdited)
      ..dispose();
    _percentController
      ..removeListener(_onPercentEdited)
      ..dispose();
    super.dispose();
  }

  void _syncPercentFromValue() {
    final priceCents = _priceCents;
    final valueCents = _parseCents(_discountController.text);
    final text =
        (priceCents == null ||
            priceCents <= 0 ||
            valueCents == null ||
            valueCents > priceCents)
        ? ''
        : _formatPercent(_percentHundredths(valueCents, priceCents));
    if (_percentController.text == text) return;
    _syncing = true;
    _percentController.text = text;
    _syncing = false;
  }

  void _onPercentEdited() {
    if (_syncing || !mounted) return;
    final priceCents = _priceCents;
    final pctHundredths = _parsePercentHundredths(_percentController.text);
    final value = (priceCents == null || pctHundredths == null)
        ? ''
        : _formatCents(_amountFromPercent(priceCents, pctHundredths));
    _syncing = true;
    _discountController.text = value;
    _syncing = false;
    context.read<CreateMembershipCubit>().discountChanged(value);
  }

  void _onDiscountEdited() {
    if (_syncing || !mounted) return;
    _syncPercentFromValue();
    context.read<CreateMembershipCubit>().discountChanged(
      _discountController.text,
    );
  }

  String? get _valueError {
    final priceCents = _priceCents;
    final valueCents = _parseCents(widget.state.discountAmount);
    if (priceCents != null && valueCents != null && valueCents > priceCents) {
      return MembershipStrings.discountExceedsTotal;
    }
    return null;
  }

  String get _totalLabel {
    final priceCents = _priceCents;
    final discountCents = _parseCents(widget.state.discountAmount ?? '0') ?? 0;
    if (priceCents == null) return '—';
    final total = priceCents - discountCents;
    return _formatCents(total < 0 ? 0 : total);
  }

  /// Parses an unsigned money string into integer cents. Partial input while
  /// typing (e.g. "12.") returns null.
  static int? _parseCents(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(raw)) return null;
    final parts = raw.split('.');
    final whole = int.tryParse(parts[0]);
    if (whole == null) return null;
    final frac = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    final fracInt = int.tryParse(frac);
    if (fracInt == null) return null;
    return whole * 100 + fracInt;
  }

  /// Percent with up to 2 decimals as hundredths (12.34% → 1234).
  static int? _parsePercentHundredths(String raw) {
    if (raw.isEmpty) return null;
    if (!RegExp(r'^\d{1,3}(\.\d{1,2})?$').hasMatch(raw)) return null;
    final parts = raw.split('.');
    final whole = int.tryParse(parts[0]);
    if (whole == null) return null;
    final frac = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    final fracInt = int.tryParse(frac);
    if (fracInt == null) return null;
    return whole * 100 + fracInt;
  }

  static int _percentHundredths(int amountCents, int priceCents) {
    // Half-up: amount / price * 10000.
    return (amountCents * 10000 + priceCents ~/ 2) ~/ priceCents;
  }

  static int _amountFromPercent(int priceCents, int percentHundredths) {
    // Half-up: price * percent / 100.
    return (priceCents * percentHundredths + 5000) ~/ 10000;
  }

  static String _formatCents(int cents) {
    final whole = cents ~/ 100;
    final frac = (cents % 100).toString().padLeft(2, '0');
    return '$whole.$frac';
  }

  static String _formatPercent(int hundredths) {
    final whole = hundredths ~/ 100;
    final frac = hundredths % 100;
    if (frac == 0) return '$whole';
    final s = frac.toString().padLeft(2, '0');
    return '$whole.${s.replaceFirst(RegExp(r'0+$'), '')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = widget.state.selectedProduct?.basePrice ?? '—';
    final enabled = !widget.state.submitting;
    final label = widget.state.partnerReplacement != null
        ? MembershipStrings.discountForRemainingDays
        : MembershipStrings.discountByValue;

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
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _percentController,
                    enabled: enabled,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_PercentFormatter()],
                    decoration: const InputDecoration(
                      labelText: MembershipStrings.discountPercent,
                      suffixText: '%',
                      helperText: 'Max 100',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: AppCurrencyField(
                    controller: _discountController,
                    label: label,
                    enabled: enabled,
                    required: false,
                    helperText:
                        _valueError ??
                        'Max ${widget.state.selectedProduct?.basePrice ?? '—'}',
                  ),
                ),
              ],
            ),
            if (_valueError != null)
              Text(
                _valueError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
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

/// Accepts 0–100 with up to 2 decimals; anything else keeps the old value.
class _PercentFormatter extends TextInputFormatter {
  static final _shape = RegExp(r'^\d{0,3}(\.\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final t = newValue.text;
    if (t.isEmpty) return newValue;
    if (!_shape.hasMatch(t)) return oldValue;
    final v = double.tryParse(t);
    return (v == null || v > 100) ? oldValue : newValue;
  }
}
