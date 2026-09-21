import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/dashboard_snapshot.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSnapshot>> getDashboard();
}
