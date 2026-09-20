import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/food.dart';

/// Maps between the generated `api.Food` model (from `packages/api_client`,
/// built from `docs/openapi/v1.yaml`) and the domain `Food` entity.
///
/// KNOWN CONTRACT MISMATCH (flagged, not invented silently — same convention
/// as `ExerciseModelMapper`): `id` is `integer` on the OpenAPI schema but
/// `String` on the domain entity; mapped via `toString()` / `int.parse(...)`.
/// The nutrition fields (`serving_size`, `calories`, `protein_grams`,
/// `carbs_grams`, `fat_grams`, `fiber_grams`) are `num?` on the wire and
/// mapped to `double?` losslessly via `toDouble()`.
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
        // `is_active` has no domain-side representation yet — see the
        // `FoodFilter` KNOWN CONTRACT MISMATCH doc comment. `api.Food.isActive`
        // is non-nullable, so a value must be supplied to build; default true.
        ..isActive = true;
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
        ..isVerified = isVerified;
    });
  }
}

/// Free function form, for callers that prefer it over the extensions.
Food toDomain(api.Food model) => model.toDomain();

/// Free function form, for callers that prefer it over the extensions.
api.Food toModel(Food entity) => entity.toModel();
