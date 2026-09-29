import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../goals/presentation/screens/progress_hub_screen.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../membership/domain/entities/membership.dart';
import '../../../payments/domain/entities/payment_method.dart';
import '../../../payments/domain/usecases/get_payment_methods_usecase.dart';
import '../../../pt/domain/entities/pt_product.dart';
import '../../../pt/domain/entities/pt_schedule_grid.dart';
import '../../../pt/domain/entities/pt_subscription.dart';
import '../../../pt/domain/repositories/pt_repository.dart';
import '../../../pt/domain/usecases/pt_usecases.dart';
import '../../../pt/presentation/pt_strings.dart';
import '../../../pt/presentation/screens/sell_pt_screen.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../cubit/member_dossier_cubit.dart';
import '../member_dossier_pt.dart';
import '../people_strings.dart';
import 'documents_screen.dart';
import 'emergency_contacts_screen.dart';
import 'health_info_screen.dart';
import 'medical_history_screen.dart';
import 'photos_avatar_screen.dart';

class MemberDossierScreen extends StatelessWidget {
  const MemberDossierScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MemberDossierCubit>()..load(memberId),
      child: _MemberDossierBody(memberId: memberId),
    );
  }
}

class _MemberDossierBody extends StatelessWidget {
  const _MemberDossierBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemberDossierCubit, MemberDossierState>(
      // Only react to a new message/failure, not to every state change that still carries one.
      listenWhen: (previous, current) =>
          previous.message != current.message || previous.failure != current.failure,
      listener: (context, state) {
        if (state.message != null) {
          final text = state.message == 'pt_renewed'
              ? PtStrings.renewed
              : PeopleStrings.profileSaved;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(text)));
        } else if (state.status == LoadStatus.failure &&
            state.person != null &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(state.failure!))),
          );
        }
      },
      builder: (context, state) {
        final editing = state.editingProfile;
        return Scaffold(
          appBar: AppBar(
            title: const Text(PeopleStrings.dossierTitle),
            actions: [
              if (state.person != null)
                IconButton(
                  tooltip: editing
                      ? PeopleStrings.cancelEdit
                      : PeopleStrings.editProfile,
                  icon: Icon(editing ? Icons.close : Icons.edit_outlined),
                  onPressed: () =>
                      context.read<MemberDossierCubit>().setEditing(!editing),
                ),
            ],
          ),
          body: () {
            if (state.person == null && state.status == LoadStatus.failure) {
              return AppErrorView(
                message: failureMessage(state.failure!),
                onRetry: () =>
                    context.read<MemberDossierCubit>().load(memberId),
              );
            }
            if (state.person == null) {
              return const AppLoading();
            }
            return _DossierContent(state: state);
          }(),
        );
      },
    );
  }
}

class _DossierContent extends StatefulWidget {
  const _DossierContent({required this.state});

  final MemberDossierState state;

  @override
  State<_DossierContent> createState() => _DossierContentState();
}

