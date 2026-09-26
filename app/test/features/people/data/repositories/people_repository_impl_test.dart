import 'package:api_client/api_client.dart' as api;
import 'package:luxeknox/core/error/failures.dart';
import 'package:luxeknox/features/people/data/datasources/people_remote_datasource.dart';
import 'package:luxeknox/features/people/data/repositories/people_repository_impl.dart';
import 'package:luxeknox/features/people/domain/entities/employee_status.dart';
import 'package:luxeknox/features/people/domain/entities/employee_update_input.dart';
import 'package:luxeknox/features/people/domain/entities/new_employee_input.dart';
import 'package:luxeknox/features/people/domain/entities/new_trainer_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockPeopleRemoteDataSource extends Mock
    implements PeopleRemoteDataSource {}

DioException _dioError(int statusCode, {String? code, List<String>? details}) {
  final req = RequestOptions(path: '/people');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode,
      data: {
        'code': ?code,
        'details': ?details,
      },
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  late MockPeopleRemoteDataSource mockDataSource;
  late PeopleRepositoryImpl repository;

  final tApiTrainer = api.Trainer(
    (b) => b
      ..id = 1
      ..userId = 10
      ..firstName = 'Jane'
      ..lastName = 'Doe'
      ..isActive = true,
  );

  final tEmployeeJson = <String, dynamic>{
    'id': 5,
    'user_id': 20,
    'first_name': 'Ed',
    'last_name': 'Ford',
    'job_title': 'Front Desk',
    'department': null,
    'hire_date': null,
    'status': 'active',
    'role_id': 3,
  };

  setUpAll(() {
    registerFallbackValue(
      api.TrainerCreate(
        (b) => b
          ..email = 'fallback@example.com'
          ..firstName = 'F'
          ..lastName = 'L',
      ),
    );
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockDataSource = MockPeopleRemoteDataSource();
    repository = PeopleRepositoryImpl(mockDataSource);
  });

  group('PeopleRepositoryImpl.createTrainer', () {
    const tInput = NewTrainerInput(
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
    );

    test('returns Right(TrainerProfile) on success', () async {
      when(
        () => mockDataSource.createTrainer(any()),
      ).thenAnswer((_) async => tApiTrainer);

      final result = await repository.createTrainer(tInput);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (trainer) {
          expect(trainer.id, 1);
          expect(trainer.firstName, 'Jane');
        },
      );
    });

    test('returns ValidationFailure on 422', () async {
      when(() => mockDataSource.createTrainer(any())).thenThrow(
        _dioError(422, code: 'validation_error', details: ['email required']),
      );

      final result = await repository.createTrainer(tInput);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('returns ConflictFailure on 409', () async {
      when(
        () => mockDataSource.createTrainer(any()),
      ).thenThrow(_dioError(409, code: 'conflict'));

      final result = await repository.createTrainer(tInput);

      expect(result, const Left(ConflictFailure()));
    });
  });

  group('PeopleRepositoryImpl.createEmployee', () {
    const tInput = NewEmployeeInput(
      firstName: 'Ed',
      lastName: 'Ford',
      email: 'ed@example.com',
      jobTitle: 'Front Desk',
      roleId: 3,
    );

    test('returns Right(EmployeeSummary) on success and sends int roleId', () async {
      when(
        () => mockDataSource.createEmployeeRaw(any()),
      ).thenAnswer((_) async => tEmployeeJson);

      final result = await repository.createEmployee(tInput);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (employee) {
          expect(employee.id, 5);
          expect(employee.roleId, 3);
          expect(employee.fullName, 'Ed Ford');
        },
      );

      final captured = verify(
        () => mockDataSource.createEmployeeRaw(captureAny()),
      ).captured;
      final body = captured.single as Map<String, dynamic>;
      expect(body['role_id'], 3);
      expect(body['first_name'], 'Ed');
    });

    test('returns ValidationFailure on 422', () async {
      when(() => mockDataSource.createEmployeeRaw(any())).thenThrow(
        _dioError(422, code: 'validation_error', details: ['roleId required']),
      );

      final result = await repository.createEmployee(tInput);

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('returns ConflictFailure on 409', () async {
      when(
        () => mockDataSource.createEmployeeRaw(any()),
      ).thenThrow(_dioError(409, code: 'conflict'));

      final result = await repository.createEmployee(tInput);

      expect(result, const Left(ConflictFailure()));
    });
  });

  group('PeopleRepositoryImpl.updateEmployee', () {
    const tInput = EmployeeUpdateInput(jobTitle: 'Manager');

    test('returns Right(EmployeeSummary) on success and can clear optionals', () async {
      when(
        () => mockDataSource.updateEmployeeRaw(5, any()),
      ).thenAnswer((_) async => tEmployeeJson);

      final cleared = const EmployeeUpdateInput(
        jobTitle: 'Manager',
      ).copyWith(department: null, hireDate: null);

      final result = await repository.updateEmployee(5, cleared);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('expected right, got $failure'),
        (employee) => expect(employee.id, 5),
      );

      final body = verify(
        () => mockDataSource.updateEmployeeRaw(5, captureAny()),
      ).captured.single as Map<String, dynamic>;
      expect(body.containsKey('department'), isTrue);
      expect(body['department'], isNull);
      expect(body.containsKey('hire_date'), isTrue);
      expect(body['hire_date'], isNull);
    });

    test('returns ValidationFailure on 422', () async {
      when(() => mockDataSource.updateEmployeeRaw(5, any())).thenThrow(
        _dioError(422, code: 'validation_error', details: ['jobTitle invalid']),
      );

      final result = await repository.updateEmployee(5, tInput);

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('returns ConflictFailure on 409', () async {
      when(
        () => mockDataSource.updateEmployeeRaw(5, any()),
      ).thenThrow(_dioError(409, code: 'conflict'));

      final result = await repository.updateEmployee(5, tInput);

      expect(result, const Left(ConflictFailure()));
    });
  });

  group('PeopleRepositoryImpl.setEmployeeStatus', () {
    test(
      'returns Right(EmployeeSummary) on success and sends wire status',
      () async {
        when(
          () => mockDataSource.setEmployeeStatusRaw(5, any()),
        ).thenAnswer((_) async => {
              ...tEmployeeJson,
              'status': 'on_probation',
            });

        final result = await repository.setEmployeeStatus(
          5,
          EmployeeStatus.onProbation,
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('expected right, got $failure'),
          (employee) {
            expect(employee.id, 5);
            expect(employee.status, 'on_probation');
          },
        );

        final captured = verify(
          () => mockDataSource.setEmployeeStatusRaw(5, captureAny()),
        ).captured;
        expect(captured.single, 'on_probation');
      },
    );

    test('returns ValidationFailure on 422', () async {
      when(() => mockDataSource.setEmployeeStatusRaw(5, any())).thenThrow(
        _dioError(422, code: 'validation_error', details: ['status invalid']),
      );

      final result = await repository.setEmployeeStatus(
        5,
        EmployeeStatus.suspended,
      );

      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('returns ConflictFailure on 409', () async {
      when(
        () => mockDataSource.setEmployeeStatusRaw(5, any()),
      ).thenThrow(_dioError(409, code: 'conflict'));

      final result = await repository.setEmployeeStatus(
        5,
        EmployeeStatus.terminated,
      );

      expect(result, const Left(ConflictFailure()));
    });
  });
}
