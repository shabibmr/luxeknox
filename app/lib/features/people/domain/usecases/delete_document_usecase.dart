import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/document_repository.dart';

class DeleteDocumentParams extends Equatable {
  const DeleteDocumentParams({
    required this.memberId,
    required this.documentId,
  });

  final int memberId;
  final int documentId;

  @override
  List<Object?> get props => [memberId, documentId];
}

@lazySingleton
class DeleteDocumentUseCase implements UseCase<void, DeleteDocumentParams> {
  const DeleteDocumentUseCase(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, void>> call(DeleteDocumentParams params) {
    return _repository.deleteDocument(params.memberId, params.documentId);
  }
}
