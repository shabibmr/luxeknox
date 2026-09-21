import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';

import '../../../../core/media/document_access.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/entities/medical_record.dart';
import '../../domain/entities/member_document.dart';
import '../../domain/entities/member_photo.dart';
import '../../domain/entities/new_member_input.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/profile_summary.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/entities/trainer_summary.dart';

DateTime? _apiDateToDateTime(api.Date? date) {
  if (date == null) return null;
  return DateTime(date.year, date.month, date.day);
}

api.Date? _dateTimeToApiDate(DateTime? dateTime) {
  if (dateTime == null) return null;
  return api.Date(dateTime.year, dateTime.month, dateTime.day);
}

DocumentPurpose _documentPurposeFromApi(api.MemberDocumentDocumentTypeEnum t) {
  return switch (t.name) {
    'idProof' || 'id_proof' => DocumentPurpose.idProof,
    'waiver' => DocumentPurpose.waiver,
    'medicalCert' || 'medical_cert' => DocumentPurpose.medicalCert,
    _ => DocumentPurpose.medicalCert,
  };
}

api.MemberDocumentWriteDocumentTypeEnum _documentPurposeToWrite(
  DocumentPurpose purpose,
) {
  return switch (purpose) {
    DocumentPurpose.idProof => api.MemberDocumentWriteDocumentTypeEnum.idProof,
    DocumentPurpose.waiver => api.MemberDocumentWriteDocumentTypeEnum.waiver,
    DocumentPurpose.medicalCert =>
      api.MemberDocumentWriteDocumentTypeEnum.medicalCert,
    DocumentPurpose.receiptPdf || DocumentPurpose.progressPhoto =>
      api.MemberDocumentWriteDocumentTypeEnum.medicalCert,
  };
}

ProfileSummary profileSummaryFromMember(api.Member member) {
  return ProfileSummary(
    id: member.id,
    membershipNumber: member.membershipNumber,
    fullName: '${member.firstName} ${member.lastName}'.trim(),
    assignedTrainerId: member.assignedTrainerId,
  );
}

Person personFromMember(api.Member member) {
  return Person(
    id: member.id,
    userId: member.userId,
    membershipNumber: member.membershipNumber,
    firstName: member.firstName,
    lastName: member.lastName,
    gender: member.gender,
    dateOfBirth: _apiDateToDateTime(member.dateOfBirth),
    address: member.address,
    assignedTrainerId: member.assignedTrainerId,
    joinedDate: _apiDateToDateTime(member.joinedDate),
    notes: member.notes,
    email: member.user?.email,
    phoneNumber: member.user?.phoneNumber,
  );
}

Person personFromDossier(api.MemberDossier dossier) {
  return Person(
    id: dossier.id,
    userId: dossier.userId,
    membershipNumber: dossier.membershipNumber,
    firstName: dossier.firstName,
    lastName: dossier.lastName,
    gender: dossier.gender,
    dateOfBirth: _apiDateToDateTime(dossier.dateOfBirth),
    address: dossier.address,
    assignedTrainerId: dossier.assignedTrainerId,
    joinedDate: _apiDateToDateTime(dossier.joinedDate),
    notes: dossier.notes,
    email: dossier.user?.email,
    phoneNumber: dossier.user?.phoneNumber,
    membershipStatus: dossier.membership?.status.name,
    outstandingBalance: dossier.outstandingBalance,
    lastCheckIn: dossier.lastCheckIn,
    nextScheduleTitle: dossier.nextSchedule?.title,
  );
}

api.MemberUpdate memberUpdateFromPerson(Person person) {
  return api.MemberUpdate(
    (b) => b
      ..email = person.email
      ..phoneNumber = person.phoneNumber
      ..firstName = person.firstName
      ..lastName = person.lastName
      ..gender = person.gender
      ..dateOfBirth = _dateTimeToApiDate(person.dateOfBirth)
      ..address = person.address
      ..assignedTrainerId = person.assignedTrainerId
      ..notes = person.notes,
  );
}

TrainerSummary trainerSummaryFromApi(api.Trainer trainer) {
  return TrainerSummary(
    id: trainer.id,
    userId: trainer.userId,
    fullName: '${trainer.firstName} ${trainer.lastName}'.trim(),
    specializations: trainer.specializations?.toList() ?? const [],
    hourlyRate: trainer.hourlyRate,
    rating: trainer.rating?.toDouble(),
    maxClientsCapacity: trainer.maxClientsCapacity,
    assignedActiveCount: trainer.assignedActiveCount,
    isActive: trainer.isActive,
  );
}

TrainerProfile trainerProfileFromApi(api.Trainer trainer) {
  return TrainerProfile(
    id: trainer.id,
    userId: trainer.userId,
    firstName: trainer.firstName,
    lastName: trainer.lastName,
    bio: trainer.bio,
    specializations: trainer.specializations?.toList() ?? const [],
    hourlyRate: trainer.hourlyRate,
    rating: trainer.rating?.toDouble(),
    maxClientsCapacity: trainer.maxClientsCapacity,
    assignedActiveCount: trainer.assignedActiveCount,
    isActive: trainer.isActive,
  );
}