class _DossierContentState extends State<_DossierContent> {
  late final TextEditingController _notesController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final p = widget.state.person!;
    _notesController = TextEditingController(text: p.notes ?? '');
    _firstNameController = TextEditingController(text: p.firstName);
    _lastNameController = TextEditingController(text: p.lastName);
    _emailController = TextEditingController(text: p.email ?? '');
    _phoneController = TextEditingController(text: p.phoneNumber ?? '');
  }

  @override
  void didUpdateWidget(covariant _DossierContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final person = widget.state.person;
    if (person == null) return;
    final enteredEdit =
        widget.state.editingProfile && !oldWidget.state.editingProfile;
    final personChanged = oldWidget.state.person != person;
    if (enteredEdit || (!widget.state.editingProfile && personChanged)) {
      _notesController.text = person.notes ?? '';
      _firstNameController.text = person.firstName;
      _lastNameController.text = person.lastName;
      _emailController.text = person.email ?? '';
      _phoneController.text = person.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isAdminShell {
    try {
      final location = GoRouterState.of(context).uri.path;
      return location.startsWith('/admin');
    } on Object {
      // Widget tests may mount without GoRouter.
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final person = state.person!;
    final membership = state.membership;
    final session = context.watch<SessionCubit>().state;
    final userType = session is SessionAuthenticated ? session.principal.userType : null;
    final canAddPt =
        userType != null &&
        canSellPt(
          userType: userType,
          canCreatePt: context.can('pt_subscriptions.create'),
          membership: membership,
          pt: state.pt,
        );
    final canChangePt =
        userType != null &&
        canManagePt(userType: userType, canManage: context.can('pt_subscriptions.manage'));
    final canRenewPt =
        userType != null &&
        userType == UserType.admin &&
        context.can('pt_subscriptions.create');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(person.fullName, style: Theme.of(context).textTheme.headlineSmall),
        Text(person.membershipNumber),
        const SizedBox(height: 8),
        if (!state.editingProfile) ...[
          if (person.email != null && person.email!.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(PeopleStrings.email),
              subtitle: Text(person.email!),
            ),
          if (person.phoneNumber != null && person.phoneNumber!.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(PeopleStrings.phone),
              subtitle: Text(person.phoneNumber!),
            ),
          if (person.notes != null && person.notes!.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(PeopleStrings.notes),
              subtitle: Text(person.notes!),
            ),
        ] else ...[
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: PeopleStrings.firstName,
            ),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: PeopleStrings.lastName,
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: PeopleStrings.email),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: PeopleStrings.phone),
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: PeopleStrings.notes),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              context.read<MemberDossierCubit>().save(
                person.copyWith(
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                  email: _emailController.text.trim().isEmpty
                      ? null
                      : _emailController.text.trim(),
                  phoneNumber: _phoneController.text.trim().isEmpty
                      ? null
                      : _phoneController.text.trim(),
                  notes: _notesController.text.trim().isEmpty
                      ? null
                      : _notesController.text.trim(),
                ),
              );
            },
            child: const Text(PeopleStrings.save),
          ),
        ],
        const Divider(),
        _MembershipSection(
          membership: membership,
          membershipsUnavailable: state.membershipsUnavailable,
          outstandingBalance: person.outstandingBalance,
          visitsThisMonth: state.visitsThisMonth,
        ),
        const Divider(),
        _PersonalTrainingSection(
          state: state,
          isAdminShell: _isAdminShell,
          canAddPt: canAddPt,
          canChangePt: canChangePt,
          canRenewPt: canRenewPt,
          onAddPt: () async {
            final cubit = context.read<MemberDossierCubit>();
            await context.push<bool>(Routes.adminMembersAddPtById(person.id));
            if (mounted) await cubit.reloadPt(person.id);
          },
          onChangePt: (sub) => _changePt(sub),
          onRenewPt: (sub) => _renewPt(sub),
        ),
        const Divider(),
        ListTile(
          title: const Text(PeopleStrings.health),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => HealthInfoScreen(memberId: person.id),
            ),
          ),
        ),
        ListTile(
          title: const Text(PeopleStrings.medicalHistory),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => MedicalHistoryScreen(memberId: person.id),
            ),
          ),
        ),
        ListTile(
          title: const Text(PeopleStrings.emergencyContacts),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => EmergencyContactsScreen(userId: person.userId),
            ),
          ),
        ),
        ListTile(
          title: const Text(PeopleStrings.documents),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DocumentsScreen(memberId: person.id),
            ),
          ),
        ),
        ListTile(
          title: const Text(PeopleStrings.photos),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PhotosAvatarScreen(memberId: person.id),
            ),
          ),
        ),
      ],
    );
  }

  /// Reassign trainer and/or move weekdays+hour from an effective date.
  Future<void> _changePt(PtSubscription sub) async {
    final cubit = context.read<MemberDossierCubit>();
    final products = (await getIt<GetPtProductsUseCase>()(const NoParams())).fold(
      (_) => <PtProduct>[],
      (items) => items,
    );
    if (!mounted) return;
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SellPtScreen(memberId: sub.memberId, replanning: sub, products: products),
      ),
    );
    if (mounted) await cubit.reloadPt(sub.memberId);
  }

  Future<void> _renewPt(PtSubscription sub) async {
    final cubit = context.read<MemberDossierCubit>();
    final methods = (await getIt<GetPaymentMethodsUseCase>()(const NoParams())).fold(
      (_) => <PaymentMethod>[],
      (items) => items.where((m) => m.isActive).toList(),
    );
    if (!mounted) return;
    final payment = await showDialog<PtPayment>(
      context: context,
      builder: (_) => _RenewPtDialog(subscription: sub, paymentMethods: methods),
    );
    if (payment == null || !mounted) return;
    await cubit.renewPt(subscriptionId: sub.id, payment: payment);
  }
}

