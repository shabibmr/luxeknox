import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/unsaved_changes_scope.dart';
import '../cubit/trainer_form_cubit.dart';
import '../people_strings.dart';
import '../widgets/gender_radio_group.dart';

/// Admin create-trainer form (`POST /trainers`).
class AddTrainerScreen extends StatelessWidget {
  const AddTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TrainerFormCubit>(),
      child: const _AddTrainerBody(),
    );
  }
}

class _AddTrainerBody extends StatefulWidget {
  const _AddTrainerBody();

  @override
  State<_AddTrainerBody> createState() => _AddTrainerBodyState();
}

class _AddTrainerBodyState extends State<_AddTrainerBody> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  String? _gender;
  final _bio = TextEditingController();
  final _hourlyRate = TextEditingController();
  final _maxClients = TextEditingController();
  final _specializationInput = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _genderError;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _bio.dispose();
    _hourlyRate.dispose();
    _maxClients.dispose();
    _specializationInput.dispose();
    super.dispose();
  }

  void _syncField(
    TextEditingController controller,
    void Function(String) onChanged,
  ) {
    onChanged(controller.text);
  }

  static bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  bool _validate() {
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    final email = _email.text.trim();
    final gender = _gender?.trim() ?? '';
    String? firstErr;
    String? lastErr;
    String? emailErr;
    String? genderErr;

    if (first.isEmpty) firstErr = PeopleStrings.firstNameRequired;
    if (last.isEmpty) lastErr = PeopleStrings.lastNameRequired;
    if (email.isEmpty) {
      emailErr = PeopleStrings.emailRequired;
    } else if (!_isValidEmail(email)) {
      emailErr = PeopleStrings.invalidEmail;
    }
    if (gender.isEmpty) genderErr = PeopleStrings.genderRequired;

    setState(() {
      _firstNameError = firstErr;
      _lastNameError = lastErr;
      _emailError = emailErr;
      _genderError = genderErr;
    });

    return firstErr == null &&
        lastErr == null &&
        emailErr == null &&
        genderErr == null;
  }

  Future<void> _submit() async {
    final cubit = context.read<TrainerFormCubit>();
    if (cubit.state.submitting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(PeopleStrings.alreadySubmitting)),
      );
      return;
    }

    if (!_validate()) {
      return;
    }

    cubit.updateInput(
      (input) => input.copyWith(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _optional(_phone.text),
        gender: _gender,
        bio: _optional(_bio.text),
        hourlyRate: _optional(_hourlyRate.text),
        maxClientsCapacity: int.tryParse(_maxClients.text.trim()),
      ),
    );

    await cubit.submit();
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _addSpecializationChip() {
    final value = _specializationInput.text;
    context.read<TrainerFormCubit>().addSpecialization(value);
    _specializationInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainerFormCubit, TrainerFormState>(
      listenWhen: (previous, current) =>
          previous.created != current.created ||
          previous.error != current.error,
      listener: (context, state) {
        if (state.created != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(PeopleStrings.trainerCreated)),
          );
          // Return the new id so the directory can refresh, then open the trainer.
          context.pop(state.created!.id);
          return;
        }
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        final submitting = state.submitting || state.created != null;
        final dirty = state.isDirty && !submitting;

        return UnsavedChangesScope(
          hasUnsavedChanges: dirty,
          child: Scaffold(
            appBar: AppBar(title: const Text(PeopleStrings.addTrainerTitle)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _firstName,
                    enabled: !submitting,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: PeopleStrings.firstName,
                      errorText: _firstNameError,
                    ),
                    onChanged: (_) {
                      if (_firstNameError != null) {
                        setState(() => _firstNameError = null);
                      }
                      _syncField(
                        _firstName,
                        (v) => context.read<TrainerFormCubit>().updateInput(
                          (i) => i.copyWith(firstName: v),
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: _lastName,
                    enabled: !submitting,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: PeopleStrings.lastName,
                      errorText: _lastNameError,
                    ),
                    onChanged: (_) {
                      if (_lastNameError != null) {
                        setState(() => _lastNameError = null);
                      }
                      _syncField(
                        _lastName,
                        (v) => context.read<TrainerFormCubit>().updateInput(
                          (i) => i.copyWith(lastName: v),
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: _email,
                    enabled: !submitting,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: PeopleStrings.email,
                      errorText: _emailError,
                    ),
                    onChanged: (_) {
                      if (_emailError != null) {
                        setState(() => _emailError = null);
                      }
                      _syncField(
                        _email,
                        (v) => context.read<TrainerFormCubit>().updateInput(
                          (i) => i.copyWith(email: v),
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: _phone,
                    enabled: !submitting,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.phoneNumber,
                    ),
                    onChanged: (_) => _syncField(
                      _phone,
                      (v) => context.read<TrainerFormCubit>().updateInput(
                        (i) => i.copyWith(phoneNumber: _optional(v)),
                      ),
                    ),
                  ),
                  GenderRadioGroup(
                    value: _gender,
                    enabled: !submitting,
                    errorText: _genderError,
                    onChanged: (v) {
                      setState(() {
                        _gender = v;
                        _genderError = null;
                      });
                      context.read<TrainerFormCubit>().updateInput(
                        (i) => i.copyWith(gender: v),
                      );
                    },
                  ),
                  TextField(
                    controller: _bio,
                    enabled: !submitting,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.bio,
                    ),
                    onChanged: (_) => _syncField(
                      _bio,
                      (v) => context.read<TrainerFormCubit>().updateInput(
                        (i) => i.copyWith(bio: _optional(v)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    PeopleStrings.specializations,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final spec in state.input.specializations)
                        InputChip(
                          label: Text(spec),
                          onDeleted: submitting
                              ? null
                              : () => context
                                    .read<TrainerFormCubit>()
                                    .removeSpecialization(spec),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _specializationInput,
                          enabled: !submitting,
                          decoration: const InputDecoration(
                            hintText: PeopleStrings.specializationAddHint,
                          ),
                          onSubmitted: submitting
                              ? null
                              : (_) => _addSpecializationChip(),
                        ),
                      ),
                      IconButton(
                        onPressed: submitting ? null : _addSpecializationChip,
                        icon: const Icon(Icons.add),
                        tooltip: PeopleStrings.add,
                      ),
                    ],
                  ),
                  TextField(
                    controller: _hourlyRate,
                    enabled: !submitting,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.hourlyRate,
                    ),
                    onChanged: (_) => _syncField(
                      _hourlyRate,
                      (v) => context.read<TrainerFormCubit>().updateInput(
                        (i) => i.copyWith(hourlyRate: _optional(v)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _maxClients,
                    enabled: !submitting,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: PeopleStrings.maxClients,
                    ),
                    onChanged: (_) => _syncField(
                      _maxClients,
                      (v) => context.read<TrainerFormCubit>().updateInput(
                        (i) => i.copyWith(
                          maxClientsCapacity: int.tryParse(v.trim()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: submitting ? null : _submit,
                    child: submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(PeopleStrings.createTrainer),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
