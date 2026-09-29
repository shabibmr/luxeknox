import 'package:equatable/equatable.dart';

/// A sellable Personal Training package. Independent of the gym membership
/// package: it fixes the PT duration, how many sessions per week (i.e. how many
/// weekdays the member's recurring slot covers) and the price.
///
/// [basePrice] / [taxPercentage] are decimal strings (FR-API-005).
class PtProduct extends Equatable {
  const PtProduct({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.durationDays,
    required this.sessionsPerWeek,
    required this.basePrice,
    this.taxPercentage,
    required this.isActive,
  });

  final int id;
  final String name;
  final String code;
  final String? description;
  final int durationDays;
  final int sessionsPerWeek;
  final String basePrice;
  final String? taxPercentage;
  final bool isActive;

  PtProduct copyWith({
    String? name,
    String? code,
    String? description,
    int? durationDays,
    int? sessionsPerWeek,
    String? basePrice,
    String? taxPercentage,
    bool? isActive,
  }) {
    return PtProduct(
      id: id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      durationDays: durationDays ?? this.durationDays,
      sessionsPerWeek: sessionsPerWeek ?? this.sessionsPerWeek,
      basePrice: basePrice ?? this.basePrice,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    description,
    durationDays,
    sessionsPerWeek,
    basePrice,
    taxPercentage,
    isActive,
  ];
}