class _RenewPtDialog extends StatefulWidget {
  const _RenewPtDialog({required this.subscription, required this.paymentMethods});

  final PtSubscription subscription;
  final List<PaymentMethod> paymentMethods;

  @override
  State<_RenewPtDialog> createState() => _RenewPtDialogState();
}

class _RenewPtDialogState extends State<_RenewPtDialog> {
  late String? _methodId =
      widget.paymentMethods.length == 1 ? widget.paymentMethods.first.id : null;

  @override
  Widget build(BuildContext context) {
    final sub = widget.subscription;
    return AlertDialog(
      title: const Text(PtStrings.renewTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(PtStrings.renewBody(sub.trainerName, ptWeekdaysLabel(sub.weekdays), sub.slotLabel)),
          const SizedBox(height: 12),
          if (widget.paymentMethods.isEmpty)
            const Text(PtStrings.noPaymentMethods)
          else
            DropdownButtonFormField<String>(
              initialValue: _methodId,
              decoration: const InputDecoration(labelText: PtStrings.paymentMethod),
              items: [
                for (final m in widget.paymentMethods)
                  DropdownMenuItem(value: m.id, child: Text(m.methodName)),
              ],
              onChanged: (v) => setState(() => _methodId = v),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text(PtStrings.cancel)),
        FilledButton(
          onPressed: _methodId == null
              ? null
              : () => Navigator.of(context).pop(PtPayment(paymentMethodId: int.parse(_methodId!))),
          child: const Text(PtStrings.renew),
        ),
      ],
    );
  }
}

class _MembershipSection extends StatelessWidget {
  const _MembershipSection({
    required this.membership,
    required this.membershipsUnavailable,
    required this.outstandingBalance,
    required this.visitsThisMonth,
  });

  final Membership? membership;
  final bool membershipsUnavailable;
  final String? outstandingBalance;
  final int? visitsThisMonth;

  @override
  Widget build(BuildContext context) {
    final statusSubtitle = membershipsUnavailable
        ? PeopleStrings.unavailable
        : (membership?.status.name ?? PeopleStrings.noMembership);
    final expirySubtitle = membershipsUnavailable
        ? PeopleStrings.unavailable
        : membership == null
        ? PeopleStrings.noMembership
        : '${formatCalendarDate(membership!.endDate)} '
              '${formatDaysRelative(membership!.endDate)}';
    final visitsSubtitle = visitsThisMonth == null
        ? PeopleStrings.unavailable
        : '$visitsThisMonth';

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PeopleStrings.membership),
          subtitle: Text(statusSubtitle),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PeopleStrings.membershipExpiry),
          subtitle: Text(expirySubtitle),
        ),
        if (outstandingBalance != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PeopleStrings.balance),
            subtitle: Text(outstandingBalance!),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PeopleStrings.attendanceThisMonth),
          subtitle: Text(visitsSubtitle),
        ),
      ],
    );
  }
}

