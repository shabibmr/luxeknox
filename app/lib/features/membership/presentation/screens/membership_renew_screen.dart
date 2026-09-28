import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../cubit/membership_renew_cubit.dart';
import '../membership_strings.dart';

class MembershipRenewScreen extends StatelessWidget {
  const MembershipRenewScreen({super.key, required this.membershipId});

  final String membershipId;

  @override
  Widget build(BuildContext context) {
    final canApprove = context.can('memberships.approve');
    if (!canApprove) {
      return Scaffold(
        appBar: AppBar(title: const Text(MembershipStrings.renewTitle)),
        body: const Center(
          child: Text(MembershipStrings.noPermission),
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<MembershipRenewCubit>()..load(membershipId),
      child: _MembershipRenewView(membershipId: membershipId),
    );
  }
}

class _MembershipRenewView extends StatefulWidget {
  const _MembershipRenewView({required this.membershipId});

  final String membershipId;

  @override
  State<_MembershipRenewView> createState() => _MembershipRenewViewState();
}

class _MembershipRenewViewState extends State<_MembershipRenewView> {
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

  Future<void> _submit(BuildContext context) async {
    final cubit = context.read<MembershipRenewCubit>();
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
    if (state.failure != null) {
      final message = state.isConflict
          ? MembershipStrings.rowVersionConflict('renew')
          : failureMessage(state.failure!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(MembershipStrings.renewTitle)),
      body: BlocBuilder<MembershipRenewCubit, MembershipRenewState>(
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
                        .read<MembershipRenewCubit>()
                        .load(widget.membershipId),
                    child: const Text(MembershipStrings.retry),
                  ),
                ],
              ),
            );
          }

          final membership = state.membership!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Membership ID: ${membership.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Current package: ${membership.product?.name ?? 'Standard'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: const Key('renew_product_dropdown'),
                  value: state.selectedProductId,
                  decoration: const InputDecoration(
                    labelText: MembershipStrings.packageLabel,
                    hintText: MembershipStrings.selectProduct,
                  ),
                  items: state.products.map((product) {
                    return DropdownMenuItem<String>(
                      value: product.id,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    context
                        .read<MembershipRenewCubit>()
                        .onProductChanged(value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('renew_reason_field'),
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: MembershipStrings.reasonLabel,
                  ),
                  onChanged: (val) {
                    context.read<MembershipRenewCubit>().onReasonChanged(val);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('renew_submit_button'),
                    onPressed: state.isSubmitting
                        ? null
                        : () => _submit(context),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(MembershipStrings.renewSubmit),
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
