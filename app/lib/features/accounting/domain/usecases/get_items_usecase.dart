import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/item.dart';
import '../repositories/accounting_repository.dart';

class GetItemsParams extends Equatable {
  const GetItemsParams({
    this.limit,
    this.offset,
    this.kind,
    this.categoryId,
    this.isActive,
    this.inventoryTracked,
    this.search,
  });

  final int? limit;
  final int? offset;
  final String? kind;
  final int? categoryId;
  final bool? isActive;
  final bool? inventoryTracked;
  final String? search;

  @override
  List<Object?> get props => [
    limit,
    offset,
    kind,
    categoryId,
    isActive,
    inventoryTracked,
    search,
  ];
}

@lazySingleton
class GetItemsUseCase implements UseCase<CursorPage<Item>, GetItemsParams> {
  const GetItemsUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, CursorPage<Item>>> call(GetItemsParams params) {
    return _repository.getItems(
      limit: params.limit,
      offset: params.offset,
      kind: params.kind,
      categoryId: params.categoryId,
      isActive: params.isActive,
      inventoryTracked: params.inventoryTracked,
      search: params.search,
    );
  }
}
