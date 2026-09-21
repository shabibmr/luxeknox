import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_product.dart';
import '../repositories/membership_repository.dart';

@lazySingleton
class GetMembershipProductUseCase implements UseCase<MembershipProduct, String> {
  const GetMembershipProductUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, MembershipProduct>> call(String id) {
    return _repository.getProduct(id);
  }
}
