import 'package:api_client/api_client.dart' as api;
import 'package:luxeknox/features/exercises/data/models/exercise_model.dart';
import 'package:luxeknox/features/exercises/domain/entities/exercise.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseModelMapper', () {
    test('round trip preserves every field (all fields populated)', () {
      final original = api.Exercise((b) {
        b
          ..id = 42
          ..name = 'Barbell Bench Press'
          ..primaryMuscleGroup = 'Chest'
          ..secondaryMuscles.replace(
            BuiltList<String>(['Triceps', 'Shoulders']),
          )
          ..equipmentNeeded = 'Barbell, Bench'
          ..instructions = 'Lie on the bench and press the bar.'
          ..videoUrl = 'https://example.com/video.mp4'
          ..gifUrl = 'https://example.com/exercise.gif'
          ..difficultyLevel = 'Intermediate'
          ..isActive = true;
      });

      final domain = original.toDomain();
      final roundTripped = domain.toModel();

      expect(roundTripped.id, original.id);
      expect(roundTripped.name, original.name);
      expect(roundTripped.primaryMuscleGroup, original.primaryMuscleGroup);
      expect(roundTripped.secondaryMuscles, original.secondaryMuscles);
      expect(roundTripped.equipmentNeeded, original.equipmentNeeded);
      expect(roundTripped.instructions, original.instructions);
      expect(roundTripped.videoUrl, original.videoUrl);
      expect(roundTripped.gifUrl, original.gifUrl);
      expect(roundTripped.difficultyLevel, original.difficultyLevel);
      expect(roundTripped.isActive, original.isActive);
      expect(roundTripped, original);
    });

    test('toDomain maps every field correctly', () {
      final model = api.Exercise((b) {
        b
          ..id = 7
          ..name = 'Squat'
          ..primaryMuscleGroup = 'Legs'
          ..secondaryMuscles.replace(BuiltList<String>(['Glutes']))
          ..equipmentNeeded = 'Barbell, Rack'
          ..instructions = 'Squat down and back up.'
          ..videoUrl = 'https://example.com/squat.mp4'
          ..gifUrl = 'https://example.com/squat.gif'
          ..difficultyLevel = 'Advanced'
          ..isActive = false;
      });

      final entity = model.toDomain();

      expect(entity.id, '7');
      expect(entity.name, 'Squat');
      expect(entity.primaryMuscleGroup, 'Legs');
      expect(entity.secondaryMuscles, ['Glutes']);
      expect(entity.equipmentNeeded, ['Barbell, Rack']);
      expect(entity.instructions, 'Squat down and back up.');
      expect(entity.videoUrl, 'https://example.com/squat.mp4');
      expect(entity.gifUrl, 'https://example.com/squat.gif');
      expect(entity.difficultyLevel, 'Advanced');
      expect(entity.isActive, false);
    });

    test('toModel maps every field correctly', () {
      const entity = Exercise(
        id: '9',
        name: 'Deadlift',
        primaryMuscleGroup: 'Back',
        secondaryMuscles: ['Hamstrings', 'Forearms'],
        equipmentNeeded: ['Barbell'],
        instructions: 'Lift the bar from the floor.',
        videoUrl: 'https://example.com/deadlift.mp4',
        gifUrl: 'https://example.com/deadlift.gif',
        difficultyLevel: 'Advanced',
        isActive: true,
      );

      final model = entity.toModel();

      expect(model.id, 9);
      expect(model.name, 'Deadlift');
      expect(model.primaryMuscleGroup, 'Back');
      expect(
        model.secondaryMuscles,
        BuiltList<String>(['Hamstrings', 'Forearms']),
      );
      expect(model.equipmentNeeded, 'Barbell');
      expect(model.instructions, 'Lift the bar from the floor.');
      expect(model.videoUrl, 'https://example.com/deadlift.mp4');
      expect(model.gifUrl, 'https://example.com/deadlift.gif');
      expect(model.difficultyLevel, 'Advanced');
      expect(model.isActive, true);
    });

    test('nullable API fields map to empty-safe domain defaults', () {
      final model = api.Exercise((b) {
        b
          ..id = 1
          ..name = 'Push Up'
          ..isActive = true;
      });

      final entity = model.toDomain();

      expect(entity.primaryMuscleGroup, '');
      expect(entity.secondaryMuscles, <String>[]);
      expect(entity.equipmentNeeded, <String>[]);
      expect(entity.instructions, '');
      expect(entity.difficultyLevel, '');
      expect(entity.videoUrl, isNull);
      expect(entity.gifUrl, isNull);
    });
  });
}
