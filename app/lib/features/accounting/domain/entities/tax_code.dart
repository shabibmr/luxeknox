import 'package:equatable/equatable.dart';

class TaxCode extends Equatable {
  const TaxCode({
    required this.id,
    required this.code,
    required this.name,
    required this.ratePercent,
    this.isActive = true,
    this.components = const [],
  });

  final String id;
  final String code;
  final String name;
  final String ratePercent;
  final bool isActive;
  final List<TaxComponent> components;

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    ratePercent,
    isActive,
    components,
  ];
}

class TaxComponent extends Equatable {
  const TaxComponent({
    required this.id,
    required this.taxCodeId,
    required this.name,
    required this.ratePercent,
    required this.accountId,
  });

  final String id;
  final String taxCodeId;
  final String name;
  final String ratePercent;
  final String accountId;

  @override
  List<Object?> get props => [
    id,
    taxCodeId,
    name,
    ratePercent,
    accountId,
  ];
}
