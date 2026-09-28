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
        ..isActive = isActive;
    });
  }
}
