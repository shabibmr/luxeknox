import 'dart:typed_data';

import 'package:api_client/api_client.dart' as api;
import '../../../../core/network/api_response_unwrap.dart';
import 'package:injectable/injectable.dart';

abstract class PtProgressReviewRemoteDataSource {
  Future<api.PtProgressReview> createDraft(
    int memberId,
    api.PtProgressReviewDraft body,
  );

  Future<api.PtProgressReview> get(int reviewId);

  Future<api.PtProgressReview> updateCard(
    int reviewId,
    api.PtProgressReviewDraftEdit body,
  );

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

  @override
  Future<api.PtProgressReview> createDraft(
    int memberId,
    api.PtProgressReviewDraft body,
  ) async {
    return unwrapApiResponse(
      await _api.createPtProgressReviewDraft(
        id: memberId,
        ptProgressReviewDraft: body,
      ),
    );
  }

  @override
  Future<api.PtProgressReview> get(int reviewId) async {
    return unwrapApiResponse(await _api.getPtProgressReview(id: reviewId));
  }

  @override
  Future<api.PtProgressReview> updateCard(
    int reviewId,
    api.PtProgressReviewDraftEdit body,
  ) async {
    return unwrapApiResponse(
      await _api.updatePtProgressReviewDraft(
        id: reviewId,
        ptProgressReviewDraftEdit: body,
      ),
    );
  }

  @override
  Future<api.PtProgressReview> trainerSign(int reviewId) async {
    return unwrapApiResponse(
      await _api.trainerSignPtProgressReview(id: reviewId),
    );
  }

  @override
  Future<api.PtProgressReview> clientSign(int reviewId) async {
    return unwrapApiResponse(
      await _api.clientSignPtProgressReview(id: reviewId),
    );
  }

  @override
  Future<api.PtProgressReview> managerApprove(int reviewId) async {
    return unwrapApiResponse(
      await _api.managerApprovePtProgressReview(id: reviewId),
    );
  }

  @override
  Future<Uint8List> exportPdf(int reviewId) async {
    return unwrapApiResponse(
      await _api.exportPtProgressReviewPdf(id: reviewId),
    );
  }
}
