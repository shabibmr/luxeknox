import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/entities/medical_record.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/people_mapper.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<HealthInfo>>> listHealthHistory(
    int memberId,
  ) async {
    try {
      final page = await _remote.listHealthHistory(memberId);
      final records = page.data.map(healthInfoFromApi).toList()
        ..sort((a, b) {
          final byDate = b.recordedAt.compareTo(a.recordedAt);
          if (byDate != 0) return byDate;
          return b.id.compareTo(a.id);
        });
      return Right(records);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, HealthInfo>> createHealthRecord(
    HealthInfo info,
  ) async {
    try {
      final created = await _remote.createHealthRecord(
        info.memberId,
        healthInfoToWrite(info),
      );
      return Right(healthInfoFromApi(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<MedicalRecord>>> listMedicalRecords(
    int memberId,
  ) async {
    try {
      final page = await _remote.listMedicalHistories(memberId);
      return Right(page.data.map(medicalRecordFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MedicalRecord>> createMedicalRecord(
    MedicalRecord record,
  ) async {
    try {
      final created = await _remote.createMedicalHistory(
        record.memberId,
        api.MedicalHistoryWrite(
          (b) => b
            ..conditionId = record.conditionId
            ..title = record.title
            ..description = record.description
            ..clearanceStatus = record.clearanceStatus,
        ),
      );
      return Right(medicalRecordFromApi(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MedicalRecord>> updateMedicalRecord(
    MedicalRecord record,
  ) async {
    try {
      final updated = await _remote.updateMedicalHistory(
        record.memberId,
        record.id,
        api.MedicalHistoryWrite(
          (b) => b
            ..conditionId = record.conditionId
            ..title = record.title
            ..description = record.description
            ..clearanceStatus = record.clearanceStatus,
        ),
      );
      return Right(medicalRecordFromApi(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedicalRecord(
    int memberId,
    int recordId,
  ) async {
    try {
      await _remote.deleteMedicalHistory(memberId, recordId);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<EmergencyContact>>> listEmergencyContacts(
    int userId,
  ) async {
    try {
      final page = await _remote.listEmergencyContacts(userId);
      return Right(page.data.map(emergencyContactFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmergencyContact>> createEmergencyContact(
    EmergencyContact contact,
  ) async {
    try {
      final created = await _remote.createEmergencyContact(
        contact.userId,
        api.EmergencyContactWrite(
          (b) => b
            ..contactName = contact.contactName
            ..relationship = contact.relationship
            ..phonePrimary = contact.phonePrimary
            ..phoneSecondary = contact.phoneSecondary
            ..isPrimary = contact.isPrimary,
        ),
      );
      return Right(emergencyContactFromApi(created));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, EmergencyContact>> updateEmergencyContact(
    EmergencyContact contact,
  ) async {
    try {
      final updated = await _remote.updateEmergencyContact(
        contact.userId,
        contact.id,
        api.EmergencyContactWrite(
          (b) => b
            ..contactName = contact.contactName
            ..relationship = contact.relationship
            ..phonePrimary = contact.phonePrimary
            ..phoneSecondary = contact.phoneSecondary
            ..isPrimary = contact.isPrimary,
        ),
      );
      return Right(emergencyContactFromApi(updated));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmergencyContact(
    int userId,
    int contactId,
  ) async {
    try {
      await _remote.deleteEmergencyContact(userId, contactId);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
