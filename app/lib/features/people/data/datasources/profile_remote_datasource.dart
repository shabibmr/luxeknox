import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRemoteDataSource {
  Future<api.MemberHealth> getHealth(int memberId);

  Future<api.MemberHealth> putHealth(
    int memberId,
    api.MemberHealthWrite write,
  );

  Future<api.MedicalHistoryPage> listMedicalHistories(int memberId);

  Future<api.MedicalHistory> createMedicalHistory(
    int memberId,
    api.MedicalHistoryWrite write,
  );

  Future<api.MedicalHistory> updateMedicalHistory(
    int memberId,
    int recordId,
    api.MedicalHistoryWrite write,
  );

  Future<void> deleteMedicalHistory(int memberId, int recordId);

  Future<api.EmergencyContactPage> listEmergencyContacts(int userId);

  Future<api.EmergencyContact> createEmergencyContact(
    int userId,
    api.EmergencyContactWrite write,
  );

  Future<api.EmergencyContact> updateEmergencyContact(
    int userId,
    int contactId,
    api.EmergencyContactWrite write,
  );

  Future<void> deleteEmergencyContact(int userId, int contactId);

  Future<api.MemberDocumentPage> listDocuments(int memberId);

  Future<api.MemberDocument> createDocument(
    int memberId,
    api.MemberDocumentWrite write,
  );

  Future<void> deleteDocument(int memberId, int documentId);

  Future<api.MemberPhotoPage> listPhotos(int memberId);

  Future<api.MemberPhoto> createPhoto(
    int memberId,
    api.MemberPhotoWrite write,
  );

  Future<api.MemberPhoto> setAvatar({
    required int memberId,
    required int photoId,
  });
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._healthApi);

  final api.HEALTHApi _healthApi;

  T _unwrap<T>(Response<T> response) {
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
    return data;
  }

  @override
  Future<api.MemberHealth> getHealth(int memberId) async {
    return _unwrap(await _healthApi.getMemberHealth(id: memberId));
  }

  @override
  Future<api.MemberHealth> putHealth(
    int memberId,
    api.MemberHealthWrite write,
  ) async {
    return _unwrap(
      await _healthApi.putMemberHealth(
        id: memberId,
        memberHealthWrite: write,
      ),
    );
  }

  @override
  Future<api.MedicalHistoryPage> listMedicalHistories(int memberId) async {
    return _unwrap(await _healthApi.listMedicalHistories(id: memberId));
  }

  @override
  Future<api.MedicalHistory> createMedicalHistory(
    int memberId,
    api.MedicalHistoryWrite write,
  ) async {
    return _unwrap(
      await _healthApi.createMedicalHistory(
        id: memberId,
        medicalHistoryWrite: write,
      ),
    );
  }

  @override
  Future<api.MedicalHistory> updateMedicalHistory(
    int memberId,
    int recordId,
    api.MedicalHistoryWrite write,
  ) async {
    return _unwrap(
      await _healthApi.updateMedicalHistory(
        id: memberId,
        historyId: recordId,
        medicalHistoryWrite: write,
      ),
    );
  }

  @override
  Future<void> deleteMedicalHistory(int memberId, int recordId) async {
    await _healthApi.deleteMedicalHistory(id: memberId, historyId: recordId);
  }

  @override
  Future<api.EmergencyContactPage> listEmergencyContacts(int userId) async {
    return _unwrap(await _healthApi.listEmergencyContacts(id: userId));
  }

  @override
  Future<api.EmergencyContact> createEmergencyContact(
    int userId,
    api.EmergencyContactWrite write,
  ) async {
    return _unwrap(
      await _healthApi.createEmergencyContact(
        id: userId,
        emergencyContactWrite: write,
      ),
    );
  }

  @override
  Future<api.EmergencyContact> updateEmergencyContact(
    int userId,
    int contactId,
    api.EmergencyContactWrite write,
  ) async {
    return _unwrap(
      await _healthApi.updateEmergencyContact(
        id: userId,
        contactId: contactId,
        emergencyContactWrite: write,
      ),
    );
  }

  @override
  Future<void> deleteEmergencyContact(int userId, int contactId) async {
    await _healthApi.deleteEmergencyContact(id: userId, contactId: contactId);
  }

  @override
  Future<api.MemberDocumentPage> listDocuments(int memberId) async {
    return _unwrap(await _healthApi.listMemberDocuments(id: memberId));
  }

  @override
  Future<api.MemberDocument> createDocument(
    int memberId,
    api.MemberDocumentWrite write,
  ) async {
    return _unwrap(
      await _healthApi.createMemberDocument(
        id: memberId,
        memberDocumentWrite: write,
      ),
    );
  }

  @override
  Future<void> deleteDocument(int memberId, int documentId) async {
    await _healthApi.deleteMemberDocument(id: memberId, documentId: documentId);
  }

  @override
  Future<api.MemberPhotoPage> listPhotos(int memberId) async {
    return _unwrap(await _healthApi.listMemberPhotos(id: memberId));
  }

  @override
  Future<api.MemberPhoto> createPhoto(
    int memberId,
    api.MemberPhotoWrite write,
  ) async {
    return _unwrap(
      await _healthApi.createMemberPhoto(
        id: memberId,
        memberPhotoWrite: write,
      ),
    );
  }

  @override
  Future<api.MemberPhoto> setAvatar({
    required int memberId,
    required int photoId,
  }) async {
    return _unwrap(
      await _healthApi.setMemberAvatar(id: memberId, photoId: photoId),
    );
  }
}
