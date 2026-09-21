import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/progress_note.dart';
import '../entities/progress_note_type.dart';
import '../repositories/progress_notes_repository.dart';

class ListProgressNotesParams extends Equatable {
  const ListProgressNotesParams({required this.memberId, this.cursor});

  final String memberId;
  final String? cursor;

  @override
  List<Object?> get props => [memberId, cursor];
}

@lazySingleton
class ListProgressNotesUseCase
    implements UseCase<CursorPage<ProgressNote>, ListProgressNotesParams> {
  const ListProgressNotesUseCase(this._repository);

  final ProgressNotesRepository _repository;

  @override
  Future<Either<Failure, CursorPage<ProgressNote>>> call(
    ListProgressNotesParams params,
  ) {
    return _repository.listNotes(
      memberId: params.memberId,
      cursor: params.cursor,
    );
  }
}

class CreateProgressNoteParams extends Equatable {
  const CreateProgressNoteParams({
    required this.memberId,
    required this.noteText,
    required this.noteType,
  });

  final String memberId;
  final String noteText;
  final ProgressNoteType noteType;

  @override
  List<Object?> get props => [memberId, noteText, noteType];
}

@lazySingleton
class CreateProgressNoteUseCase
    implements UseCase<ProgressNote, CreateProgressNoteParams> {
  const CreateProgressNoteUseCase(this._repository);

  final ProgressNotesRepository _repository;

  @override
  Future<Either<Failure, ProgressNote>> call(CreateProgressNoteParams params) {
    return _repository.createNote(
      memberId: params.memberId,
      noteText: params.noteText,
      noteType: params.noteType,
    );
  }
}
