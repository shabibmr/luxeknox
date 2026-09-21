import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/dashboard_snapshot.dart';
import '../repositories/dashboard_repository.dart';

@lazySingleton
class GetDashboardUseCase implements UseCase<DashboardSnapshot, NoParams> {
  const GetDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  @override
  Future<Either<Failure, DashboardSnapshot>> call(NoParams params) {
    return _repository.getDashboard();
  }
}
