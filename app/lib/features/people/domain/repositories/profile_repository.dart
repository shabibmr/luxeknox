import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/emergency_contact.dart';
import '../entities/health_info.dart';
import '../entities/medical_record.dart';

/// Health information, medical history, and emergency contacts — screens
/// 04, 05, 06.
abstract class ProfileRepository {
  Future<Either<Failure, HealthInfo>> getHealthInfo(int memberId);

  Future<Either<Failure, HealthInfo>> updateHealthInfo(HealthInfo info);

  Future<Either<Failure, List<MedicalRecord>>> listMedicalRecords(int memberId);

  Future<Either<Failure, MedicalRecord>> createMedicalRecord(
    MedicalRecord record,
  );

  Future<Either<Failure, MedicalRecord>> updateMedicalRecord(
    MedicalRecord record,
  );

  Future<Either<Failure, void>> deleteMedicalRecord(int memberId, int recordId);

  Future<Either<Failure, List<EmergencyContact>>> listEmergencyContacts(
    int userId,
  );

  Future<Either<Failure, EmergencyContact>> createEmergencyContact(
    EmergencyContact contact,
  );

  Future<Either<Failure, EmergencyContact>> updateEmergencyContact(
    EmergencyContact contact,
  );

  Future<Either<Failure, void>> deleteEmergencyContact(
    int userId,
    int contactId,
  );
}
