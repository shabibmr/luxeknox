import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../cubit/membership_freeze_form_cubit.dart';
import '../membership_strings.dart';

class MembershipFreezeScreen extends StatelessWidget {
  const MembershipFreezeScreen({super.key, required this.membershipId});

  final String membershipId;

  @override
  Widget build(BuildContext context) {
    final canUpdate = context.can('memberships.update');
    if (!canUpdate) {
      return Scaffold(
        appBar: AppBar(title: const Text(MembershipStrings.freezeTitle)),
        body: const Center(
          child: Text(MembershipStrings.noPermission),
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<MembershipFreezeFormCubit>()..load(membershipId),
      child: _MembershipFreezeView(membershipId: membershipId),
    );
  }
}

class _MembershipFreezeView extends StatefulWidget {
  const _MembershipFreezeView({required this.membershipId});

  final String membershipId;

  @override
  State<_MembershipFreezeView> createState() => _MembershipFreezeViewState();
}

class _MembershipFreezeViewState extends State<_MembershipFreezeView> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date != null) {
      onSelected(date);
    }
  }

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<MembershipFreezeFormCubit>();
    cubit.onReasonChanged(_reasonController.text);
    final success = await cubit.submit();

    if (!context.mounted) return;

    if (success) {
      if (context.canPop()) {
        context.pop(true);
      }
      return;
    }

    final state = cubit.state;
    if (state.validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.validationError!)),
      );
    } else if (state.failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(state.failure!))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.freezeTitle)),
      body: BlocBuilder<MembershipFreezeFormCubit, MembershipFreezeFormState>(
        builder: (context, state) {
          if (state.status == LoadStatus.initial ||
              state.status == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LoadStatus.failure && state.membership == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure != null
                        ? failureMessage(state.failure!)
                        : MembershipStrings.noneFound,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context
                        .read<MembershipFreezeFormCubit>()
                        .load(widget.membershipId),
                    child: const Text(MembershipStrings.retry),
                  ),
                ],
              ),
            );
          }

          final startDate = state.startDate ?? DateTime.now();
          final endDate =
              state.endDate ?? startDate.add(const Duration(days: 7));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Membership ID: ${widget.membershipId}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ListTile(
                  key: const Key('freeze_start_date_tile'),
                  title: const Text(MembershipStrings.startDateLabel),
                  subtitle: Text(startDate.toString().split(' ').first),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(
                    context,
                    initialDate: startDate,
                    onSelected: (date) => context
                        .read<MembershipFreezeFormCubit>()
                        .onStartDateChanged(date),
                  ),
                ),
                ListTile(
                  key: const Key('freeze_end_date_tile'),
                  title: const Text(MembershipStrings.endDateLabel),
                  subtitle: Text(endDate.toString().split(' ').first),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(
                    context,
                    initialDate: endDate,
                    onSelected: (date) => context
                        .read<MembershipFreezeFormCubit>()
                        .onEndDateChanged(date),
                  ),
                ),
                if (state.validationError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.validationError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  key: const Key('freeze_reason_field'),
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: MembershipStrings.reasonLabel,
                  ),
                  onChanged: (val) {
                    context
                        .read<MembershipFreezeFormCubit>()
                        .onReasonChanged(val);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('freeze_submit_button'),
                    onPressed: state.isSubmitting
                        ? null
                        : () => _submit(context),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(MembershipStrings.freezeSubmit),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
