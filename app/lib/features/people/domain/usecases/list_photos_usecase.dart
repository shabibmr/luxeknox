import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member_photo.dart';
import '../repositories/document_repository.dart';

@lazySingleton
class ListPhotosUseCase implements UseCase<List<MemberPhoto>, int> {
  const ListPhotosUseCase(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, List<MemberPhoto>>> call(int memberId) {
    return _repository.listPhotos(memberId);
  }
}
