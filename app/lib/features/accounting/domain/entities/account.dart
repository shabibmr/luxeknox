import 'package:equatable/equatable.dart';

class Account extends Equatable {
  const Account({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    this.isControl = false,
    this.isBank = false,
    this.isActive = true,
    this.description,
    this.rowVersion = 1,
  });

  final String id;
  final String code;
  final String name;
  final String type;
  final bool isControl;
  final bool isBank;
  final bool isActive;
  final String? description;
  final int rowVersion;

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    type,
    isControl,
    isBank,
    isActive,
    description,
    rowVersion,
  ];
}
