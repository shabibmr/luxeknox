import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../auth_strings.dart';
import '../cubit/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: const _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ForgotPasswordCubit>().submit(_identifierController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.forgotPasswordTitle)),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AuthStrings.resetLinkSent)),
            );
            context.go(Routes.resetPassword);
          }
        },
        builder: (context, state) {
          final submitting = state.status == ForgotPasswordStatus.submitting;
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
                      if (state.status == ForgotPasswordStatus.failure &&
                          state.errorMessage != null) ...[
                        Text(state.errorMessage!),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _identifierController,
                        enabled: !submitting,
                        decoration: const InputDecoration(
                          labelText: AuthStrings.emailOrPhone,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? AuthStrings.enterEmailOrPhone
                            : null,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: submitting ? null : _submit,
                        child: Text(
                          submitting
                              ? '…'
                              : AuthStrings.sendResetLink,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(Routes.login),
                        child: const Text(AuthStrings.signIn),
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
