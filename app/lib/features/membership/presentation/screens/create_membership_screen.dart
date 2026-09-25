import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
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
      create: (_) => getIt<CreateMembershipBloc>()
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
          prev.created == null && next.created != null,
      listener: (context, state) {
        final id = state.created?.id;
        if (id != null) {
          context.go('${Routes.adminMemberships}/$id');
        }
      },
      builder: (context, state) {
        final noProducts = state.products.isEmpty;
        return Scaffold(
          appBar: AppBar(title: const Text(MembershipStrings.createTitle)),
          body: noProducts &&
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
              : _CreateMembershipForm(state: state),
        );
      },
    );
  }
}

class _CreateMembershipForm extends StatelessWidget {
  const _CreateMembershipForm({required this.state});

  final CreateMembershipState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateMembershipBloc>();
    final memberLocked =
        state.members.isEmpty && state.selectedMemberId != null;

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
                    if (value != null) {
                      bloc.add(CreateMembershipMemberSelected(value));
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
