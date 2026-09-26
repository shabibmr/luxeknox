import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/food.dart';

/// Maps between the generated `api.Food` model (from `packages/api_client`,
/// built from `docs/openapi/v1.yaml`) and the domain `Food` entity.
///
/// `id` is `integer` on the OpenAPI schema but `String` on the domain entity;
/// mapped via `toString()` / `int.parse(...)`. Nutrition fields are `num?` on
/// the wire and mapped to `double?` via `toDouble()`.
extension FoodModelMapper on api.Food {
  Food toDomain() {
    return Food(
      id: id.toString(),
      name: name,
      servingUnit: servingUnit,
      servingSize: servingSize?.toDouble(),
      calories: calories?.toDouble(),
      proteinGrams: proteinGrams?.toDouble(),
      carbsGrams: carbsGrams?.toDouble(),
      fatGrams: fatGrams?.toDouble(),
      fiberGrams: fiberGrams?.toDouble(),
      isVerified: isVerified ?? false,
      isActive: isActive,
    );
  }
}

extension FoodEntityMapper on Food {
  api.Food toModel() {
    return api.Food((b) {
      b
        ..id = int.parse(id)
        ..name = name
        ..servingUnit = servingUnit
        ..servingSize = servingSize
        ..calories = calories
        ..proteinGrams = proteinGrams
        ..carbsGrams = carbsGrams
        ..fatGrams = fatGrams
        ..fiberGrams = fiberGrams
        ..isVerified = isVerified
        ..isActive = isActive;
    });
  }

  api.FoodWrite toWriteModel() {
    return api.FoodWrite((b) {
      b
        ..name = name
        ..servingUnit = servingUnit
        ..servingSize = servingSize
        ..calories = calories
        ..proteinGrams = proteinGrams
        ..carbsGrams = carbsGrams
        ..fatGrams = fatGrams
        ..fiberGrams = fiberGrams
        ..isVerified = isVerified
        ..isActive = isActive;
    });
  }
}

/// Free function form, for callers that prefer it over the extensions.
Food toDomain(api.Food model) => model.toDomain();

/// Free function form, for callers that prefer it over the extensions.
api.Food toModel(Food entity) => entity.toModel();
