import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/counter_sale.dart';
import '../entities/create_counter_sale_input.dart';
import '../repositories/inventory_repository.dart';

@lazySingleton
class CreateCounterSaleUseCase
    implements UseCase<CounterSale, CreateCounterSaleInput> {
  const CreateCounterSaleUseCase(this._repository);

  final InventoryRepository _repository;

  @override
  Future<Either<Failure, CounterSale>> call(CreateCounterSaleInput params) {
    return _repository.createCounterSale(params);
  }
}
