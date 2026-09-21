import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule_catalog.dart';
import '../repositories/scheduling_repository.dart';

@lazySingleton
class ListFacilitiesUseCase implements UseCase<List<FacilityInfo>, NoParams> {
  const ListFacilitiesUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, List<FacilityInfo>>> call(NoParams params) {
    return _repository.listFacilities();
  }
}

class CreateFacilityParams extends Equatable {
  const CreateFacilityParams({
    required this.name,
    this.capacity,
    this.locationDetails,
    this.isActive,
  });

  final String name;
  final int? capacity;
  final String? locationDetails;
  final bool? isActive;

  @override
  List<Object?> get props => [name, capacity, locationDetails, isActive];
}

@lazySingleton
class CreateFacilityUseCase
    implements UseCase<FacilityInfo, CreateFacilityParams> {
  const CreateFacilityUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, FacilityInfo>> call(CreateFacilityParams params) {
    return _repository.createFacility(
      name: params.name,
      capacity: params.capacity,
      locationDetails: params.locationDetails,
      isActive: params.isActive,
    );
  }
}

@lazySingleton
class ListScheduleTypesUseCase
    implements UseCase<List<ScheduleTypeInfo>, NoParams> {
  const ListScheduleTypesUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, List<ScheduleTypeInfo>>> call(NoParams params) {
    return _repository.listScheduleTypes();
  }
}

@lazySingleton
class GetTrainerAvailabilityUseCase
    implements UseCase<List<TrainerAvailabilitySlot>, String> {
  const GetTrainerAvailabilityUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, List<TrainerAvailabilitySlot>>> call(String trainerId) {
    return _repository.getTrainerAvailability(trainerId);
  }
}

class PutTrainerAvailabilityParams extends Equatable {
  const PutTrainerAvailabilityParams({
    required this.trainerId,
    required this.slots,
  });

  final String trainerId;
  final List<TrainerAvailabilitySlot> slots;

  @override
  List<Object?> get props => [trainerId, slots];
}

@lazySingleton
class PutTrainerAvailabilityUseCase
    implements
        UseCase<List<TrainerAvailabilitySlot>, PutTrainerAvailabilityParams> {
  const PutTrainerAvailabilityUseCase(this._repository);

  final SchedulingRepository _repository;

  @override
  Future<Either<Failure, List<TrainerAvailabilitySlot>>> call(
    PutTrainerAvailabilityParams params,
  ) {
    return _repository.putTrainerAvailability(
      trainerId: params.trainerId,
      slots: params.slots,
    );
  }
}
