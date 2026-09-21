import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../auth_strings.dart';
import '../cubit/change_password_cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChangePasswordCubit>(),
      child: const _ChangePasswordForm(),
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm();

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangePasswordCubit>().submit(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
      confirmPassword: _confirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.changePasswordTitle)),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AuthStrings.passwordChanged)),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          final submitting = state.status == ChangePasswordStatus.submitting;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.status == ChangePasswordStatus.failure &&
                          state.errorMessage != null) ...[
                        Text(state.errorMessage!),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _currentController,
                        enabled: !submitting,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: AuthStrings.currentPassword,
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty)
                            ? AuthStrings.enterPassword
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newController,
                        enabled: !submitting,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: AuthStrings.newPassword,
                        ),
                        validator: (value) =>
                            (value == null || value.length < 8)
                            ? AuthStrings.passwordTooShort
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmController,
                        enabled: !submitting,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: AuthStrings.confirmPassword,
                        ),
                        validator: (value) => value != _newController.text
                            ? AuthStrings.passwordsDoNotMatch
                            : null,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: submitting ? null : _submit,
                        child: const Text(AuthStrings.changePassword),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
