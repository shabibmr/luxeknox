import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../auth_strings.dart';
import '../cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, this.initialToken});

  final String? initialToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: _ResetPasswordForm(initialToken: initialToken),
    );
  }
}

class _ResetPasswordForm extends StatefulWidget {
  const _ResetPasswordForm({this.initialToken});

  final String? initialToken;

  @override
  State<_ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<_ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: widget.initialToken ?? '');
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ResetPasswordCubit>().submit(
      token: _tokenController.text,
      newPassword: _passwordController.text,
      confirmPassword: _confirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.resetPasswordTitle)),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetPasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AuthStrings.passwordChanged)),
            );
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          final submitting = state.status == ResetPasswordStatus.submitting;
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
                      if (state.status == ResetPasswordStatus.failure &&
                          state.errorMessage != null) ...[
                        Text(state.errorMessage!),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _tokenController,
                        enabled: !submitting,
                        decoration: const InputDecoration(
                          labelText: AuthStrings.resetToken,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? AuthStrings.enterResetToken
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
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
                        validator: (value) => value != _passwordController.text
                            ? AuthStrings.passwordsDoNotMatch
                            : null,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: submitting ? null : _submit,
                        child: const Text(AuthStrings.saveNewPassword),
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
