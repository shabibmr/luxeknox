import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/counter_sale.dart';
import '../entities/create_counter_sale_input.dart';

abstract class InventoryRepository {
  /// Creates and posts a Counter Sale. Replays with the same idempotency key
  /// return the original sale.
  Future<Either<Failure, CounterSale>> createCounterSale(
    CreateCounterSaleInput input,
  );
}
