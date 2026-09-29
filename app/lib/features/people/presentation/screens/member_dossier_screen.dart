import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../goals/presentation/screens/progress_hub_screen.dart';
import '../../../membership/domain/entities/membership.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../../../scheduling/presentation/widgets/trainer_picker_field.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/entities/trainer_summary.dart';
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
      listener: (context, state) {
        if (state.message != null) {
          final text = state.message == 'assigned'
              ? PeopleStrings.trainerAssigned
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
          onAddPt: () {
            context.go(
              addPersonalTrainingLocation(
                memberId: person.id,
                membership: membership,
              ),
            );
          },
          onReassign: () => _reassignTrainer(person.id),
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

  Future<void> _reassignTrainer(int memberId) async {
    final selected = await showDialog<TrainerSummary>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(PeopleStrings.reassignTrainer),
          content: TrainerPickerField(
            value: _trainerSummary(widget.state.assignedTrainer),
            onChanged: (trainer) {
              if (trainer != null) {
                Navigator.of(dialogContext).pop(trainer);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(PeopleStrings.cancel),
            ),
          ],
        );
      },
    );
    if (selected == null || !mounted) return;
    await context.read<MemberDossierCubit>().assignTrainer(
      memberId: memberId,
      trainerId: selected.id,
    );
  }
}

TrainerSummary? _trainerSummary(TrainerProfile? profile) {
  if (profile == null) return null;
  return TrainerSummary(
    id: profile.id,
    userId: profile.userId,
    fullName: profile.fullName,
    specializations: profile.specializations,
    hourlyRate: profile.hourlyRate,
    rating: profile.rating,
    maxClientsCapacity: profile.maxClientsCapacity,
    assignedActiveCount: profile.assignedActiveCount,
    isActive: profile.isActive,
  );
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
    required this.onAddPt,
    required this.onReassign,
  });

  final MemberDossierState state;
  final bool isAdminShell;
  final VoidCallback onAddPt;
  final VoidCallback onReassign;

  @override
  Widget build(BuildContext context) {
    final person = state.person!;
    final membership = state.membership;
    final hasPt = state.hasPtPackage;
    final expired = state.ptExpired;
    final membershipsUnavailable = state.membershipsUnavailable;

    final statusLabel = membershipsUnavailable
        ? PeopleStrings.unavailable
        : hasPt
        ? PeopleStrings.ptActive
        : expired
        ? PeopleStrings.ptExpired
        : PeopleStrings.ptNotPurchased;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          PeopleStrings.personalTraining,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(PeopleStrings.ptStatus),
          subtitle: Text(statusLabel),
        ),
        if (!membershipsUnavailable &&
            membership != null &&
            (hasPt || expired || membershipIncludesPt(membership)))
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PeopleStrings.ptExpiry),
            subtitle: Text(
              '${formatCalendarDate(membership.endDate)} '
              '${formatDaysRelative(membership.endDate)}',
            ),
          ),
        if (!membershipsUnavailable && !hasPt) ...[
          if (isAdminShell)
            FilledButton.tonal(
              onPressed: onAddPt,
              child: const Text(PeopleStrings.addPersonalTraining),
            ),
        ] else if (!membershipsUnavailable && hasPt) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(PeopleStrings.assignedTrainer),
            subtitle: Text(
              state.assignedTrainer?.fullName ?? PeopleStrings.unassignedTrainer,
            ),
            trailing: TextButton(
              onPressed: onReassign,
              child: Text(
                state.assignedTrainer == null
                    ? PeopleStrings.assignTrainer
                    : PeopleStrings.reassignTrainer,
              ),
            ),
          ),
          if (state.assignedTrainer != null)
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
                  canCreateGoals: true,
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
