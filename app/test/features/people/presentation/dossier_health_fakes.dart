import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/domain/entities/lifestyle_intake.dart';
import 'package:luxeknox/features/people/domain/entities/par_q_screening.dart';
import 'package:luxeknox/features/people/domain/usecases/get_lifestyle_intake_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/get_par_q_usecase.dart';

/// For dossier tests that don't care about health data: the member has no
/// PAR-Q+ screening on file.
class NoParQOnFile implements GetParQUseCase {
  @override
  Future<Either<Failure, ParQScreening>> call(int params) async =>
      const Left(NotFoundFailure());
}

/// For dossier tests that don't care about health data: the member has no
/// lifestyle intake on file.
class NoLifestyleOnFile implements GetLifestyleIntakeUseCase {
  @override
  Future<Either<Failure, LifestyleIntake>> call(int params) async =>
      const Left(NotFoundFailure());
}
