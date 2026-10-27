import 'package:equatable/equatable.dart';

/// Server-computed totals a PT sale would charge (discount, then tax).
class PtPaymentPreview extends Equatable {
  const PtPaymentPreview({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
  });

  final String subtotal;
  final String discount;
  final String tax;
  final String total;

  @override
  List<Object?> get props => [subtotal, discount, tax, total];
}
