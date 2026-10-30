import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/lifestyle_intake.dart';

/// Member lifestyle & habits consultation (member dossier).
abstract class LifestyleIntakeRepository {
  /// [NotFoundFailure] when the member has no intake yet.
  Future<Either<Failure, LifestyleIntake>> get(int memberId);

  /// Creates the intake, or replaces it if one exists.
  Future<Either<Failure, LifestyleIntake>> save(LifestyleIntakeInput input);
}
