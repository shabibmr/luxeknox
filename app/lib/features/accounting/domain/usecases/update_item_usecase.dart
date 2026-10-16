import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/item.dart';
import '../repositories/accounting_repository.dart';

class UpdateItemParams extends Equatable {
  const UpdateItemParams({required this.id, required this.draft});

  final int id;
  final ItemDraft draft;

  @override
  List<Object?> get props => [id, draft];
}

@lazySingleton
class UpdateItemUseCase implements UseCase<Item, UpdateItemParams> {
  const UpdateItemUseCase(this._repository);

  final AccountingRepository _repository;

  @override
  Future<Either<Failure, Item>> call(UpdateItemParams params) =>
      _repository.updateItem(params.id, params.draft);
}
