import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String primaryMuscleGroup;
  final List<String> secondaryMuscles;
  final List<String> equipmentNeeded;
  final String instructions;
  final String? videoUrl;
  final String? gifUrl;
  final String difficultyLevel;
  final bool isActive;

  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscleGroup,
    required this.secondaryMuscles,
    required this.equipmentNeeded,
    required this.instructions,
    this.videoUrl,
    this.gifUrl,
    required this.difficultyLevel,
    required this.isActive,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? primaryMuscleGroup,
    List<String>? secondaryMuscles,
    List<String>? equipmentNeeded,
    String? instructions,
    String? videoUrl,
    String? gifUrl,
    String? difficultyLevel,
    bool? isActive,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipmentNeeded: equipmentNeeded ?? this.equipmentNeeded,
      instructions: instructions ?? this.instructions,
      videoUrl: videoUrl ?? this.videoUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    primaryMuscleGroup,
    secondaryMuscles,
    equipmentNeeded,
    instructions,
    videoUrl,
    gifUrl,
    difficultyLevel,
    isActive,
  ];
}
