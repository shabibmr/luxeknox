import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/media/document_access.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../domain/entities/member_document.dart';
import '../../domain/usecases/delete_document_usecase.dart';
import '../../domain/usecases/list_documents_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';

part 'documents_cubit.freezed.dart';

@freezed
abstract class DocumentsState with _$DocumentsState {
  const DocumentsState._();

  const factory DocumentsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MemberDocument>[]) List<MemberDocument> documents,
    @Default(false) bool uploading,
    double? uploadProgress,
    String? uploadError,
    Uint8List? pendingBytes,
    String? pendingContentType,
    DocumentPurpose? pendingPurpose,
    String? pendingTitle,
    Failure? failure,
  }) = _DocumentsState;

  bool get canRetry =>
      pendingBytes != null &&
      pendingContentType != null &&
      pendingPurpose != null &&
      pendingTitle != null;
}

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(
    this._list,
    this._upload,
    this._cancelUpload,
    this._delete,
    this._viewerRole,
  ) : super(const DocumentsState());

  final ListDocumentsUseCase _list;
  final UploadDocumentUseCase _upload;
  final CancelDocumentUploadUseCase _cancelUpload;
  final DeleteDocumentUseCase _delete;
  final UserType _viewerRole;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _list(memberId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (docs) => emit(
        state.copyWith(
          status: LoadStatus.success,
          documents: docs
              .where(
                (d) => canAccessDocument(
                  role: _viewerRole,
                  purpose: d.documentType,
                ),
              )
              .toList(),
          failure: null,
          uploading: false,
          uploadProgress: null,
          uploadError: null,
          pendingBytes: null,
          pendingContentType: null,
          pendingPurpose: null,
          pendingTitle: null,
        ),
      ),
    );
  }

  Future<void> upload({
    required DocumentPurpose purpose,
    required String title,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final memberId = _memberId;
    if (memberId == null) return;
    if (!canAccessDocument(role: _viewerRole, purpose: purpose)) {
      emit(
        state.copyWith(
          uploading: false,
          uploadProgress: null,
          uploadError: 'Not allowed for this document type.',
          pendingBytes: null,
          pendingContentType: null,
          pendingPurpose: null,
          pendingTitle: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        uploading: true,
        uploadProgress: 0,
        uploadError: null,
        pendingBytes: bytes,
        pendingContentType: contentType,
        pendingPurpose: purpose,
        pendingTitle: title,
      ),
    );

    final result = await _upload(
      UploadDocumentParams(
        memberId: memberId,
        purpose: purpose,
        title: title,
        bytes: bytes,
        contentType: contentType,
        onProgress: (sent, total) {
          if (total <= 0) return;
          if (state.uploading) {
            emit(state.copyWith(uploadProgress: sent / total));
          }
        },
      ),
    );

    await result.fold((failure) async {
      emit(
        state.copyWith(
          uploading: false,
          uploadProgress: null,
          uploadError: failureMessage(failure),
          pendingBytes: bytes,
          pendingContentType: contentType,
          pendingPurpose: purpose,
          pendingTitle: title,
        ),
      );
    }, (_) async => load(memberId));
  }

  Future<void> retryUpload() async {
    if (!state.canRetry) return;
    await upload(
      purpose: state.pendingPurpose!,
      title: state.pendingTitle!,
      bytes: state.pendingBytes!,
      contentType: state.pendingContentType!,
    );
  }

  void cancelUpload() {
    _cancelUpload();
    emit(
      state.copyWith(
        uploading: false,
        uploadProgress: null,
        uploadError: 'Upload cancelled.',
        pendingBytes: null,
        pendingContentType: null,
        pendingPurpose: null,
        pendingTitle: null,
      ),
    );
  }

  Future<void> remove(int documentId) async {
    final memberId = _memberId;
    if (memberId == null) return;
    final result = await _delete(
      DeleteDocumentParams(memberId: memberId, documentId: documentId),
    );
    await result.fold(
      (failure) async =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (_) async => load(memberId),
    );
  }
}