class _PersonalTrainingSection extends StatelessWidget {
  const _PersonalTrainingSection({
    required this.state,
    required this.isAdminShell,
    required this.canAddPt,
    required this.canChangePt,
    required this.canRenewPt,
    required this.onAddPt,
    required this.onChangePt,
    required this.onRenewPt,
  });

  final MemberDossierState state;
  final bool isAdminShell;
  final bool canAddPt;
  final bool canChangePt;
  final bool canRenewPt;
  final VoidCallback onAddPt;
  final ValueChanged<PtSubscription> onChangePt;
  final ValueChanged<PtSubscription> onRenewPt;

  @override
  Widget build(BuildContext context) {
    final person = state.person!;
    final pt = state.pt;
    final current = pt?.current;
    final ended = pt?.lastEnded;
    final shown = current ?? ended;
    final status = ptDossierStatus(pt);
    final readOnly = trainerHubReadOnly(pt);

    final statusLabel = state.ptUnavailable
        ? PeopleStrings.unavailable
        : switch (status) {
            PtDossierStatus.active => PeopleStrings.ptActive,
            PtDossierStatus.scheduled => PeopleStrings.ptScheduled,
            PtDossierStatus.expired => PeopleStrings.ptExpired,
            PtDossierStatus.notPurchased => PeopleStrings.ptNotPurchased,
          };
    // Coaching modules are relevant once the member has (or had) PT.
    final showCoaching = shown != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          PeopleStrings.personalTraining,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (readOnly)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              PtStrings.readOnlyBanner,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PeopleStrings.ptStatus),
          subtitle: Text(statusLabel),
        ),
        if (shown != null) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(shown.productName),
            subtitle: Text(
              '${ptWeekdaysLabel(shown.weekdays)} · ${shown.slotLabel}\n'
              '${formatCalendarDate(shown.startDate)} → ${formatCalendarDate(shown.endDate)} '
              '${formatDaysRelative(shown.endDate)}',
            ),
            isThreeLine: true,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PeopleStrings.assignedTrainer),
            subtitle: Text(shown.trainerName),
            trailing: current != null && canChangePt
                ? TextButton(
                    onPressed: () => onChangePt(current),
                    child: const Text(PtStrings.changeTrainerSlot),
                  )
                : null,
          ),
          if (canRenewPt)
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: state.renewingPt ? null : () => onRenewPt(shown),
                child: const Text(PtStrings.renew),
              ),
            ),
        ],
        if (canAddPt && !state.ptUnavailable)
          FilledButton.tonal(
            onPressed: onAddPt,
            child: const Text(PeopleStrings.addPersonalTraining),
          ),
        if (showCoaching) ...[
          if (current != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(PeopleStrings.nextSchedule),
              subtitle: Text(_scheduleLabel(state.nextSchedule)),
            ),
          ListTile(
            title: const Text(PeopleStrings.goals),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ProgressHubScreen(
                  memberId: person.id.toString(),
                  canCreateGoals: !readOnly,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text(PeopleStrings.workoutPlan),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final id = person.id.toString();
              final path = isAdminShell
                  ? Routes.adminMembersWorkoutHistoryById(id)
                  : Routes.trainerMembersWorkoutHistoryById(id);
              context.push(path);
            },
          ),
          ListTile(
            title: const Text(PeopleStrings.dietPlan),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final id = person.id.toString();
              final path = isAdminShell
                  ? Routes.adminMembersDietHistoryById(id)
                  : Routes.trainerMembersDietHistoryById(id);
              context.push(path);
            },
          ),
        ],
      ],
    );
  }

  String _scheduleLabel(ScheduleSession? session) {
    if (session == null) return PeopleStrings.noUpcomingSession;
    return '${session.title} · ${session.startTime.toLocal()}';
  }
}
