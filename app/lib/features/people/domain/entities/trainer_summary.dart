import 'package:equatable/equatable.dart';

/// Lightweight trainer row for admin/trainer directories.
class TrainerSummary extends Equatable {
  const TrainerSummary({
    required this.id,
    required this.userId,
    required this.fullName,
    this.specializations = const [],
    this.hourlyRate,
    this.rating,
    this.maxClientsCapacity,
    this.assignedActiveCount,
    this.isActive = true,
  });

  final int id;
  final int userId;
  final String fullName;
  final List<String> specializations;
  final String? hourlyRate;
  final double? rating;
  final int? maxClientsCapacity;
  final int? assignedActiveCount;
  final bool isActive;

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    specializations,
    hourlyRate,
    rating,
    maxClientsCapacity,
    assignedActiveCount,
    isActive,
  ];
}
