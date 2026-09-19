import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for HEALTHApi
void main() {
  final instance = ApiClient().getHEALTHApi();

  group(HEALTHApi, () {
    // Add an emergency contact
    //
    //Future<EmergencyContact> createEmergencyContact(int id, EmergencyContactWrite emergencyContactWrite) async
    test('test createEmergencyContact', () async {
      // TODO
    });

    // Create a condition
    //
    //Future<HealthCondition> createHealthCondition(HealthConditionWrite healthConditionWrite) async
    test('test createHealthCondition', () async {
      // TODO
    });

    // Add a medical history row
    //
    //Future<MedicalHistory> createMedicalHistory(int id, MedicalHistoryWrite medicalHistoryWrite) async
    test('test createMedicalHistory', () async {
      // TODO
    });

    // Attach a document metadata row (deferred)
    //
    //Future<MemberDocument> createMemberDocument(int id, MemberDocumentWrite memberDocumentWrite) async
    test('test createMemberDocument', () async {
      // TODO
    });

    // Add a gallery photo (deferred)
    //
    //Future<MemberPhoto> createMemberPhoto(int id, MemberPhotoWrite memberPhotoWrite) async
    test('test createMemberPhoto', () async {
      // TODO
    });

    // Remove an emergency contact
    //
    //Future deleteEmergencyContact(int id, int contactId) async
    test('test deleteEmergencyContact', () async {
      // TODO
    });

    // Soft-remove a medical history row
    //
    //Future deleteMedicalHistory(int id, int historyId) async
    test('test deleteMedicalHistory', () async {
      // TODO
    });

    // Delete a document row (deferred)
    //
    //Future deleteMemberDocument(int id, int documentId) async
    test('test deleteMemberDocument', () async {
      // TODO
    });

    // Current health row
    //
    //Future<MemberHealth> getMemberHealth(int id) async
    test('test getMemberHealth', () async {
      // TODO
    });

    // Emergency contacts for a user
    //
    //Future<EmergencyContactPage> listEmergencyContacts(int id) async
    test('test listEmergencyContacts', () async {
      // TODO
    });

    // Condition catalog
    //
    //Future<HealthConditionPage> listHealthConditions({ int limit, int offset }) async
    test('test listHealthConditions', () async {
      // TODO
    });

    // Medical history list
    //
    //Future<MedicalHistoryPage> listMedicalHistories(int id, { int limit, int offset }) async
    test('test listMedicalHistories', () async {
      // TODO
    });

    // Member documents (deferred uploads)
    //
    //Future<MemberDocumentPage> listMemberDocuments(int id) async
    test('test listMemberDocuments', () async {
      // TODO
    });

    // Member gallery (deferred)
    //
    //Future<MemberPhotoPage> listMemberPhotos(int id) async
    test('test listMemberPhotos', () async {
      // TODO
    });

    // Replace current health row
    //
    //Future<MemberHealth> putMemberHealth(int id, MemberHealthWrite memberHealthWrite) async
    test('test putMemberHealth', () async {
      // TODO
    });

    // Set current avatar from a gallery shot (deferred)
    //
    //Future<MemberPhoto> setMemberAvatar(int id, int photoId) async
    test('test setMemberAvatar', () async {
      // TODO
    });

    // Update an emergency contact
    //
    //Future<EmergencyContact> updateEmergencyContact(int id, int contactId, EmergencyContactWrite emergencyContactWrite) async
    test('test updateEmergencyContact', () async {
      // TODO
    });

    // Update a condition
    //
    //Future<HealthCondition> updateHealthCondition(int id, HealthConditionWrite healthConditionWrite) async
    test('test updateHealthCondition', () async {
      // TODO
    });

    // Update a medical history row
    //
    //Future<MedicalHistory> updateMedicalHistory(int id, int historyId, MedicalHistoryWrite medicalHistoryWrite) async
    test('test updateMedicalHistory', () async {
      // TODO
    });

    // Verify a document (deferred)
    //
    //Future<MemberDocument> verifyMemberDocument(int id, int documentId) async
    test('test verifyMemberDocument', () async {
      // TODO
    });

  });
}
