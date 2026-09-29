import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for PTApi
void main() {
  final instance = ApiClient().getPTApi();

  group(PTApi, () {
    // Move remaining PT sessions to other weekdays/hour
    //
    //Future<PtSubscription> changePtSlot(int id, PtChangeSlotRequest ptChangeSlotRequest) async
    test('test changePtSlot', () async {
      // TODO
    });

    // Create a PT package
    //
    //Future<PtProduct> createPtProduct(PtProductWrite ptProductWrite) async
    test('test createPtProduct', () async {
      // TODO
    });

    // Member's current PT, PT history, and the calling trainer's access level
    //
    //Future<MemberPtSummary> getMemberPtSummary(int id) async
    test('test getMemberPtSummary', () async {
      // TODO
    });

    // PT package detail
    //
    //Future<PtProduct> getPtProduct(int id) async
    test('test getPtProduct', () async {
      // TODO
    });

    // Hours × same-gender trainers occupancy for a PT package, start date and weekdays
    //
    // A cell is `free` only when the hour is inside the trainer's availability and clash-free on every occurrence date of the PT period. Only trainers of the member's gender are listed. 
    //
    //Future<PtScheduleGrid> getPtScheduleGrid(int memberId, int ptProductId, Date startDate, String weekdays, { int excludeSubscriptionId }) async
    test('test getPtScheduleGrid', () async {
      // TODO
    });

    // PT subscription detail
    //
    //Future<PtSubscription> getPtSubscription(int id) async
    test('test getPtSubscription', () async {
      // TODO
    });

    // Personal Training package catalog
    //
    //Future<PtProductPage> listPtProducts({ int limit, int offset, String q }) async
    test('test listPtProducts', () async {
      // TODO
    });

    // Sell PT — assign trainer + fixed weekly slot, take payment, generate sessions
    //
    //Future<PtPurchaseResult> purchasePtSubscription(PtPurchaseRequest ptPurchaseRequest) async
    test('test purchasePtSubscription', () async {
      // TODO
    });

    // Move remaining PT sessions to another same-gender trainer
    //
    //Future<PtSubscription> reassignPtTrainer(int id, PtReassignTrainerRequest ptReassignTrainerRequest) async
    test('test reassignPtTrainer', () async {
      // TODO
    });

    // Renew PT with the same trainer and slot
    //
    //Future<PtPurchaseResult> renewPtSubscription(int id, PtRenewRequest ptRenewRequest) async
    test('test renewPtSubscription', () async {
      // TODO
    });

    // Update or archive a PT package
    //
    //Future<PtProduct> updatePtProduct(int id, PtProductWrite ptProductWrite) async
    test('test updatePtProduct', () async {
      // TODO
    });

  });
}
