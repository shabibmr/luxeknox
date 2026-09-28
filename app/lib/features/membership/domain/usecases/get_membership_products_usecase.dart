import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/membership_product.dart';
import '../repositories/membership_repository.dart';

class GetMembershipProductsParams extends Equatable {
  const GetMembershipProductsParams({this.q, this.limit, this.offset});

  final String? q;
  final int? limit;
  final int? offset;

  @override
  List<Object?> get props => [q, limit, offset];
}

@lazySingleton
class GetMembershipProductsUseCase
    implements
        UseCase<CursorPage<MembershipProduct>, GetMembershipProductsParams> {
  const GetMembershipProductsUseCase(this._repository);

  final MembershipRepository _repository;

  @override
  Future<Either<Failure, CursorPage<MembershipProduct>>> call(
    GetMembershipProductsParams params,
  ) {
    return _repository.getProducts(
      q: params.q,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
