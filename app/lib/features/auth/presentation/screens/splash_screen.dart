import 'package:flutter/material.dart';

/// Shown while the session is `unknown`. `main` starts `SessionCubit.restore()`,
/// which resolves to authenticated/unauthenticated and lets the router
/// redirect away from here — this screen never navigates imperatively.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo/luxeknox_logo.png', height: 72),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
