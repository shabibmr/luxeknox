import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/exercises/domain/entities/exercise.dart';

void main() {
  group('Exercise', () {
    test('should have value equality', () {
      const exercise1 = Exercise(
        id: '1',
        name: 'Bench Press',
        primaryMuscleGroup: 'Chest',
        secondaryMuscles: ['Shoulders', 'Triceps'],
        equipmentNeeded: ['Barbell', 'Bench'],
        instructions: 'Push the bar up from chest level',
        videoUrl: 'https://example.com/bench_press.mp4',
        gifUrl: 'https://example.com/bench_press.gif',
        difficultyLevel: 'Intermediate',
        isActive: true,
      );

      const exercise2 = Exercise(
        id: '1',
        name: 'Bench Press',
        primaryMuscleGroup: 'Chest',
        secondaryMuscles: ['Shoulders', 'Triceps'],
        equipmentNeeded: ['Barbell', 'Bench'],
        instructions: 'Push the bar up from chest level',
        videoUrl: 'https://example.com/bench_press.mp4',
        gifUrl: 'https://example.com/bench_press.gif',
        difficultyLevel: 'Intermediate',
        isActive: true,
      );

      expect(exercise1, exercise2);
    });

    test('should not be equal when fields differ', () {
      const exercise1 = Exercise(
        id: '1',
        name: 'Bench Press',
        primaryMuscleGroup: 'Chest',
        secondaryMuscles: ['Shoulders', 'Triceps'],
        equipmentNeeded: ['Barbell', 'Bench'],
        instructions: 'Push the bar up from chest level',
        videoUrl: 'https://example.com/bench_press.mp4',
        gifUrl: 'https://example.com/bench_press.gif',
        difficultyLevel: 'Intermediate',
        isActive: true,
      );

      const exercise2 = Exercise(
        id: '2',
        name: 'Bench Press',
        primaryMuscleGroup: 'Chest',
        secondaryMuscles: ['Shoulders', 'Triceps'],
        equipmentNeeded: ['Barbell', 'Bench'],
        instructions: 'Push the bar up from chest level',
        videoUrl: 'https://example.com/bench_press.mp4',
        gifUrl: 'https://example.com/bench_press.gif',
        difficultyLevel: 'Intermediate',
        isActive: true,
      );

      expect(exercise1, isNot(exercise2));
    });

    test('should handle nullable fields', () {
      const exercise1 = Exercise(
        id: '1',
        name: 'Pushup',
        primaryMuscleGroup: 'Chest',
        secondaryMuscles: ['Shoulders'],
        equipmentNeeded: [],
        instructions: 'Do pushups',
        difficultyLevel: 'Beginner',
        isActive: true,
      );

      const exercise2 = Exercise(
        id: '1',
        name: 'Pushup',
        primaryMuscleGroup: 'Chest',
        secondaryMuscles: ['Shoulders'],
        equipmentNeeded: [],
        instructions: 'Do pushups',
        videoUrl: null,
        gifUrl: null,
        difficultyLevel: 'Beginner',
        isActive: true,
      );

      expect(exercise1, exercise2);
    });
  });
}
