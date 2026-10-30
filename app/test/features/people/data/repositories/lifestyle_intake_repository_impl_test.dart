import 'package:built_collection/built_collection.dart';
import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/data/datasources/lifestyle_intake_remote_datasource.dart';
import 'package:luxeknox/features/people/data/repositories/lifestyle_intake_repository_impl.dart';
import 'package:luxeknox/features/people/domain/entities/lifestyle_intake.dart';
import 'package:mocktail/mocktail.dart';

class MockLifestyleIntakeRemoteDataSource extends Mock
    implements LifestyleIntakeRemoteDataSource {}

api.LifestyleIntake _apiIntake({String? sleep = '7.5'}) {
  return api.LifestyleIntake(
    (b) => b
      ..id = 3
      ..memberId = 10
      ..activityLevel = 'Moderately active'
      ..sleepHoursTypical = sleep
      ..stressLevel = 6
      ..typicalDailySteps = 8000
      ..conductedByTrainerId = 4
      ..lifestylePriorities = ListBuilder<api.LifestylePriority>([
        api.LifestylePriority(
          (p) => p
            ..priority = api.LifestylePriorityPriorityEnum.sleep
            ..currentStatus = '6h'
            ..firstAction = 'Fixed bedtime',
        ),
      ])
      ..createdAt = DateTime.utc(2026, 3, 1),
  );
}

List<LifestylePriority> _priorities() => [
  for (final d in LifestylePriorityDomain.values)
    LifestylePriority(domain: d, currentStatus: 'now', firstAction: 'act'),
];

LifestyleIntakeInput _input({
  int stressLevel = 6,
  List<LifestylePriority>? priorities,
  double? sleepHours = 7.5,
}) {
  return LifestyleIntakeInput(
    memberId: 10,
    stressLevel: stressLevel,
    sleepHoursTypical: sleepHours,
    activityLevel: 'Moderately active',
    typicalDailySteps: 8000,
    priorities: priorities ?? _priorities(),
  );
}

Failure _leftOf(dynamic result) =>
    (result as dynamic).swap().getOrElse((_) => throw StateError('right'));

void main() {
  late MockLifestyleIntakeRemoteDataSource remote;
  late LifestyleIntakeRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      api.LifestyleIntakeWrite(
        (b) => b
          ..stressLevel = 1
          ..lifestylePriorities = ListBuilder<api.LifestylePriority>(),
      ),
    );
  });

  setUp(() {
    remote = MockLifestyleIntakeRemoteDataSource();
    repository = LifestyleIntakeRepositoryImpl(remote);
  });

  group('get', () {
    test('maps the API intake, parsing sleep hours to a number', () async {
      when(() => remote.get(10)).thenAnswer((_) async => _apiIntake());

      final intake = (await repository.get(
        10,
      )).getOrElse((_) => throw StateError('left'));

      expect(intake.id, 3);
      expect(intake.memberId, 10);
      expect(intake.sleepHoursTypical, 7.5);
      expect(intake.stressLevel, 6);
      expect(intake.typicalDailySteps, 8000);
      expect(intake.conductedByTrainerId, 4);
      expect(intake.priorities.single.domain, LifestylePriorityDomain.sleep);
      expect(intake.priorities.single.firstAction, 'Fixed bedtime');
      expect(intake.otherNotes, isNull);
    });

    test('leaves sleep hours null when the server has none', () async {
      when(
        () => remote.get(10),
      ).thenAnswer((_) async => _apiIntake(sleep: null));

      final intake = (await repository.get(
        10,
      )).getOrElse((_) => throw StateError('left'));

      expect(intake.sleepHoursTypical, isNull);
    });

    test('returns NotFoundFailure when no intake exists yet', () async {
      final request = RequestOptions();
      when(() => remote.get(10)).thenThrow(
        DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: request, statusCode: 404),
        ),
      );

      final result = await repository.get(10);

      expect(result.isLeft(), isTrue);
    });
  });

  group('save', () {
    test('sends the intake and maps the saved result', () async {
      when(
        () => remote.put(any(), any()),
      ).thenAnswer((_) async => _apiIntake());

      final result = await repository.save(_input());

      expect(result.isRight(), isTrue);
      final body =
          verify(() => remote.put(10, captureAny())).captured.single
              as api.LifestyleIntakeWrite;
      expect(body.stressLevel, 6);
      expect(body.sleepHoursTypical, 7.5);
      expect(body.activityLevel, 'Moderately active');
      expect(body.lifestylePriorities.length, 4);
      expect(
        body.lifestylePriorities.first.priority,
        api.LifestylePriorityPriorityEnum.sleep,
      );
    });

    test('refuses a stress level outside 1-10 without a server call', () async {
      final result = await repository.save(_input(stressLevel: 11));

      expect(_leftOf(result), isA<ValidationFailure>());
      verifyNever(() => remote.put(any(), any()));
    });

    test('refuses priorities that do not cover each domain once', () async {
      final result = await repository.save(
        _input(priorities: _priorities().take(3).toList()),
      );

      expect(_leftOf(result), isA<ValidationFailure>());
      verifyNever(() => remote.put(any(), any()));
    });

    test('refuses sleep hours with more than one decimal place', () async {
      final result = await repository.save(_input(sleepHours: 7.25));

      expect(_leftOf(result), isA<ValidationFailure>());
      verifyNever(() => remote.put(any(), any()));
    });

    test('returns a Failure when the server call throws', () async {
      when(() => remote.put(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.save(_input());

      expect(result.isLeft(), isTrue);
    });
  });
}
