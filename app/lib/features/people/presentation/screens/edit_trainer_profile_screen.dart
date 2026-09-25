import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/trainer_profile.dart';
import '../cubit/edit_trainer_profile_cubit.dart';
import '../people_strings.dart';

class EditTrainerProfileScreen extends StatelessWidget {
  const EditTrainerProfileScreen({super.key, required this.trainerId});

  final int trainerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditTrainerProfileCubit>()..load(trainerId),
      child: _EditTrainerProfileBody(trainerId: trainerId),
    );
  }
}

class _EditTrainerProfileBody extends StatelessWidget {
  const _EditTrainerProfileBody({required this.trainerId});

  final int trainerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.editProfile)),
      body: BlocConsumer<EditTrainerProfileCubit, EditTrainerProfileState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.profileSaved)),
            );
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
          return _TrainerProfileForm(profile: profile);
        },
      ),
    );
  }
}

class _TrainerProfileForm extends StatefulWidget {
  const _TrainerProfileForm({required this.profile});

  final TrainerProfile profile;

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

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _bio.dispose();
    _specializations.dispose();
    _hourlyRate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _firstName,
          decoration: const InputDecoration(labelText: PeopleStrings.firstName),
        ),
        TextField(
          controller: _lastName,
          decoration: const InputDecoration(labelText: PeopleStrings.lastName),
        ),
        TextField(
          controller: _phone,
          decoration: const InputDecoration(
            labelText: PeopleStrings.phoneNumber,
          ),
          keyboardType: TextInputType.phone,
        ),
        TextField(
          controller: _bio,
          decoration: const InputDecoration(labelText: PeopleStrings.bio),
          maxLines: 3,
        ),
        TextField(
          controller: _specializations,
          decoration: const InputDecoration(
            labelText: PeopleStrings.specializations,
            hintText: PeopleStrings.specializationsHint,
          ),
        ),
        TextField(
          controller: _hourlyRate,
          decoration: const InputDecoration(
            labelText: PeopleStrings.hourlyRate,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
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
              ),
            );
          },
          child: const Text(PeopleStrings.save),
        ),
      ],
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  List<String> _parseList(String value) {
    return value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
