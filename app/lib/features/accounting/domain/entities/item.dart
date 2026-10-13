import 'package:equatable/equatable.dart';

class Item extends Equatable {
  const Item({
    required this.id,
    required this.name,
    required this.code,
    required this.kind,
    required this.incomeAccountId,
    required this.expenseAccountId,
    this.defaultTaxCodeId,
    this.isActive = true,
    this.rowVersion = 1,
  });

  final String id;
  final String name;
  final String code;
  final String kind;
  final String incomeAccountId;
  final String expenseAccountId;
  final String? defaultTaxCodeId;
  final bool isActive;
  final int rowVersion;

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    kind,
    incomeAccountId,
    expenseAccountId,
    defaultTaxCodeId,
    isActive,
    rowVersion,
  ];
}
