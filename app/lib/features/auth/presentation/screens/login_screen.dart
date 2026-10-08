import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config_bootstrap.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../auth_strings.dart';
import '../cubit/login_cubit.dart';
import '../widgets/google_sign_in_button.dart';

/// google_sign_in has native implementations only for Android and iOS; web uses a
/// Firebase popup. Desktop has neither, so the button would always fail there.
bool get _supportsGoogleSignIn =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().submit(
      _identifierController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.signInTitle)),
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final isGoogleSubmitting = state.isGoogleSubmitting;
          final isSubmitting = state.status == LoadStatus.loading;
          final isEmailSubmitting = isSubmitting && !isGoogleSubmitting;
          return Center(
            child: SingleChildScrollView(
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
                      Image.asset(
                        'assets/logo/luxeknox_logo.png',
                        height: 80,
                        semanticLabel: 'LuxeKnox',
                      ),
                      const SizedBox(height: 32),
                      if (state.status == LoadStatus.failure &&
                          state.errorMessage != null) ...[
                        MaterialBanner(
                          content: Text(state.errorMessage!),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.errorContainer,
                          actions: const [SizedBox.shrink()],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_supportsGoogleSignIn) ...[
                        GoogleSignInButton(
                          isLoading: state.isGoogleSubmitting,
                          onPressed: isSubmitting
                              ? null
                              : () => context.read<LoginCubit>().signInWithGoogle(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                AuthStrings.orDivider,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                      TextFormField(
                        controller: _identifierController,
                        enabled: !isSubmitting,
                        decoration: const InputDecoration(
                          labelText: AuthStrings.emailOrPhone,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? AuthStrings.enterEmailOrPhone
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !isSubmitting,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: AuthStrings.password,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        autofillHints: const [AutofillHints.password],
                        validator: (value) => (value == null || value.isEmpty)
                            ? AuthStrings.enterPassword
                            : null,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: isSubmitting ? null : _submit,
                        child: isEmailSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(AuthStrings.signIn),
                      ),
                      TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () => context.go(Routes.forgotPassword),
                        child: const Text(AuthStrings.forgotPassword),
                      ),
                      if (!kReleaseMode && AppConfigBootstrap.resolved != null) ...[
                        const SizedBox(height: 16),
                        // Debug aid: shows which API the app is talking to.
                        SelectableText(
                          'API: ${AppConfigBootstrap.resolved!.apiBaseUrl}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
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
