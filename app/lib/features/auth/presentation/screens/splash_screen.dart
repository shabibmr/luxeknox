import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../session/presentation/session_cubit.dart';

/// Shown while [SessionCubit] is `unknown`. Kicks off `restore()`, which
/// resolves to authenticated/unauthenticated and lets the router redirect
/// away from here — this screen never navigates imperatively.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionCubit>().restore();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
