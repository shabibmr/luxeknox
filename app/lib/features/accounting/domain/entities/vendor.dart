import 'package:equatable/equatable.dart';

class Vendor extends Equatable {
  const Vendor({
    required this.id,
    required this.name,
    this.taxNumber,
    this.contactEmail,
    this.phone,
    this.address,
    this.isActive = true,
    this.rowVersion = 1,
  });

  final String id;
  final String name;
  final String? taxNumber;
  final String? contactEmail;
  final String? phone;
  final String? address;
  final bool isActive;
  final int rowVersion;

  @override
  List<Object?> get props => [
    id,
    name,
    taxNumber,
    contactEmail,
    phone,
    address,
    isActive,
    rowVersion,
  ];
}
