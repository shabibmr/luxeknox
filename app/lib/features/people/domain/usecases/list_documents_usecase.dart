import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member_document.dart';
import '../repositories/document_repository.dart';

@lazySingleton
class ListDocumentsUseCase implements UseCase<List<MemberDocument>, int> {
  const ListDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, List<MemberDocument>>> call(int memberId) {
    return _repository.listDocuments(memberId);
  }
}
