import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for MEMBApi
void main() {
  final instance = ApiClient().getMEMBApi();

  group(MEMBApi, () {
    // Approve a freeze
    //
    //Future<MembershipFreeze> approveFreeze(int id) async
    test('test approveFreeze', () async {
      // TODO
    });

    // Cancel a membership
    //
    //Future<Membership> cancelMembership(int id, MembershipActionRequest membershipActionRequest) async
    test('test cancelMembership', () async {
      // TODO
    });

    // Assign a membership
    //
    //Future<Membership> createMembership(MembershipCreate membershipCreate) async
    test('test createMembership', () async {
      // TODO
    });

    // Create a package
    //
    //Future<MembershipProduct> createMembershipProduct(MembershipProductWrite membershipProductWrite) async
    test('test createMembershipProduct', () async {
      // TODO
    });

    // Grant a compensatory extension
    //
    //Future<MembershipExtension> extendMembership(int id, MembershipExtensionWrite membershipExtensionWrite) async
    test('test extendMembership', () async {
      // TODO
    });

    // Membership detail
    //
    //Future<Membership> getMembership(int id) async
    test('test getMembership', () async {
      // TODO
    });

    // Package detail
    //
    //Future<MembershipProduct> getMembershipProduct(int id) async
    test('test getMembershipProduct', () async {
      // TODO
    });

    // Freeze requests
    //
    //Future<MembershipFreezePage> listMembershipFreezes(int id) async
    test('test listMembershipFreezes', () async {
      // TODO
    });

    // Append-only membership history
    //
    //Future<MembershipHistoryPage> listMembershipHistory(int id, { int limit, String cursor }) async
    test('test listMembershipHistory', () async {
      // TODO
    });

    // Package catalog
    //
    //Future<MembershipProductPage> listMembershipProducts({ int limit, int offset, String q }) async
    test('test listMembershipProducts', () async {
      // TODO
    });

    // Membership contracts
    //
    //Future<MembershipPage> listMemberships({ int limit, int offset, int memberId, String status }) async
    test('test listMemberships', () async {
      // TODO
    });

    // Reject a freeze
    //
    //Future<MembershipFreeze> rejectFreeze(int id, RejectRequest rejectRequest) async
    test('test rejectFreeze', () async {
      // TODO
    });

    // Renew a membership
    //
    //Future<Membership> renewMembership(int id, MembershipActionRequest membershipActionRequest) async
    test('test renewMembership', () async {
      // TODO
    });

    // Request or create a freeze
    //
    //Future<MembershipFreeze> requestMembershipFreeze(int id, MembershipFreezeWrite membershipFreezeWrite, { String idempotencyKey }) async
    test('test requestMembershipFreeze', () async {
      // TODO
    });

    // Update a package
    //
    //Future<MembershipProduct> updateMembershipProduct(int id, MembershipProductWrite membershipProductWrite) async
    test('test updateMembershipProduct', () async {
      // TODO
    });

    // Upgrade a membership
    //
    //Future<Membership> upgradeMembership(int id, MembershipActionRequest membershipActionRequest) async
    test('test upgradeMembership', () async {
      // TODO
    });

  });
}
