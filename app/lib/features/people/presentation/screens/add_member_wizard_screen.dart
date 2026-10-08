import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../people_strings.dart';
import '../widgets/gender_radio_group.dart';
import '../cubit/add_member_wizard_cubit.dart';

/// Multi-step onboarding wizard for creating a new member.
class AddMemberWizardScreen extends StatelessWidget {
  const AddMemberWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddMemberWizardCubit>(),
      child: const _AddMemberWizardBody(),
    );
  }
}

class _AddMemberWizardBody extends StatefulWidget {
  const _AddMemberWizardBody();

  @override
  State<_AddMemberWizardBody> createState() => _AddMemberWizardBodyState();
}

class _AddMemberWizardBodyState extends State<_AddMemberWizardBody> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _genderError;
  String? _emailError;
  String? _phoneError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _validateStep0(AddMemberWizardState state) {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final gender = state.input.gender?.trim() ?? '';
    String? firstErr;
    String? lastErr;
    String? genderErr;

    if (first.isEmpty) firstErr = PeopleStrings.firstNameRequired;
    if (last.isEmpty) lastErr = PeopleStrings.lastNameRequired;
    if (gender.isEmpty) genderErr = PeopleStrings.genderRequired;

    setState(() {
      _firstNameError = firstErr;
      _lastNameError = lastErr;
      _genderError = genderErr;
    });

    return firstErr == null && lastErr == null && genderErr == null;
  }

  bool _validateStep1() {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    String? emailErr;
    String? phoneErr;

    if (email.isEmpty && phone.isEmpty) {
      emailErr = PeopleStrings.emailOrPhoneRequired;
      phoneErr = PeopleStrings.emailOrPhoneRequired;
    } else if (email.isNotEmpty && !_isValidEmail(email)) {
      emailErr = PeopleStrings.invalidEmail;
    }

    setState(() {
      _emailError = emailErr;
      _phoneError = phoneErr;
    });

    return emailErr == null && phoneErr == null;
  }

  void _onStepContinue(
    AddMemberWizardCubit cubit,
    AddMemberWizardState state,
  ) {
    if (state.step == 0) {
      if (!_validateStep0(state)) return;
      cubit.nextStep();
    } else if (state.step == 1) {
      if (!_validateStep1()) return;
      cubit.nextStep();
    } else if (state.step == AddMemberWizardState.stepCount - 1) {
      cubit.submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMemberWizardCubit, AddMemberWizardState>(
      listener: (context, state) {
        if (state.created != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(PeopleStrings.memberCreated)),
          );
          context.go('/admin/members/${state.created!.id}');
        } else if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddMemberWizardCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text(PeopleStrings.addMemberTitle)),
          body: Stepper(
            currentStep: state.step,
            onStepContinue: () => _onStepContinue(cubit, state),
            onStepCancel: state.step == 0 ? null : cubit.previousStep,
            controlsBuilder: (context, details) {
              final isLast = state.step == AddMemberWizardState.stepCount - 1;
              // The app theme gives FilledButton minimumSize Size.fromHeight(48)
              // (infinite min width), which breaks inside this shrink-wrapped
              // Row, so the button overrides it with a finite minimum.
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(64, 48),
                        ),
                        onPressed: state.submitting
                            ? null
                            : details.onStepContinue,
                        child: state.submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isLast
                                    ? PeopleStrings.createMember
                                    : PeopleStrings.next,
                              ),
                      ),
                      if (details.onStepCancel != null) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text(PeopleStrings.back),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
            steps: [
              Step(
                title: const Text(PeopleStrings.stepBasicInfo),
                isActive: state.step >= 0,
                state: state.step > 0 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: PeopleStrings.firstName,
                        errorText: _firstNameError,
                      ),
                      onChanged: (value) {
                        if (_firstNameError != null) {
                          setState(() => _firstNameError = null);
                        }
                        cubit.updateInput(
                          (i) => i.copyWith(firstName: value),
                        );
                      },
                    ),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: PeopleStrings.lastName,
                        errorText: _lastNameError,
                      ),
                      onChanged: (value) {
                        if (_lastNameError != null) {
                          setState(() => _lastNameError = null);
                        }
                        cubit.updateInput((i) => i.copyWith(lastName: value));
                      },
                    ),
                    GenderRadioGroup(
                      value: state.input.gender,
                      errorText: _genderError,
                      onChanged: (value) {
                        if (_genderError != null) {
                          setState(() => _genderError = null);
                        }
                        cubit.updateInput((i) => i.copyWith(gender: value));
                      },
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(PeopleStrings.stepContactAccount),
                isActive: state.step >= 1,
                state: state.step > 1 ? StepState.complete : StepState.indexed,
                content: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: PeopleStrings.email,
                        errorText: _emailError,
                      ),
                      onChanged: (value) {
                        if (_emailError != null || _phoneError != null) {
                          setState(() {
                            _emailError = null;
                            _phoneError = null;
                          });
                        }
                        cubit.updateInput((i) => i.copyWith(email: value));
                      },
                    ),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: PeopleStrings.phoneNumber,
                        errorText: _phoneError,
                      ),
                      onChanged: (value) {
                        if (_emailError != null || _phoneError != null) {
                          setState(() {
                            _emailError = null;
                            _phoneError = null;
                          });
                        }
                        cubit.updateInput(
                          (i) => i.copyWith(phoneNumber: value),
                        );
                      },
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.address,
                      ),
                      onChanged: (value) =>
                          cubit.updateInput((i) => i.copyWith(address: value)),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(PeopleStrings.stepReview),
                isActive: state.step >= 2,
                state: StepState.indexed,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(PeopleStrings.reviewHint),
                    const SizedBox(height: 12),
                    Text(
                      '${PeopleStrings.firstName}: ${state.input.firstName}',
                    ),
                    Text('${PeopleStrings.lastName}: ${state.input.lastName}'),
                    Text('${PeopleStrings.gender}: ${state.input.gender ?? '-'}'),
                    Text('${PeopleStrings.email}: ${state.input.email ?? '-'}'),
                    Text(
                      '${PeopleStrings.phoneNumber}: '
                      '${state.input.phoneNumber ?? '-'}',
                    ),
                    if (state.input.address != null &&
                        state.input.address!.isNotEmpty)
                      Text('${PeopleStrings.address}: ${state.input.address}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
