import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../people_strings.dart';
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
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
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
            onStepContinue: state.step == AddMemberWizardState.stepCount - 1
                ? cubit.submit
                : cubit.nextStep,
            onStepCancel: state.step == 0 ? null : cubit.previousStep,
            controlsBuilder: (context, details) {
              final isLast = state.step == AddMemberWizardState.stepCount - 1;
              // Stepper's AnimatedCrossFade can pass tight infinite width into
              // controls. Align.loosen() + widthFactor shrink-wrap so
              // FilledButton's internal ConstrainedBox never sees
              // minWidth: Infinity (BoxConstraints forces an infinite width).
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
                      controller: _firstNameController
                        ..text = state.input.firstName,
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.firstName,
                      ),
                      onChanged: (value) => cubit.updateInput(
                        (i) => i.copyWith(firstName: value),
                      ),
                    ),
                    TextField(
                      controller: _lastNameController
                        ..text = state.input.lastName,
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.lastName,
                      ),
                      onChanged: (value) =>
                          cubit.updateInput((i) => i.copyWith(lastName: value)),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.gender,
                      ),
                      onChanged: (value) =>
                          cubit.updateInput((i) => i.copyWith(gender: value)),
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
                      controller: _emailController
                        ..text = state.input.email ?? '',
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.email,
                      ),
                      onChanged: (value) =>
                          cubit.updateInput((i) => i.copyWith(email: value)),
                    ),
                    TextField(
                      controller: _phoneController
                        ..text = state.input.phoneNumber ?? '',
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.phoneNumber,
                      ),
                      onChanged: (value) => cubit.updateInput(
                        (i) => i.copyWith(phoneNumber: value),
                      ),
                    ),
                    TextField(
                      controller: _passwordController
                        ..text = state.input.password ?? '',
                      decoration: const InputDecoration(
                        labelText: PeopleStrings.password,
                      ),
                      obscureText: true,
                      onChanged: (value) =>
                          cubit.updateInput((i) => i.copyWith(password: value)),
                    ),
                    TextField(
                      controller: _addressController
                        ..text = state.input.address ?? '',
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
                    Text('${PeopleStrings.email}: ${state.input.email ?? '-'}'),
                    Text(
                      '${PeopleStrings.phoneNumber}: '
                      '${state.input.phoneNumber ?? '-'}',
                    ),
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
