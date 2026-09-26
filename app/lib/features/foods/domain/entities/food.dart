import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final String servingUnit;
  final double? servingSize;
  final double? calories;
  final double? proteinGrams;
  final double? carbsGrams;
  final double? fatGrams;
  final double? fiberGrams;
  final bool isVerified;
  final bool isActive;

  const Food({
    required this.id,
    required this.name,
    required this.servingUnit,
    this.servingSize,
    this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.fiberGrams,
    required this.isVerified,
    this.isActive = true,
  });

  Food copyWith({
    String? id,
    String? name,
    String? servingUnit,
    double? servingSize,
    double? calories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    double? fiberGrams,
    bool? isVerified,
    bool? isActive,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      servingUnit: servingUnit ?? this.servingUnit,
      servingSize: servingSize ?? this.servingSize,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      fiberGrams: fiberGrams ?? this.fiberGrams,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    servingUnit,
    servingSize,
    calories,
    proteinGrams,
    carbsGrams,
    fatGrams,
    fiberGrams,
    isVerified,
    isActive,
  ];
}
