import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../../domain/entities/trainer_profile.dart';
import '../cubit/edit_trainer_profile_cubit.dart';
import '../people_strings.dart';

class EditTrainerProfileScreen extends StatelessWidget {
  const EditTrainerProfileScreen({
    super.key,
    required this.trainerId,
    this.isAdmin = false,
    this.embedded = false,
    this.onSaved,
  });

  final int trainerId;
  final bool isAdmin;
  final bool embedded;
  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    if (isAdmin && !context.can('trainers.update')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(PeopleStrings.editProfile),
          automaticallyImplyLeading: !embedded,
        ),
        body: const Center(child: Text(PeopleStrings.noPermission)),
      );
    }

    return BlocProvider(
      create: (_) => getIt<EditTrainerProfileCubit>()..load(trainerId),
      child: _EditTrainerProfileBody(
        trainerId: trainerId,
        isAdmin: isAdmin,
        embedded: embedded,
        onSaved: onSaved,
      ),
    );
  }
}

class _EditTrainerProfileBody extends StatelessWidget {
  const _EditTrainerProfileBody({
    required this.trainerId,
    required this.isAdmin,
    this.embedded = false,
    this.onSaved,
  });

  final int trainerId;
  final bool isAdmin;
  final bool embedded;
  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.editProfile),
        automaticallyImplyLeading: !embedded,
      ),
      body: BlocConsumer<EditTrainerProfileCubit, EditTrainerProfileState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.profileSaved)),
            );
            onSaved?.call();
            if (!embedded && Navigator.of(context).canPop()) {
              context.pop(true);
            }
          } else if (state.status == LoadStatus.failure &&
              state.profile != null &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          if (state.profile == null && state.status == LoadStatus.failure) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<EditTrainerProfileCubit>().load(trainerId),
            );
          }
          final profile = state.profile;
          if (profile == null) {
            return const AppLoading();
          }
          return _TrainerProfileForm(profile: profile, isAdmin: isAdmin);
        },
      ),
    );
  }
}

class _TrainerProfileForm extends StatefulWidget {
  const _TrainerProfileForm({
    required this.profile,
    required this.isAdmin,
  });

  final TrainerProfile profile;
  final bool isAdmin;

  @override
  State<_TrainerProfileForm> createState() => _TrainerProfileFormState();
}

class _TrainerProfileFormState extends State<_TrainerProfileForm> {
  late final _firstName = TextEditingController(text: widget.profile.firstName);
  late final _lastName = TextEditingController(text: widget.profile.lastName);
  late final _phone = TextEditingController(
    text: widget.profile.phoneNumber ?? '',
  );
  late final _bio = TextEditingController(text: widget.profile.bio ?? '');
  late final _specializations = TextEditingController(
    text: widget.profile.specializations.join(', '),
  );
  late final _hourlyRate = TextEditingController(
    text: widget.profile.hourlyRate ?? '',
  );
  late final _maxClients = TextEditingController(
    text: widget.profile.maxClientsCapacity?.toString() ?? '',
  );
  late bool _isActive = widget.profile.isActive;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _bio.dispose();
    _specializations.dispose();
    _hourlyRate.dispose();
    _maxClients.dispose();
    super.dispose();
  }

  bool get _isDirty {
    if (_firstName.text != widget.profile.firstName) return true;
    if (_lastName.text != widget.profile.lastName) return true;
    if (_phone.text != (widget.profile.phoneNumber ?? '')) return true;
    if (_bio.text != (widget.profile.bio ?? '')) return true;
    final origSpecs = widget.profile.specializations.join(', ');
    if (_specializations.text != origSpecs) return true;
    if (_hourlyRate.text != (widget.profile.hourlyRate ?? '')) return true;
    if (widget.isAdmin) {
      final origMax = widget.profile.maxClientsCapacity?.toString() ?? '';
      if (_maxClients.text != origMax) return true;
      if (_isActive != widget.profile.isActive) return true;
    }
    return false;
  }

  Future<void> _onActiveChanged(bool value) async {
    if (!value && _isActive) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text(PeopleStrings.deactivateTrainerTitle),
          content: const Text(PeopleStrings.deactivateTrainerConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(PeopleStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(PeopleStrings.confirmStatusChange),
            ),
          ],
        ),
      );
      if (confirmed == true && mounted) {
        setState(() => _isActive = false);
      }
    } else {
      setState(() => _isActive = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnsavedChangesScope(
      hasUnsavedChanges: _isDirty,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _firstName,
            decoration: const InputDecoration(labelText: PeopleStrings.firstName),
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _lastName,
            decoration: const InputDecoration(labelText: PeopleStrings.lastName),
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _phone,
            decoration: const InputDecoration(
              labelText: PeopleStrings.phoneNumber,
            ),
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _bio,
            decoration: const InputDecoration(labelText: PeopleStrings.bio),
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _specializations,
            decoration: const InputDecoration(
              labelText: PeopleStrings.specializations,
              hintText: PeopleStrings.specializationsHint,
            ),
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _hourlyRate,
            decoration: const InputDecoration(
              labelText: PeopleStrings.hourlyRate,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          if (widget.isAdmin) ...[
            TextField(
              controller: _maxClients,
              decoration: const InputDecoration(
                labelText: PeopleStrings.maxClients,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
            ),
            SwitchListTile(
              title: const Text(PeopleStrings.statusActive),
              value: _isActive,
              onChanged: _onActiveChanged,
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              context.read<EditTrainerProfileCubit>().save(
                widget.profile.copyWith(
                  firstName: _firstName.text.trim(),
                  lastName: _lastName.text.trim(),
                  phoneNumber: _optional(_phone.text),
                  bio: _optional(_bio.text),
                  specializations: _parseList(_specializations.text),
                  hourlyRate: _optional(_hourlyRate.text),
                  maxClientsCapacity: widget.isAdmin
                      ? _optionalInt(_maxClients.text)
                      : widget.profile.maxClientsCapacity,
                  isActive: widget.isAdmin ? _isActive : widget.profile.isActive,
                ),
              );
            },
            child: const Text(PeopleStrings.save),
          ),
        ],
      ),
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  int? _optionalInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  List<String> _parseList(String value) {
    return value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
