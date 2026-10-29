import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/par_q_inputs.dart';
import '../entities/par_q_screening.dart';

/// PAR-Q+ health screening and the PT safety gate (screen 04).
abstract class ParQRepository {
  Future<Either<Failure, ParQScreening>> submit(ParQSubmission submission);

  Future<Either<Failure, ParQScreening>> trainerReview(
    ParQTrainerReviewInput review,
  );

  Future<Either<Failure, ParQScreening>> clear(ParQClearanceInput clearance);
}
