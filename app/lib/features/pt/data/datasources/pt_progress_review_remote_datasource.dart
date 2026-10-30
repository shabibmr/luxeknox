import 'dart:typed_data';

import 'package:api_client/api_client.dart' as api;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PtProgressReviewRemoteDataSource {
  Future<api.PtProgressReview> createDraft(
    int memberId,
    api.PtProgressReviewDraft body,
  );

  Future<api.PtProgressReview> get(int reviewId);

  Future<api.PtProgressReview> trainerSign(int reviewId);

  Future<api.PtProgressReview> clientSign(int reviewId);

  Future<api.PtProgressReview> managerApprove(int reviewId);

  Future<Uint8List> exportPdf(int reviewId);
}

@LazySingleton(as: PtProgressReviewRemoteDataSource)
class PtProgressReviewRemoteDataSourceImpl
    implements PtProgressReviewRemoteDataSource {
  PtProgressReviewRemoteDataSourceImpl(this._api);

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
  Future<api.PtProgressReview> createDraft(
    int memberId,
    api.PtProgressReviewDraft body,
  ) async {
    return _unwrap(
      await _api.createPtProgressReviewDraft(
        id: memberId,
        ptProgressReviewDraft: body,
      ),
    );
  }

  @override
  Future<api.PtProgressReview> get(int reviewId) async {
    return _unwrap(await _api.getPtProgressReview(id: reviewId));
  }

  @override
  Future<api.PtProgressReview> trainerSign(int reviewId) async {
    return _unwrap(await _api.trainerSignPtProgressReview(id: reviewId));
  }

  @override
  Future<api.PtProgressReview> clientSign(int reviewId) async {
    return _unwrap(await _api.clientSignPtProgressReview(id: reviewId));
  }

  @override
  Future<api.PtProgressReview> managerApprove(int reviewId) async {
    return _unwrap(await _api.managerApprovePtProgressReview(id: reviewId));
  }

  @override
  Future<Uint8List> exportPdf(int reviewId) async {
    return _unwrap(await _api.exportPtProgressReviewPdf(id: reviewId));
  }
}
