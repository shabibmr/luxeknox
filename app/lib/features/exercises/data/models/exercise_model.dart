import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/exercise.dart';

/// Maps between the generated `api.Exercise` model (from
/// `packages/api_client`, built from `docs/openapi/v1.yaml`) and the domain
/// `Exercise` entity.
///
/// KNOWN CONTRACT MISMATCHES (flagged, not invented silently — see J2 report):
/// The OpenAPI `Exercise` schema and the domain entity (I1) disagree on shape
/// for several fields. The conventions below are this mapper's best-effort,
/// explicit, and round-trip-safe resolution. They are NOT specified by the
/// OpenAPI document and should be confirmed with whoever owns the contract:
///
/// * `id`: OpenAPI schema declares it `integer`; the domain entity declares
///   it `String`. Mapped via `toString()` / `int.parse(...)`.
/// * `primary_muscle_group`, `secondary_muscles`, `instructions`,
///   `difficulty_level`: nullable in the OpenAPI schema, but non-nullable in
///   the domain entity. A `null` from the API is mapped to `''` / `const []`
///   on the way in; the reverse mapping never re-introduces `null` (so a
///   round trip starting from a non-null domain entity is stable, but a
///   round trip starting from an API payload with `null` in these fields is
///   NOT byte-for-byte stable — it becomes `''`/`[]`).
/// * `equipment_needed`: OpenAPI types this as a single nullable `string`;
///   the domain entity types it as `List<String>`. The API string is treated
///   as ONE list element (never comma-split). Null/empty API → `[]`; write-back
///   uses the single element (or `null` when empty). Commas inside the string
///   are part of the value, not separators.
extension ExerciseModelMapper on api.Exercise {
  Exercise toDomain() {
    return Exercise(
      id: id.toString(),
      name: name,
      primaryMuscleGroup: primaryMuscleGroup ?? '',
      secondaryMuscles: secondaryMuscles?.toList() ?? const <String>[],
      equipmentNeeded: _equipmentToDomain(equipmentNeeded),
      instructions: instructions ?? '',
      videoUrl: videoUrl,
      gifUrl: gifUrl,
      difficultyLevel: difficultyLevel ?? '',
      isActive: isActive,
    );
  }
}

extension ExerciseEntityMapper on Exercise {
  api.Exercise toModel() {
    return api.Exercise((b) {
      b
        ..id = int.parse(id)
        ..name = name
        ..primaryMuscleGroup = primaryMuscleGroup
        ..secondaryMuscles.addAll(secondaryMuscles)
        ..equipmentNeeded = _equipmentToApi(equipmentNeeded)
        ..instructions = instructions
        ..videoUrl = videoUrl
        ..gifUrl = gifUrl
        ..difficultyLevel = difficultyLevel
        ..isActive = isActive;
    });
  }

  api.ExerciseWrite toWriteModel() {
    return api.ExerciseWrite((b) {
      b
        ..name = name
        ..primaryMuscleGroup = primaryMuscleGroup.isNotEmpty
            ? primaryMuscleGroup
            : null
        ..secondaryMuscles.addAll(secondaryMuscles)
        ..equipmentNeeded = _equipmentToApi(equipmentNeeded)
        ..instructions = instructions.isNotEmpty ? instructions : null
        ..videoUrl = videoUrl
        ..gifUrl = gifUrl
        ..difficultyLevel = difficultyLevel.isNotEmpty ? difficultyLevel : null
        ..isActive = isActive;
    });
  }
}

/// API string → domain list: null/empty → []; otherwise the whole string is
/// one element (commas are not separators).
List<String> _equipmentToDomain(String? raw) {
  if (raw == null || raw.isEmpty) return const <String>[];
  return [raw];
}

/// Domain list → API string: empty → null; prefer the sole element.
String? _equipmentToApi(List<String> items) {
  if (items.isEmpty) return null;
  return items.length == 1 ? items.single : items.first;
}

/// Free function form, for callers that prefer it over the extensions.
Exercise toDomain(api.Exercise model) => model.toDomain();

/// Free function form, for callers that prefer it over the extensions.
api.Exercise toModel(Exercise entity) => entity.toModel();
