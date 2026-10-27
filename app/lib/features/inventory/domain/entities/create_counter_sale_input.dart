import 'package:equatable/equatable.dart';

/// One line sent on create. Rate, discount, and tax code are omitted on purpose.
class CreateCounterSaleLineInput extends Equatable {
  const CreateCounterSaleLineInput({
    required this.itemId,
    required this.quantity,
  });

  final int itemId;
  final String quantity;

  @override
  List<Object?> get props => [itemId, quantity];
}

/// One tender sent on create. Reference is omitted on purpose.
class CreateCounterSaleTenderInput extends Equatable {
  const CreateCounterSaleTenderInput({
    required this.paymentMethodId,
    required this.amount,
  });

  final int paymentMethodId;
  final String amount;

  @override
  List<Object?> get props => [paymentMethodId, amount];
}

/// Body for `POST /inventory/sales`. Sale date is omitted (server uses today).
///
/// Sends a Member id, a buyer name, or neither — never both.
class CreateCounterSaleInput extends Equatable {
  const CreateCounterSaleInput({
    required this.lines,
    required this.tenders,
    this.memberId,
    this.buyerName,
    this.idempotencyKey,
  }) : assert(
          memberId == null || buyerName == null || buyerName == '',
          'Counter Sale cannot send both memberId and buyerName',
        );

  final int? memberId;
  final String? buyerName;
  final List<CreateCounterSaleLineInput> lines;
  final List<CreateCounterSaleTenderInput> tenders;
  final String? idempotencyKey;

  @override
  List<Object?> get props => [
        memberId,
        buyerName,
        lines,
        tenders,
        idempotencyKey,
      ];
}
