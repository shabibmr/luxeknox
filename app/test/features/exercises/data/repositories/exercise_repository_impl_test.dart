import 'package:api_client/api_client.dart' as api;
import 'package:app/core/error/failures.dart';
import 'package:app/features/exercises/data/datasources/exercise_remote_datasource.dart';
import 'package:app/features/exercises/data/repositories/exercise_repository_impl.dart';
import 'package:app/features/exercises/domain/entities/exercise_filter.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockExerciseRemoteDataSource extends Mock
    implements ExerciseRemoteDataSource {}

void main() {
  late MockExerciseRemoteDataSource mockDataSource;
  late ExerciseRepositoryImpl repository;

  final tApiModel = api.Exercise((b) {
    b
      ..id = 1
      ..name = 'Bench Press'
      ..primaryMuscleGroup = 'Chest'
      ..secondaryMuscles.replace(BuiltList<String>(['Triceps']))
      ..equipmentNeeded = 'Barbell'
      ..instructions = 'Press bar'
      ..videoUrl = 'https://example.com/v.mp4'
      ..gifUrl = 'https://example.com/g.gif'
      ..difficultyLevel = 'Intermediate'
      ..isActive = true;
  });

  setUpAll(() {
    registerFallbackValue(api.ExerciseWrite((b) => b..name = 'fallback'));
    registerFallbackValue(const ExerciseFilter());
  });

  setUp(() {
    mockDataSource = MockExerciseRemoteDataSource();
    repository = ExerciseRepositoryImpl(mockDataSource);
  });

  group('ExerciseRepositoryImpl (J3)', () {
    test('getExercises returns mapped CursorPage on success', () async {
      final tPage = api.ExercisePage((b) {
        b
          ..data.replace(BuiltList<api.Exercise>([tApiModel]))
          ..meta.limit = 20
          ..meta.nextCursor = 'cursor123'
          ..meta.hasMore = true;
      });

      when(
        () => mockDataSource.getExercises(
          filter: any(named: 'filter'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer((_) async => tPage);

      final result = await repository.getExercises(
        const ExerciseFilter(),
        null,
      );

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('expected right, got $failure'), (page) {
        expect(page.items.length, 1);
        expect(page.items.first.name, 'Bench Press');
        expect(page.nextCursor, 'cursor123');
        expect(page.hasMore, isTrue);
      });
    });

    test('getExercise returns mapped Exercise on success', () async {
      when(
        () => mockDataSource.getExercise(1),
      ).thenAnswer((_) async => tApiModel);

      final result = await repository.getExercise('1');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (exercise) => expect(exercise.name, 'Bench Press'),
      );
    });

    test('getExercise with non-integer id returns NotFoundFailure', () async {
      final result = await repository.getExercise('invalid-id');
      expect(result, const Left(NotFoundFailure()));
    });

    test(
      'wraps 404 DioException into NotFoundFailure without throwing',
      () async {
        final req = RequestOptions(path: '/exercises/999');
        when(() => mockDataSource.getExercise(999)).thenThrow(
          DioException(
            requestOptions: req,
            response: Response(
              requestOptions: req,
              statusCode: 404,
              data: {'code': 'not_found', 'message': 'Exercise not found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository.getExercise('999');

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (_) => fail('expected failure'),
        );
      },
    );
  });
}
