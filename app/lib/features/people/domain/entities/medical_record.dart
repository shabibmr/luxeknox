import 'package:equatable/equatable.dart';

/// Mirrors `MedicalHistory` (screen 05: Medical History).
class MedicalRecord extends Equatable {
  final int id;
  final int memberId;
  final int? conditionId;
  final String title;
  final String? description;
  final DateTime? diagnosedDate;
  final String? clearanceStatus;
  final String? documentUrl;

  const MedicalRecord({
    required this.id,
    required this.memberId,
    this.conditionId,
    required this.title,
    this.description,
    this.diagnosedDate,
    this.clearanceStatus,
    this.documentUrl,
  });

  MedicalRecord copyWith({
    int? id,
    int? memberId,
    int? conditionId,
    String? title,
    String? description,
    DateTime? diagnosedDate,
    String? clearanceStatus,
    String? documentUrl,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      conditionId: conditionId ?? this.conditionId,
      title: title ?? this.title,
      description: description ?? this.description,
      diagnosedDate: diagnosedDate ?? this.diagnosedDate,
      clearanceStatus: clearanceStatus ?? this.clearanceStatus,
      documentUrl: documentUrl ?? this.documentUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    memberId,
    conditionId,
    title,
    description,
    diagnosedDate,
    clearanceStatus,
    documentUrl,
  ];
}
