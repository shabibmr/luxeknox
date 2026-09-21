import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/media/document_access.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../domain/entities/member_document.dart';
import '../../domain/usecases/delete_document_usecase.dart';
import '../../domain/usecases/list_documents_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';

sealed class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object?> get props => [];
}

final class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

final class DocumentsLoaded extends DocumentsState {
  const DocumentsLoaded({
    required this.documents,
    this.uploading = false,
    this.uploadProgress,
    this.uploadError,
    this.pendingBytes,
    this.pendingContentType,
    this.pendingPurpose,
    this.pendingTitle,
  });

  final List<MemberDocument> documents;
  final bool uploading;
  final double? uploadProgress;
  final String? uploadError;
  final Uint8List? pendingBytes;
  final String? pendingContentType;
  final DocumentPurpose? pendingPurpose;
  final String? pendingTitle;

  bool get canRetry =>
      pendingBytes != null &&
      pendingContentType != null &&
      pendingPurpose != null &&
      pendingTitle != null;

  @override
  List<Object?> get props => [
    documents,
    uploading,
    uploadProgress,
    uploadError,
    pendingBytes,
    pendingContentType,
    pendingPurpose,
    pendingTitle,
  ];
}

final class DocumentsFailure extends DocumentsState {
  const DocumentsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(
    this._list,
    this._upload,
    this._cancelUpload,
    this._delete,
    this._viewerRole,
  ) : super(const DocumentsLoading());

  final ListDocumentsUseCase _list;
  final UploadDocumentUseCase _upload;
  final CancelDocumentUploadUseCase _cancelUpload;
  final DeleteDocumentUseCase _delete;
  final UserType _viewerRole;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(const DocumentsLoading());
    final result = await _list(memberId);
    result.fold(
      (failure) => emit(DocumentsFailure(_message(failure))),
      (docs) => emit(
        DocumentsLoaded(
          documents: docs
              .where(
                (d) => canAccessDocument(
                  role: _viewerRole,
                  purpose: d.documentType,
                ),
              )
              .toList(),
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
        DocumentsLoaded(
          documents: _currentDocs(),
          uploadError: 'Not allowed for this document type.',
        ),
      );
      return;
    }

    emit(
      DocumentsLoaded(
        documents: _currentDocs(),
        uploading: true,
        uploadProgress: 0,
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
          final current = state;
          if (current is DocumentsLoaded && current.uploading) {
            emit(
              current.copyWith(uploadProgress: sent / total),
            );
          }
        },
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          DocumentsLoaded(
            documents: _currentDocs(),
            uploadError: _message(failure),
            pendingBytes: bytes,
            pendingContentType: contentType,
            pendingPurpose: purpose,
            pendingTitle: title,
          ),
        );
      },
      (_) async => load(memberId),
    );
  }

  Future<void> retryUpload() async {
    final current = state;
    if (current is! DocumentsLoaded || !current.canRetry) return;
    await upload(
      purpose: current.pendingPurpose!,
      title: current.pendingTitle!,
      bytes: current.pendingBytes!,
      contentType: current.pendingContentType!,
    );
  }

  void cancelUpload() {
    _cancelUpload();
    final docs = _currentDocs();
    emit(DocumentsLoaded(documents: docs, uploadError: 'Upload cancelled.'));
  }

  Future<void> remove(int documentId) async {
    final memberId = _memberId;
    if (memberId == null) return;
    final result = await _delete(
      DeleteDocumentParams(memberId: memberId, documentId: documentId),
    );
    await result.fold(
      (failure) async => emit(DocumentsFailure(_message(failure))),
      (_) async => load(memberId),
    );
  }

  List<MemberDocument> _currentDocs() {
    final current = state;
    return current is DocumentsLoaded ? current.documents : const [];
  }

  String _message(Failure failure) => failureMessage(failure);
}

extension on DocumentsLoaded {
  DocumentsLoaded copyWith({
    List<MemberDocument>? documents,
    bool? uploading,
    double? uploadProgress,
    String? uploadError,
    Uint8List? pendingBytes,
    String? pendingContentType,
    DocumentPurpose? pendingPurpose,
    String? pendingTitle,
  }) {
    return DocumentsLoaded(
      documents: documents ?? this.documents,
      uploading: uploading ?? this.uploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadError: uploadError,
      pendingBytes: pendingBytes ?? this.pendingBytes,
      pendingContentType: pendingContentType ?? this.pendingContentType,
      pendingPurpose: pendingPurpose ?? this.pendingPurpose,
      pendingTitle: pendingTitle ?? this.pendingTitle,
    );
  }
}
