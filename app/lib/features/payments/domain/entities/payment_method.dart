import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.id,
    required this.methodName,
    required this.isDigital,
    required this.isActive,
  });

  final String id;
  final String methodName;
  final bool isDigital;
  final bool isActive;

  @override
  List<Object?> get props => [id, methodName, isDigital, isActive];
}
