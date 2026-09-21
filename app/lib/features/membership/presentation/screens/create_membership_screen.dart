import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
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
          getIt<CreateMembershipCubit>()..bootstrap(memberId: memberId),
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
          next is CreateMembershipFormState && next.created != null,
      listener: (context, state) {
        if (state is CreateMembershipFormState && state.created != null) {
          final id = state.created!.id;
          context.go('${Routes.adminMemberships}/$id');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text(MembershipStrings.createTitle)),
          body: switch (state) {
            CreateMembershipLoadingCatalog() => const AppLoading(),
            CreateMembershipBootstrapFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<CreateMembershipCubit>().bootstrap(
                memberId: memberId,
              ),
            ),
            CreateMembershipFormState() => _CreateMembershipForm(state: state),
          },
        );
      },
    );
  }
}

class _CreateMembershipForm extends StatelessWidget {
  const _CreateMembershipForm({required this.state});

  final CreateMembershipFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateMembershipCubit>();
    final memberLocked = state.members.isEmpty && state.selectedMemberId != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          MembershipStrings.createSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (!memberLocked) ...[
          Text(
            MembershipStrings.memberLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: state.selectedMemberId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: MembershipStrings.selectMemberHint,
            ),
            items: state.members
                .map(
                  (m) => DropdownMenuItem(
                    value: m.id.toString(),
                    child: Text('${m.fullName} (${m.membershipNumber})'),
                  ),
                )
                .toList(),
            onChanged: state.submitting
                ? null
                : (value) {
                    if (value != null) cubit.selectMember(value);
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
                  if (value != null) cubit.selectProduct(value);
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
                    if (picked != null) cubit.setStartDate(picked);
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
          onChanged: cubit.setLockerNumber,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(MembershipStrings.autoRenewLabel),
          value: state.autoRenew,
          onChanged: state.submitting ? null : cubit.setAutoRenew,
        ),
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
          onPressed: state.submitting ? null : cubit.submit,
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
