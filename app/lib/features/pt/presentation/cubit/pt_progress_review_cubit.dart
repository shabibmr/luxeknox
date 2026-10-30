import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/pt_progress_review.dart';
import '../../domain/usecases/client_sign_pt_progress_review_usecase.dart';
import '../../domain/usecases/create_pt_progress_review_draft_usecase.dart';
import '../../domain/usecases/export_pt_progress_review_pdf_usecase.dart';
import '../../domain/usecases/get_pt_progress_review_usecase.dart';
import '../../domain/usecases/manager_approve_pt_progress_review_usecase.dart';
import '../../domain/usecases/update_pt_progress_review_card_usecase.dart';
import '../../domain/usecases/trainer_sign_pt_progress_review_usecase.dart';
import '../pt_strings.dart';

/// Who is looking at Screen 45. That decides which sign-off action is offered.
enum PtProgressReviewAudience { member, trainer, manager }

const Object _unset = Object();

class PtProgressReviewState extends Equatable {
  const PtProgressReviewState({
    this.status = LoadStatus.initial,
    this.review,
    this.acting = false,
    this.failure,
    this.notice,
    this.actionError,
    this.exportedPdf,
  });

  final LoadStatus status;
  final PtProgressReview? review;
  final bool acting;
  final Failure? failure;
  final String? notice;
  final String? actionError;
  final Uint8List? exportedPdf;

  PtProgressReviewState copyWith({
    LoadStatus? status,
    Object? review = _unset,
    bool? acting,
    Object? failure = _unset,
    Object? notice = _unset,
    Object? actionError = _unset,
    Object? exportedPdf = _unset,
  }) {
    return PtProgressReviewState(
      status: status ?? this.status,
      review: identical(review, _unset)
          ? this.review
          : review as PtProgressReview?,
      acting: acting ?? this.acting,
      failure: identical(failure, _unset) ? this.failure : failure as Failure?,
      notice: identical(notice, _unset) ? this.notice : notice as String?,
      actionError: identical(actionError, _unset)
          ? this.actionError
          : actionError as String?,
      exportedPdf: identical(exportedPdf, _unset)
          ? this.exportedPdf
          : exportedPdf as Uint8List?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    review,
    acting,
    failure,
    notice,
    actionError,
    exportedPdf,
  ];
}

/// Screen 45: load or draft a review, then walk trainer → client → manager.
class PtProgressReviewCubit extends Cubit<PtProgressReviewState> {
  PtProgressReviewCubit(
    this._getReview,
    this._createDraft,
    this._trainerSign,
    this._clientSign,
    this._managerApprove,
    this._exportPdf,
    this._updateCard,
  ) : super(const PtProgressReviewState());

  final GetPtProgressReviewUseCase _getReview;
  final CreatePtProgressReviewDraftUseCase _createDraft;
  final TrainerSignPtProgressReviewUseCase _trainerSign;
  final ClientSignPtProgressReviewUseCase _clientSign;
  final ManagerApprovePtProgressReviewUseCase _managerApprove;
  final ExportPtProgressReviewPdfUseCase _exportPdf;
  final UpdatePtProgressReviewCardUseCase _updateCard;

  void clearNotices() {
    if (state.notice == null &&
        state.actionError == null &&
        state.exportedPdf == null) {
      return;
    }
    emit(state.copyWith(notice: null, actionError: null, exportedPdf: null));
  }

  Future<void> load(int reviewId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        notice: null,
        actionError: null,
      ),
    );
    final result = await _getReview(reviewId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (review) => emit(
        state.copyWith(
          status: LoadStatus.success,
          review: review,
          failure: null,
        ),
      ),
    );
  }

  Future<void> createDraft(PtProgressReviewDraftInput input) async {
    if (state.acting) return;
    emit(state.copyWith(acting: true, actionError: null, notice: null));
    final result = await _createDraft(input);
    result.fold(
      (failure) => emit(
        state.copyWith(acting: false, actionError: failureMessage(failure)),
      ),
      (review) => emit(
        state.copyWith(
          status: LoadStatus.success,
          acting: false,
          review: review,
          failure: null,
          notice: PtStrings.drafted,
        ),
      ),
    );
  }

  Future<void> saveCard(PtProgressReviewCardEdit edit) async {
    final review = state.review;
    if (review == null || state.acting) return;
    emit(state.copyWith(acting: true, actionError: null, notice: null));
    final result = await _updateCard(
      UpdatePtProgressReviewCardParams(review.id, edit),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(acting: false, actionError: failureMessage(failure)),
      ),
      (updated) => emit(
        state.copyWith(
          acting: false,
          review: updated,
          notice: PtStrings.cardSaved,
        ),
      ),
    );
  }

  Future<void> signAsTrainer() =>
      _transition(_trainerSign, PtStrings.trainerSigned);

  Future<void> signAsClient() =>
      _transition(_clientSign, PtStrings.clientSigned);

  Future<void> approveAsManager() =>
      _transition(_managerApprove, PtStrings.managerApproved);

  Future<void> exportPdf() async {
    final review = state.review;
    if (review == null || state.acting || !review.canExportPdf) return;
    emit(state.copyWith(acting: true, actionError: null, notice: null));
    final result = await _exportPdf(review.id);
    result.fold(
      (failure) => emit(
        state.copyWith(acting: false, actionError: failureMessage(failure)),
      ),
      (bytes) => emit(
        state.copyWith(
          acting: false,
          notice: PtStrings.exported,
          exportedPdf: bytes,
        ),
      ),
    );
  }

  Future<void> _transition(
    UseCase<PtProgressReview, int> useCase,
    String notice,
  ) async {
    final review = state.review;
    if (review == null || state.acting) return;
    emit(state.copyWith(acting: true, actionError: null, notice: null));
    final result = await useCase(review.id);
    result.fold(
      (failure) => emit(
        state.copyWith(acting: false, actionError: failureMessage(failure)),
      ),
      (updated) =>
          emit(state.copyWith(acting: false, review: updated, notice: notice)),
    );
  }
}
