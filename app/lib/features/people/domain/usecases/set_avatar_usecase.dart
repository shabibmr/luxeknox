import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member_photo.dart';
import '../repositories/document_repository.dart';

class SetAvatarParams extends Equatable {
  const SetAvatarParams({required this.memberId, required this.photoId});

  final int memberId;
  final int photoId;

  @override
  List<Object?> get props => [memberId, photoId];
}

@lazySingleton
class SetAvatarUseCase implements UseCase<MemberPhoto, SetAvatarParams> {
  const SetAvatarUseCase(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, MemberPhoto>> call(SetAvatarParams params) {
    return _repository.setAvatar(
      memberId: params.memberId,
      photoId: params.photoId,
    );
  }
}
