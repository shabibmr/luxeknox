// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LuxeKnox';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String get emptyDefault => 'Nothing here yet';

  @override
  String get fieldRequired => 'This field is required';
}
