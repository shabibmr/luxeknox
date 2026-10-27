import 'package:equatable/equatable.dart';

/// One tender on a posted Counter Sale.
class CounterSaleTender extends Equatable {
  const CounterSaleTender({
    required this.paymentMethodId,
    required this.paymentMethodName,
    required this.amount,
  });

  final int paymentMethodId;
  final String paymentMethodName;
  final String amount;

  @override
  List<Object?> get props => [paymentMethodId, paymentMethodName, amount];
}

/// Posted Counter Sale returned by create.
class CounterSale extends Equatable {
  const CounterSale({
    required this.id,
    required this.saleNumber,
    required this.totalAmount,
    required this.tenders,
  });

  final int id;
  final String saleNumber;
  final String totalAmount;
  final List<CounterSaleTender> tenders;

  @override
  List<Object?> get props => [id, saleNumber, totalAmount, tenders];
}
