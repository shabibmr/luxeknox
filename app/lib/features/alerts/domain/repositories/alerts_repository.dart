import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/system_alert.dart';

abstract class AlertsRepository {
  Future<Either<Failure, CursorPage<SystemAlert>>> listAlerts({String? cursor});
}
