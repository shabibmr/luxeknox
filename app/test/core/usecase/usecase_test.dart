import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/usecase/usecase.dart';
import 'package:luxeknox/core/error/failures.dart';

// Mock implementation for testing
class TestParams extends Equatable {
  final String value;

  const TestParams(this.value);

  @override
  List<Object?> get props => [value];
}

class MockUseCase implements UseCase<String, TestParams> {
  @override
  Future<Either<Failure, String>> call(TestParams params) async {
    return Right('Success: ${params.value}');
  }
}

class MockUseCaseWithFailure implements UseCase<String, TestParams> {
  @override
  Future<Either<Failure, String>> call(TestParams params) async {
    return const Left(AuthFailure());
  }
}

class MockUseCaseNoParams implements UseCase<String, NoParams> {
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return const Right('No params result');
  }
}

void main() {
  group('UseCase contract', () {
    test('UseCase call returns Either<Failure, Out>', () async {
      final useCase = MockUseCase();
      final result = await useCase(const TestParams('test'));

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not be a failure'),
        (success) => expect(success, 'Success: test'),
      );
    });

    test('UseCase call can return a Failure', () async {
      final useCase = MockUseCaseWithFailure();
      final result = await useCase(const TestParams('test'));

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (success) => fail('Should not be a success'),
      );
    });
  });

  group('NoParams value equality', () {
    test('NoParams instances are equal', () {
      final params1 = const NoParams();
      final params2 = const NoParams();

      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });

    test('NoParams can be used as a parameter', () async {
      final useCase = MockUseCaseNoParams();
      final result = await useCase(const NoParams());

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not be a failure'),
        (success) => expect(success, 'No params result'),
      );
    });

    test('NoParams props are empty', () {
      const params = NoParams();
      expect(params.props, isEmpty);
    });
  });
}
