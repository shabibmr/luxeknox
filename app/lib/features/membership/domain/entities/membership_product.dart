import 'package:equatable/equatable.dart';

/// Whether a package covers one member or two (a couple package's price is
/// the total for both members).
enum MembershipPackageType { single, couple }

/// A sellable membership package (FR-MEMB-001). [basePrice] and
/// [taxPercentage] are decimal strings (FR-API-005) — never parsed to
/// double for display or storage, only for arithmetic when needed.
class MembershipProduct extends Equatable {
  const MembershipProduct({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.durationDays,
    required this.basePrice,
    this.taxPercentage,
    this.maxFreezeDays,
    this.ptSessionsIncluded,
    this.accessFacilities = const [],
    required this.isActive,
    this.packageType = MembershipPackageType.single,
  });

  final String id;
  final String name;
  final String code;
  final String? description;
  final int durationDays;
  final String basePrice;
  final String? taxPercentage;
  final int? maxFreezeDays;
  final int? ptSessionsIncluded;
  final List<String> accessFacilities;
  final bool isActive;
  final MembershipPackageType packageType;

  bool get isCouple => packageType == MembershipPackageType.couple;

  MembershipProduct copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    int? durationDays,
    String? basePrice,
    String? taxPercentage,
    int? maxFreezeDays,
    int? ptSessionsIncluded,
    List<String>? accessFacilities,
    bool? isActive,
    MembershipPackageType? packageType,
  }) {
    return MembershipProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      durationDays: durationDays ?? this.durationDays,
      basePrice: basePrice ?? this.basePrice,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      maxFreezeDays: maxFreezeDays ?? this.maxFreezeDays,
      ptSessionsIncluded: ptSessionsIncluded ?? this.ptSessionsIncluded,
      accessFacilities: accessFacilities ?? this.accessFacilities,
      isActive: isActive ?? this.isActive,
      packageType: packageType ?? this.packageType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    description,
    durationDays,
    basePrice,
    taxPercentage,
    maxFreezeDays,
    ptSessionsIncluded,
    accessFacilities,
    isActive,
    packageType,
  ];
}
