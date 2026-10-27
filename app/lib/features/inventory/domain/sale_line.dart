import 'package:equatable/equatable.dart';

import '../../accounting/domain/entities/item.dart';
import 'sale_line_charge.dart';

/// One open Counter Sale line for a catalog item.
class SaleLine extends Equatable {
  const SaleLine({
    required this.item,
    required this.quantity,
  });

  final Item item;

  /// Quantity string respecting the item's UOM decimal places.
  final String quantity;

  String get charge => saleLineCharge(
        quantity: quantity,
        saleRate: item.saleRate ?? '0.00',
        taxRatePercent: item.taxRatePercent,
      );

  SaleLine copyWithQuantity(String quantity) =>
      SaleLine(item: item, quantity: quantity);

  @override
  List<Object?> get props => [item, quantity];
}
