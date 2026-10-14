import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/membership_product.dart';

extension MembershipProductModelMapper on api.MembershipProduct {
  MembershipProduct toDomain() {
    return MembershipProduct(
      id: id.toString(),
      name: name,
      code: code,
      description: description,
      durationDays: durationDays,
      basePrice: basePrice,
      taxPercentage: taxPercentage,
      maxFreezeDays: maxFreezeDays,
      ptSessionsIncluded: ptSessionsIncluded,
      accessFacilities: accessFacilities?.toList() ?? const [],
      isActive: isActive,
      packageType: packageType == api.MembershipPackageType.couple
          ? MembershipPackageType.couple
          : MembershipPackageType.single,
    );
  }
}

extension MembershipProductEntityMapper on MembershipProduct {
  api.MembershipProductWrite toWriteModel() {
    return api.MembershipProductWrite((b) {
      b
        ..name = name
        ..code = code
        ..description = description
        ..durationDays = durationDays
        ..basePrice = basePrice
        ..taxPercentage = taxPercentage
        ..maxFreezeDays = maxFreezeDays
        ..ptSessionsIncluded = ptSessionsIncluded
        ..accessFacilities.addAll(accessFacilities)
        ..isActive = isActive
        ..packageType = packageType == MembershipPackageType.couple
            ? api.MembershipPackageType.couple
            : api.MembershipPackageType.single;
    });
  }
}
