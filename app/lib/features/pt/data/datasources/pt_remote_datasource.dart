import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PtRemoteDataSource {
  Future<api.PtProductPage> listProducts({String? q, int? limit});
  Future<api.PtProduct> createProduct(api.PtProductWrite write);
  Future<api.PtProduct> updateProduct(int id, api.PtProductWrite write);
  Future<api.PtScheduleGrid> scheduleGrid({
    required int memberId,
    required int ptProductId,
    required api.Date startDate,
    required String weekdays,
    int? excludeSubscriptionId,
  });
  Future<api.PtPurchaseResult> purchase({
    required api.PtPurchaseRequest request,
    String? idempotencyKey,
  });
  Future<api.PtPurchaseResult> renew(int id, api.PtRenewRequest request);
  Future<api.PtSubscription> reassignTrainer(
    int id,
    api.PtReassignTrainerRequest request,
  );
  Future<api.PtSubscription> changeSlot(
    int id,
    api.PtChangeSlotRequest request,
  );
  Future<api.MemberPtSummary> memberSummary(int memberId);
}

@LazySingleton(as: PtRemoteDataSource)
class PtRemoteDataSourceImpl implements PtRemoteDataSource {
  PtRemoteDataSourceImpl(this._api);

  final api.PTApi _api;

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
  Future<api.PtProductPage> listProducts({String? q, int? limit}) async =>
      _unwrap(await _api.listPtProducts(q: q, limit: limit));

  @override
  Future<api.PtProduct> createProduct(api.PtProductWrite write) async =>
      _unwrap(await _api.createPtProduct(ptProductWrite: write));

  @override
  Future<api.PtProduct> updateProduct(int id, api.PtProductWrite write) async =>
      _unwrap(await _api.updatePtProduct(id: id, ptProductWrite: write));

  @override
  Future<api.PtScheduleGrid> scheduleGrid({
    required int memberId,
    required int ptProductId,
    required api.Date startDate,
    required String weekdays,
    int? excludeSubscriptionId,
  }) async => _unwrap(
    await _api.getPtScheduleGrid(
      memberId: memberId,
      ptProductId: ptProductId,
      startDate: startDate,
      weekdays: weekdays,
      excludeSubscriptionId: excludeSubscriptionId,
    ),
  );

  @override
  Future<api.PtPurchaseResult> purchase({
    required api.PtPurchaseRequest request,
    String? idempotencyKey,
  }) async => _unwrap(
    await _api.purchasePtSubscription(
      ptPurchaseRequest: request,
      headers: idempotencyKey == null
          ? null
          : {'Idempotency-Key': idempotencyKey},
    ),
  );

  @override
  Future<api.PtPurchaseResult> renew(
    int id,
    api.PtRenewRequest request,
  ) async =>
      _unwrap(await _api.renewPtSubscription(id: id, ptRenewRequest: request));

  @override
  Future<api.PtSubscription> reassignTrainer(
    int id,
    api.PtReassignTrainerRequest request,
  ) async => _unwrap(
    await _api.reassignPtTrainer(id: id, ptReassignTrainerRequest: request),
  );

  @override
  Future<api.PtSubscription> changeSlot(
    int id,
    api.PtChangeSlotRequest request,
  ) async =>
      _unwrap(await _api.changePtSlot(id: id, ptChangeSlotRequest: request));

  @override
  Future<api.MemberPtSummary> memberSummary(int memberId) async =>
      _unwrap(await _api.getMemberPtSummary(id: memberId));
}
