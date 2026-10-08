import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/config/resolve_remote_app_config.dart';
import 'core/di/injector.dart';
import 'core/l10n/app_locale_config.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/data/services/fcm_messaging_service.dart';
import 'l10n/app_localizations.dart';
import 'session/presentation/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await resolveRemoteAppConfig();
  configureDependencies();
  // Start before the first frame; the splash shows until it resolves.
  unawaited(getIt<SessionCubit>().restore());
  runApp(const LuxeKnoxApp());
  unawaited(getIt<FcmMessagingService>().start());
}

class LuxeKnoxApp extends StatelessWidget {
  const LuxeKnoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SessionCubit>(),
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        locale: AppLocaleConfig.fallback,
        supportedLocales: AppLocaleConfig.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: getIt<GoRouter>(),
      ),
    );
  }
}
