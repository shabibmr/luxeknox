import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/person.dart';
import '../cubit/edit_member_cubit.dart';
import '../people_strings.dart';

/// Dedicated single-purpose edit form for an existing member.
class EditMemberScreen extends StatelessWidget {
  const EditMemberScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditMemberCubit>()..load(memberId),
      child: _EditMemberBody(memberId: memberId),
    );
  }
}

class _EditMemberBody extends StatelessWidget {
  const _EditMemberBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.editMemberTitle)),
      body: BlocConsumer<EditMemberCubit, EditMemberState>(
        listener: (context, state) {
          if (state is EditMemberLoaded && state.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.memberSaved)),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return switch (state) {
            EditMemberLoading() => const AppLoading(),
            EditMemberFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<EditMemberCubit>().load(memberId),
            ),
            EditMemberLoaded(:final person, :final saving) => _EditMemberForm(
              person: person,
              saving: saving,
            ),
          };
        },
      ),
    );
  }
}

class _EditMemberForm extends StatefulWidget {
  const _EditMemberForm({required this.person, required this.saving});

  final Person person;
  final bool saving;

  @override
  State<_EditMemberForm> createState() => _EditMemberFormState();
}

class _EditMemberFormState extends State<_EditMemberForm> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    _firstNameController = TextEditingController(text: p.firstName);
    _lastNameController = TextEditingController(text: p.lastName);
    _emailController = TextEditingController(text: p.email ?? '');
    _phoneController = TextEditingController(text: p.phoneNumber ?? '');
    _addressController = TextEditingController(text: p.address ?? '');
    _notesController = TextEditingController(text: p.notes ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(labelText: PeopleStrings.firstName),
        ),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(labelText: PeopleStrings.lastName),
        ),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: PeopleStrings.email),
        ),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: PeopleStrings.phoneNumber,
          ),
        ),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: PeopleStrings.address),
        ),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: PeopleStrings.notes),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: widget.saving
              ? null
              : () => context.read<EditMemberCubit>().save(
                  widget.person.copyWith(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    email: _emailController.text.trim().isEmpty
                        ? null
                        : _emailController.text.trim(),
                    phoneNumber: _phoneController.text.trim().isEmpty
                        ? null
                        : _phoneController.text.trim(),
                    address: _addressController.text.trim().isEmpty
                        ? null
                        : _addressController.text.trim(),
                    notes: _notesController.text.trim().isEmpty
                        ? null
                        : _notesController.text.trim(),
                  ),
                ),
          child: widget.saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(PeopleStrings.save),
        ),
      ],
    );
  }
}
