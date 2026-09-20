import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injector.dart';
import 'session/presentation/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const LuxeKnoxApp());
}

class LuxeKnoxApp extends StatelessWidget {
  const LuxeKnoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SessionCubit>(),
      child: MaterialApp.router(
        title: 'LuxeKnox',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1B1B1B),
          useMaterial3: true,
        ),
        routerConfig: getIt<GoRouter>(),
      ),
    );
  }
}
