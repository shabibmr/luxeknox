import 'package:app/features/people/domain/entities/emergency_contact.dart';
import 'package:app/features/people/domain/entities/health_info.dart';
import 'package:app/features/people/domain/entities/medical_record.dart';
import 'package:app/features/people/domain/repositories/profile_repository.dart';
import 'package:app/features/people/domain/usecases/create_emergency_contact_usecase.dart';
import 'package:app/features/people/domain/usecases/create_medical_record_usecase.dart';
import 'package:app/features/people/domain/usecases/delete_emergency_contact_usecase.dart';
import 'package:app/features/people/domain/usecases/delete_medical_record_usecase.dart';
import 'package:app/features/people/domain/usecases/get_health_info_usecase.dart';
import 'package:app/features/people/domain/usecases/list_emergency_contacts_usecase.dart';
import 'package:app/features/people/domain/usecases/list_medical_records_usecase.dart';
import 'package:app/features/people/domain/usecases/update_emergency_contact_usecase.dart';
import 'package:app/features/people/domain/usecases/update_health_info_usecase.dart';
import 'package:app/features/people/domain/usecases/update_medical_record_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;

  const tHealthInfo = HealthInfo(id: 1, memberId: 1, bloodGroup: 'O+');

  const tMedicalRecord = MedicalRecord(
    id: 1,
    memberId: 1,
    title: 'Knee surgery',
  );

  const tContact = EmergencyContact(
    id: 1,
    userId: 10,
    contactName: 'Jane Doe',
    phonePrimary: '+15551234567',
    isPrimary: true,
  );

  setUp(() {
    mockRepository = MockProfileRepository();
  });

  group('Health UseCases', () {
    test('GetHealthInfoUseCase calls repository.getHealthInfo', () async {
      when(
        () => mockRepository.getHealthInfo(1),
      ).thenAnswer((_) async => const Right(tHealthInfo));

      final useCase = GetHealthInfoUseCase(mockRepository);
      final result = await useCase(1);

      expect(result, const Right(tHealthInfo));
      verify(() => mockRepository.getHealthInfo(1)).called(1);
    });

    test('UpdateHealthInfoUseCase calls repository.updateHealthInfo', () async {
      when(
        () => mockRepository.updateHealthInfo(tHealthInfo),
      ).thenAnswer((_) async => const Right(tHealthInfo));

      final useCase = UpdateHealthInfoUseCase(mockRepository);
      final result = await useCase(tHealthInfo);

      expect(result, const Right(tHealthInfo));
      verify(() => mockRepository.updateHealthInfo(tHealthInfo)).called(1);
    });
  });

  group('Medical Record UseCases', () {
    test(
      'ListMedicalRecordsUseCase calls repository.listMedicalRecords',
      () async {
        when(
          () => mockRepository.listMedicalRecords(1),
        ).thenAnswer((_) async => const Right([tMedicalRecord]));

        final useCase = ListMedicalRecordsUseCase(mockRepository);
        final result = await useCase(1);

        expect(result, const Right([tMedicalRecord]));
        verify(() => mockRepository.listMedicalRecords(1)).called(1);
      },
    );

    test(
      'CreateMedicalRecordUseCase calls repository.createMedicalRecord',
      () async {
        when(
          () => mockRepository.createMedicalRecord(tMedicalRecord),
        ).thenAnswer((_) async => const Right(tMedicalRecord));

        final useCase = CreateMedicalRecordUseCase(mockRepository);
        final result = await useCase(tMedicalRecord);

        expect(result, const Right(tMedicalRecord));
        verify(
          () => mockRepository.createMedicalRecord(tMedicalRecord),
        ).called(1);
      },
    );

    test(
      'UpdateMedicalRecordUseCase calls repository.updateMedicalRecord',
      () async {
        when(
          () => mockRepository.updateMedicalRecord(tMedicalRecord),
        ).thenAnswer((_) async => const Right(tMedicalRecord));

        final useCase = UpdateMedicalRecordUseCase(mockRepository);
        final result = await useCase(tMedicalRecord);

        expect(result, const Right(tMedicalRecord));
        verify(
          () => mockRepository.updateMedicalRecord(tMedicalRecord),
        ).called(1);
      },
    );

    test(
      'DeleteMedicalRecordUseCase calls repository.deleteMedicalRecord',
      () async {
        when(
          () => mockRepository.deleteMedicalRecord(1, 2),
        ).thenAnswer((_) async => const Right(null));

        final useCase = DeleteMedicalRecordUseCase(mockRepository);
        final result = await useCase(
          const DeleteMedicalRecordParams(memberId: 1, recordId: 2),
        );

        expect(result, const Right(null));
        verify(() => mockRepository.deleteMedicalRecord(1, 2)).called(1);
      },
    );
  });

  group('Emergency Contact UseCases', () {
    test(
      'ListEmergencyContactsUseCase calls repository.listEmergencyContacts',
      () async {
        when(
          () => mockRepository.listEmergencyContacts(10),
        ).thenAnswer((_) async => const Right([tContact]));

        final useCase = ListEmergencyContactsUseCase(mockRepository);
        final result = await useCase(10);

        expect(result, const Right([tContact]));
        verify(() => mockRepository.listEmergencyContacts(10)).called(1);
      },
    );

    test(
      'CreateEmergencyContactUseCase calls repository.createEmergencyContact',
      () async {
        when(
          () => mockRepository.createEmergencyContact(tContact),
        ).thenAnswer((_) async => const Right(tContact));

        final useCase = CreateEmergencyContactUseCase(mockRepository);
        final result = await useCase(tContact);

        expect(result, const Right(tContact));
        verify(() => mockRepository.createEmergencyContact(tContact)).called(1);
      },
    );

    test(
      'UpdateEmergencyContactUseCase calls repository.updateEmergencyContact',
      () async {
        when(
          () => mockRepository.updateEmergencyContact(tContact),
        ).thenAnswer((_) async => const Right(tContact));

        final useCase = UpdateEmergencyContactUseCase(mockRepository);
        final result = await useCase(tContact);

        expect(result, const Right(tContact));
        verify(() => mockRepository.updateEmergencyContact(tContact)).called(1);
      },
    );

    test(
      'DeleteEmergencyContactUseCase calls repository.deleteEmergencyContact',
      () async {
        when(
          () => mockRepository.deleteEmergencyContact(10, 5),
        ).thenAnswer((_) async => const Right(null));

        final useCase = DeleteEmergencyContactUseCase(mockRepository);
        final result = await useCase(
          const DeleteEmergencyContactParams(userId: 10, contactId: 5),
        );

        expect(result, const Right(null));
        verify(() => mockRepository.deleteEmergencyContact(10, 5)).called(1);
      },
    );
  });
}
