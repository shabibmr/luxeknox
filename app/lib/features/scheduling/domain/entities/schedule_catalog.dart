import 'package:equatable/equatable.dart';

class ScheduleTypeInfo extends Equatable {
  const ScheduleTypeInfo({
    required this.id,
    required this.name,
    this.colorCode,
    this.defaultDurationMinutes,
    this.requiresTrainer,
  });

  final String id;
  final String name;
  final String? colorCode;
  final int? defaultDurationMinutes;
  final bool? requiresTrainer;

  @override
  List<Object?> get props => [
    id,
    name,
    colorCode,
    defaultDurationMinutes,
    requiresTrainer,
  ];
}

class FacilityInfo extends Equatable {
  const FacilityInfo({
    required this.id,
    required this.name,
    this.capacity,
    this.locationDetails,
    required this.isActive,
  });

  final String id;
  final String name;
  final int? capacity;
  final String? locationDetails;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, capacity, locationDetails, isActive];
}

class TrainerAvailabilitySlot extends Equatable {
  const TrainerAvailabilitySlot({
    required this.id,
    required this.trainerId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.isRecurring,
    this.overrideDate,
    required this.isAvailable,
  });

  final String id;
  final String trainerId;
  final int? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final bool? isRecurring;
  final DateTime? overrideDate;
  final bool isAvailable;

  @override
  List<Object?> get props => [
    id,
    trainerId,
    dayOfWeek,
    startTime,
    endTime,
    isRecurring,
    overrideDate,
    isAvailable,
  ];
}
