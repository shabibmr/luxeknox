import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/person.dart';
import '../cubit/member_dossier_cubit.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.dossierTitle),
        actions: [
          IconButton(
            tooltip: PeopleStrings.editMemberTitle,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/admin/members/$memberId/edit'),
          ),
        ],
      ),
      body: BlocConsumer<MemberDossierCubit, MemberDossierState>(
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
          if (state.person == null && state.status == LoadStatus.failure) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => context.read<MemberDossierCubit>().load(memberId),
            );
          }
          final person = state.person;
          if (person == null) {
            return const AppLoading();
          }
          return _DossierContent(person: person);
        },
      ),
    );
  }
}

class _DossierContent extends StatefulWidget {
  const _DossierContent({required this.person});

  final Person person;

  @override
  State<_DossierContent> createState() => _DossierContentState();
}

class _DossierContentState extends State<_DossierContent> {
  late final TextEditingController _notesController;
  late final TextEditingController _trainerIdController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    _notesController = TextEditingController(text: p.notes ?? '');
    _trainerIdController = TextEditingController(
      text: p.assignedTrainerId?.toString() ?? '',
    );
    _firstNameController = TextEditingController(text: p.firstName);
    _lastNameController = TextEditingController(text: p.lastName);
    _emailController = TextEditingController(text: p.email ?? '');
    _phoneController = TextEditingController(text: p.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    _trainerIdController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final person = widget.person;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(person.fullName, style: Theme.of(context).textTheme.headlineSmall),
        Text(person.membershipNumber),
        if (person.membershipStatus != null)
          ListTile(
            title: const Text(PeopleStrings.membership),
            subtitle: Text(person.membershipStatus!),
          ),
        if (person.outstandingBalance != null)
          ListTile(
            title: const Text(PeopleStrings.balance),
            subtitle: Text(person.outstandingBalance!),
          ),
        if (person.lastCheckIn != null)
          ListTile(
            title: const Text(PeopleStrings.lastCheckIn),
            subtitle: Text(person.lastCheckIn!.toIso8601String()),
          ),
        if (person.nextScheduleTitle != null)
          ListTile(
            title: const Text(PeopleStrings.nextSchedule),
            subtitle: Text(person.nextScheduleTitle!),
          ),
        const Divider(),
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: 'First name'),
        ),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: 'Last name'),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Phone'),
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
        const Divider(),
        TextField(
          controller: _trainerIdController,
          decoration: const InputDecoration(
            labelText: PeopleStrings.trainerIdHint,
          ),
          keyboardType: TextInputType.number,
        ),
        TextButton(
          onPressed: () {
            final trainerId = int.tryParse(_trainerIdController.text.trim());
            if (trainerId == null) return;
            context.read<MemberDossierCubit>().assignTrainer(
              memberId: person.id,
              trainerId: trainerId,
            );
          },
          child: const Text(PeopleStrings.assignTrainer),
        ),
        TextButton(
          onPressed: () =>
              context.go('/admin/members/${person.id}/assign-membership'),
          child: const Text(PeopleStrings.assignMembership),
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
}
