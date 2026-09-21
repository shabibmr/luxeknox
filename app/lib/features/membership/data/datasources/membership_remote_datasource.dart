import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class MembershipRemoteDataSource {
  Future<api.MembershipProductPage> getProducts({
    String? q,
    int? limit,
    int? offset,
  });

  Future<api.MembershipProduct> getProduct(int id);

  Future<api.MembershipProduct> createProduct(
    api.MembershipProductWrite write,
  );

  Future<api.MembershipProduct> updateProduct(
    int id,
    api.MembershipProductWrite write,
  );

  Future<api.MembershipPage> getMemberships({
    String? memberId,
    String? status,
    int? limit,
    int? offset,
  });

  Future<api.Membership> getMembership(int id);

  Future<api.Membership> createMembership(api.MembershipCreate create);

  Future<api.MembershipHistoryPage> getHistory(
    int membershipId, {
    String? cursor,
    int? limit,
  });

  Future<api.Membership> renew(int id, api.MembershipActionRequest request);

  Future<api.Membership> upgrade(int id, api.MembershipActionRequest request);

  Future<api.Membership> cancel(int id, api.MembershipActionRequest request);

  Future<api.MembershipFreezePage> getFreezes(int membershipId);

  Future<api.MembershipFreeze> requestFreeze(
    int membershipId,
    api.MembershipFreezeWrite write,
  );

  Future<api.MembershipFreeze> approveFreeze(int freezeId);

  Future<api.MembershipFreeze> rejectFreeze(
    int freezeId,
    api.RejectRequest request,
  );

  Future<api.MembershipExtension> extend(
    int membershipId,
    api.MembershipExtensionWrite write,
  );
}

@LazySingleton(as: MembershipRemoteDataSource)
class MembershipRemoteDataSourceImpl implements MembershipRemoteDataSource {
  MembershipRemoteDataSourceImpl(this._membApi);

  final api.MEMBApi _membApi;

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
  Future<api.MembershipProductPage> getProducts({
    String? q,
    int? limit,
    int? offset,
  }) async {
    return _unwrap(
      await _membApi.listMembershipProducts(q: q, limit: limit, offset: offset),
    );
  }

  @override
  Future<api.MembershipProduct> getProduct(int id) async {
    return _unwrap(await _membApi.getMembershipProduct(id: id));
  }

  @override
  Future<api.MembershipProduct> createProduct(
    api.MembershipProductWrite write,
  ) async {
    return _unwrap(
      await _membApi.createMembershipProduct(membershipProductWrite: write),
    );
  }

  @override
  Future<api.MembershipProduct> updateProduct(
    int id,
    api.MembershipProductWrite write,
  ) async {
    return _unwrap(
      await _membApi.updateMembershipProduct(
        id: id,
        membershipProductWrite: write,
      ),
    );
  }

  @override
  Future<api.MembershipPage> getMemberships({
    String? memberId,
    String? status,
    int? limit,
    int? offset,
  }) async {
    return _unwrap(
      await _membApi.listMemberships(
        memberId: memberId == null ? null : int.tryParse(memberId),
        status: status,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  Future<api.Membership> getMembership(int id) async {
    return _unwrap(await _membApi.getMembership(id: id));
  }

  @override
  Future<api.Membership> createMembership(api.MembershipCreate create) async {
    return _unwrap(await _membApi.createMembership(membershipCreate: create));
  }

  @override
  Future<api.MembershipHistoryPage> getHistory(
    int membershipId, {
    String? cursor,
    int? limit,
  }) async {
    return _unwrap(
      await _membApi.listMembershipHistory(
        id: membershipId,
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  @override
  Future<api.Membership> renew(
    int id,
    api.MembershipActionRequest request,
  ) async {
    return _unwrap(
      await _membApi.renewMembership(id: id, membershipActionRequest: request),
    );
  }

  @override
  Future<api.Membership> upgrade(
    int id,
    api.MembershipActionRequest request,
  ) async {
    return _unwrap(
      await _membApi.upgradeMembership(
        id: id,
        membershipActionRequest: request,
      ),
    );
  }

  @override
  Future<api.Membership> cancel(
    int id,
    api.MembershipActionRequest request,
  ) async {
    return _unwrap(
      await _membApi.cancelMembership(id: id, membershipActionRequest: request),
    );
  }

  @override
  Future<api.MembershipFreezePage> getFreezes(int membershipId) async {
    return _unwrap(await _membApi.listMembershipFreezes(id: membershipId));
  }

  @override
  Future<api.MembershipFreeze> requestFreeze(
    int membershipId,
    api.MembershipFreezeWrite write,
  ) async {
    return _unwrap(
      await _membApi.requestMembershipFreeze(
        id: membershipId,
        membershipFreezeWrite: write,
      ),
    );
  }

  @override
  Future<api.MembershipFreeze> approveFreeze(int freezeId) async {
    return _unwrap(await _membApi.approveFreeze(id: freezeId));
  }

  @override
  Future<api.MembershipFreeze> rejectFreeze(
    int freezeId,
    api.RejectRequest request,
  ) async {
    return _unwrap(
      await _membApi.rejectFreeze(id: freezeId, rejectRequest: request),
    );
  }

  @override
  Future<api.MembershipExtension> extend(
    int membershipId,
    api.MembershipExtensionWrite write,
  ) async {
    return _unwrap(
      await _membApi.extendMembership(
        id: membershipId,
        membershipExtensionWrite: write,
      ),
    );
  }
}
