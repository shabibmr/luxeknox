import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../domain/entities/lifestyle_intake.dart';
import '../../domain/repositories/lifestyle_intake_repository.dart';
import '../datasources/lifestyle_intake_remote_datasource.dart';
import '../models/lifestyle_intake_mapper.dart';

@LazySingleton(as: LifestyleIntakeRepository)
class LifestyleIntakeRepositoryImpl implements LifestyleIntakeRepository {
  LifestyleIntakeRepositoryImpl(this._remote);

  final LifestyleIntakeRemoteDataSource _remote;

  @override
  Future<Either<Failure, LifestyleIntake>> get(int memberId) async {
    try {
      return Right(lifestyleIntakeFromApi(await _remote.get(memberId)));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LifestyleIntake>> save(
    LifestyleIntakeInput input,
  ) async {
    final problems = _validate(input);
    if (problems.isNotEmpty) {
      return Left(ValidationFailure(problems));
    }
    try {
      final saved = await _remote.put(
        input.memberId,
        lifestyleIntakeToApi(input),
      );
      return Right(lifestyleIntakeFromApi(saved));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  /// Mirrors the server's rules so the form can be refused without a call.
  List<String> _validate(LifestyleIntakeInput input) {
    final problems = <String>[];
    if (input.stressLevel < LifestyleIntakeInput.minStress ||
        input.stressLevel > LifestyleIntakeInput.maxStress) {
      problems.add(
        'Stress level must be between ${LifestyleIntakeInput.minStress} '
        'and ${LifestyleIntakeInput.maxStress}',
      );
    }
    final sleep = input.sleepHoursTypical;
    // Tolerance: 1.1 * 10 is 11.000000000000002 in binary floating point.
    if (sleep != null && ((sleep * 10) - (sleep * 10).round()).abs() > 1e-9) {
      problems.add('Sleep hours allow at most one decimal place');
    }
    if (sleep != null && (sleep < 0 || sleep > 24)) {
      problems.add('Sleep hours must be between 0 and 24');
    }
    final steps = input.typicalDailySteps;
    if (steps != null && (steps < 0 || steps > 200000)) {
      problems.add('Daily steps must be between 0 and 200000');
    }
    if (input.priorities.any(
      (p) => p.currentStatus.trim().isEmpty || p.firstAction.trim().isEmpty,
    )) {
      problems.add('Each priority needs a current status and a first action');
    }
    final domains = input.priorities.map((p) => p.domain).toSet();
    if (input.priorities.length != LifestylePriorityDomain.values.length ||
        domains.length != LifestylePriorityDomain.values.length) {
      problems.add(
        'Provide exactly one priority each for sleep, nutrition, activity '
        'and recovery',
      );
    }
    return problems;
  }
}
