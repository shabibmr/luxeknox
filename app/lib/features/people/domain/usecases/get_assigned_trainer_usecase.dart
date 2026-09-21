import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trainer_summary.dart';
import '../repositories/people_repository.dart';

@lazySingleton
class GetAssignedTrainerUseCase implements UseCase<TrainerSummary?, int> {
  const GetAssignedTrainerUseCase(this._peopleRepository);

  final PeopleRepository _peopleRepository;

  @override
  Future<Either<Failure, TrainerSummary?>> call(int memberId) async {
    final memberResult = await _peopleRepository.getMember(memberId);
    return memberResult.fold(
      (failure) => Left(failure),
      (person) async {
        final trainerId = person.assignedTrainerId;
        if (trainerId == null) {
          return const Right(null);
        }
        final trainersResult = await _peopleRepository.listTrainers();
        return trainersResult.fold(
          (failure) => Left(failure),
          (page) {
            final match =
                page.items.where((t) => t.id == trainerId).firstOrNull;
            if (match != null) {
              return Right(match);
            }
            return Right(
              TrainerSummary(
                id: trainerId,
                userId: 0,
                fullName: 'Trainer #$trainerId',
              ),
            );
          },
        );
      },
    );
  }
}