api.TrainerUpdate trainerUpdateFromProfile(TrainerProfile trainer) {
  return api.TrainerUpdate(
    (b) => b
      ..phoneNumber = trainer.phoneNumber
      ..firstName = trainer.firstName
      ..lastName = trainer.lastName
      ..bio = trainer.bio
      ..specializations = ListBuilder<String>(trainer.specializations)
      ..hourlyRate = trainer.hourlyRate
      ..maxClientsCapacity = trainer.maxClientsCapacity
      ..isActive = trainer.isActive,
  );
}

EmployeeSummary employeeSummaryFromApi(api.Employee employee) {
  final user = employee.user;
  final candidates = [
    user?.email,
    user?.phoneNumber,
  ].whereType<String>().where((s) => s.isNotEmpty).toList();
  return EmployeeSummary(
    id: employee.id,
    userId: employee.userId,
    fullName: candidates.isEmpty
        ? 'Employee #${employee.id}'
        : candidates.first,
    jobTitle: employee.jobTitle,
    department: employee.department,
    status: employee.status.name,
    roleId: employee.roleId,
  );
}

api.MemberCreate memberCreateFromInput(NewMemberInput input) {
  return api.MemberCreate(
    (b) => b
      ..email = input.email
      ..phoneNumber = input.phoneNumber
      ..password = input.password
      ..firstName = input.firstName
      ..lastName = input.lastName
      ..gender = input.gender
      ..dateOfBirth = _dateTimeToApiDate(input.dateOfBirth)
      ..address = input.address
      ..assignedTrainerId = input.assignedTrainerId
      ..notes = input.notes,
  );
}

Role roleFromApi(api.Role role) {
  return Role(
    id: role.id,
    name: role.name,
    description: role.description,
    isSystemRole: role.isSystemRole,
    permissionSlugs: role.permissions?.map((p) => p.slug).toList() ?? const [],
  );
}

HealthInfo healthInfoFromApi(api.MemberHealth health) {
  return HealthInfo(
    id: health.id,
    memberId: health.memberId,
    bloodGroup: health.bloodGroup,
    heightCm: health.heightCm?.toDouble(),
    baselineWeightKg: health.baselineWeightKg?.toDouble(),
    allergies: health.allergies,
    dietaryPreferences: health.dietaryPreferences,
    physicianName: health.physicianName,
    physicianPhone: health.physicianPhone,
    updatedAt: health.updatedAt,
  );
}

api.MemberHealthWrite healthInfoToWrite(HealthInfo info) {
  return api.MemberHealthWrite(
    (b) => b
      ..bloodGroup = info.bloodGroup
      ..heightCm = info.heightCm
      ..baselineWeightKg = info.baselineWeightKg
      ..allergies = info.allergies
      ..dietaryPreferences = info.dietaryPreferences
      ..physicianName = info.physicianName
      ..physicianPhone = info.physicianPhone,
  );
}

MedicalRecord medicalRecordFromApi(api.MedicalHistory record) {
  return MedicalRecord(
    id: record.id,
    memberId: record.memberId,
    conditionId: record.conditionId,
    title: record.title,
    description: record.description,
    diagnosedDate: _apiDateToDateTime(record.diagnosedDate),
    clearanceStatus: record.clearanceStatus,
    documentUrl: record.documentUrl,
  );
}

EmergencyContact emergencyContactFromApi(api.EmergencyContact contact) {
  return EmergencyContact(
    id: contact.id,
    userId: contact.userId,
    contactName: contact.contactName,
    relationship: contact.relationship,
    phonePrimary: contact.phonePrimary,
    phoneSecondary: contact.phoneSecondary,
    isPrimary: contact.isPrimary,
  );
}

MemberDocument memberDocumentFromApi(api.MemberDocument doc) {
  return MemberDocument(
    id: doc.id,
    memberId: doc.memberId,
    documentType: _documentPurposeFromApi(doc.documentType),
    title: doc.title,
    objectKey: doc.fileUrl,
    fileSize: doc.fileSize,
    verifiedByUserId: doc.verifiedByUserId,
    verifiedAt: doc.verifiedAt,
  );
}

api.MemberDocumentWrite memberDocumentWrite({
  required DocumentPurpose purpose,
  required String objectKey,
  String? title,
  int? fileSize,
}) {
  return api.MemberDocumentWrite(
    (b) => b
      ..documentType = _documentPurposeToWrite(purpose)
      ..title = title
      ..fileUrl = objectKey
      ..fileSize = fileSize,
  );
}

MemberPhoto memberPhotoFromApi(api.MemberPhoto photo) {
  return MemberPhoto(
    id: photo.id,
    memberId: photo.memberId,
    objectKey: photo.photoUrl,
    isCurrentAvatar: photo.isCurrentAvatar ?? false,
    capturedAt: photo.capturedAt,
  );
}

api.MemberPhotoWrite memberPhotoWrite({required String objectKey}) {
  return api.MemberPhotoWrite((b) => b..photoUrl = objectKey);
}
