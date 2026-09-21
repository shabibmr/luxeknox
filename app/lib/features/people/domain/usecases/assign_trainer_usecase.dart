import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/person.dart';
import '../repositories/people_repository.dart';

class AssignTrainerParams extends Equatable {
  const AssignTrainerParams({
    required this.memberId,
    required this.trainerId,
    this.overrideCapacity,
    this.reason,
  });

  final int memberId;
  final int trainerId;
  final bool? overrideCapacity;
  final String? reason;

  @override
  List<Object?> get props => [memberId, trainerId, overrideCapacity, reason];
}

@lazySingleton
class AssignTrainerUseCase implements UseCase<Person, AssignTrainerParams> {
  const AssignTrainerUseCase(this._repository);

  final PeopleRepository _repository;

  @override
  Future<Either<Failure, Person>> call(AssignTrainerParams params) {
    return _repository.assignTrainer(
      memberId: params.memberId,
      trainerId: params.trainerId,
      overrideCapacity: params.overrideCapacity,
      reason: params.reason,
    );
  }
}
