import 'package:api_client/api_client.dart' as api;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_extension.dart';
import '../../domain/entities/membership_freeze.dart';
import '../../domain/entities/membership_history_entry.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/repositories/membership_repository.dart';
import '../datasources/membership_remote_datasource.dart';
import '../models/membership_date.dart';
import '../models/membership_extension_model.dart';
import '../models/membership_freeze_model.dart';
import '../models/membership_history_model.dart';
import '../models/membership_model.dart';
import '../models/membership_product_model.dart';

@LazySingleton(as: MembershipRepository)
class MembershipRepositoryImpl implements MembershipRepository {
  MembershipRepositoryImpl(this._remoteDataSource);

  final MembershipRemoteDataSource _remoteDataSource;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<MembershipProduct>>> getProducts({
    String? q,
    int? limit,
    int? offset,
  }) async {
    try {
      final page = await _remoteDataSource.getProducts(
        q: q,
        limit: limit,
        offset: offset,
      );
      return Right(
        CursorPage<MembershipProduct>(
          items: page.data.map((m) => m.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipProduct>> getProduct(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getProduct(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipProduct>> createProduct(
    MembershipProduct product,
  ) async {
    try {
      final created = await _remoteDataSource.createProduct(
        product.toWriteModel(),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipProduct>> updateProduct(
    MembershipProduct product,
  ) async {
    final intId = _parseId(product.id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final updated = await _remoteDataSource.updateProduct(
        intId,
        product.toWriteModel(),
      );
      return Right(updated.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<Membership>>> getMemberships({
    String? memberId,
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final page = await _remoteDataSource.getMemberships(
        memberId: memberId,
        status: status,
        limit: limit,
        offset: offset,
      );
      return Right(
        CursorPage<Membership>(
          items: page.data.map((m) => m.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Membership>> getMembership(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final model = await _remoteDataSource.getMembership(intId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Membership>> createMembership({
    required String memberId,
    required String productId,
    required DateTime startDate,
    String? lockerNumber,
    bool? autoRenew,
  }) async {
    final memberIntId = _parseId(memberId);
    final productIntId = _parseId(productId);
    if (memberIntId == null || productIntId == null) {
      return const Left(ValidationFailure(['Invalid member or product id']));
    }
    try {
      final create = api.MembershipCreate((b) {
        b
          ..memberId = memberIntId
          ..productId = productIntId
          ..startDate = dateTimeToApiDate(startDate)
          ..lockerNumber = lockerNumber
          ..autoRenew = autoRenew;
      });
      final created = await _remoteDataSource.createMembership(create);
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<MembershipHistoryEntry>>> getHistory(
    String membershipId, {
    String? cursor,
    int? limit,
  }) async {
    final intId = _parseId(membershipId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final page = await _remoteDataSource.getHistory(
        intId,
        cursor: cursor,
        limit: limit,
      );
      return Right(
        CursorPage<MembershipHistoryEntry>(
          items: page.data.map((m) => m.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  api.MembershipActionRequest _actionRequest({
    String? productId,
    required int rowVersion,
    String? reason,
  }) {
    return api.MembershipActionRequest((b) {
      b
        ..productId = productId == null ? null : _parseId(productId)
        ..rowVersion = rowVersion
        ..reason = reason;
    });
  }

  @override
  Future<Either<Failure, Membership>> renew(
    String id, {
    String? productId,
    required int rowVersion,
    String? reason,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final result = await _remoteDataSource.renew(
        intId,
        _actionRequest(productId: productId, rowVersion: rowVersion, reason: reason),
      );
      return Right(result.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Membership>> upgrade(
    String id, {
    required String productId,
    required int rowVersion,
    String? reason,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final result = await _remoteDataSource.upgrade(
        intId,
        _actionRequest(productId: productId, rowVersion: rowVersion, reason: reason),
      );
      return Right(result.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Membership>> cancel(
    String id, {
    required int rowVersion,
    String? reason,
  }) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final result = await _remoteDataSource.cancel(
        intId,
        _actionRequest(rowVersion: rowVersion, reason: reason),
      );
      return Right(result.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CursorPage<MembershipFreeze>>> getFreezes(
    String membershipId,
  ) async {
    final intId = _parseId(membershipId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final page = await _remoteDataSource.getFreezes(intId);
      return Right(
        CursorPage<MembershipFreeze>(
          items: page.data.map((m) => m.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipFreeze>> requestFreeze(
    String membershipId, {
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    final intId = _parseId(membershipId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final write = api.MembershipFreezeWrite((b) {
        b
          ..startDate = dateTimeToApiDate(startDate)
          ..endDate = dateTimeToApiDate(endDate)
          ..reason = reason;
      });
      final created = await _remoteDataSource.requestFreeze(intId, write);
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipFreeze>> approveFreeze(
    String freezeId,
  ) async {
    final intId = _parseId(freezeId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final result = await _remoteDataSource.approveFreeze(intId);
      return Right(result.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipFreeze>> rejectFreeze(
    String freezeId, {
    String? reason,
  }) async {
    final intId = _parseId(freezeId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final request = api.RejectRequest((b) => b..reason = reason);
      final result = await _remoteDataSource.rejectFreeze(intId, request);
      return Right(result.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MembershipExtension>> extend(
    String membershipId, {
    required int daysExtended,
    String? reason,
  }) async {
    final intId = _parseId(membershipId);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      final write = api.MembershipExtensionWrite((b) {
        b
          ..daysExtended = daysExtended
          ..reason = reason;
      });
      final result = await _remoteDataSource.extend(intId, write);
      return Right(result.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
