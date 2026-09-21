import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/progress_note.dart';
import '../entities/progress_note_type.dart';

abstract class ProgressNotesRepository {
  Future<Either<Failure, CursorPage<ProgressNote>>> listNotes({
    required String memberId,
    String? cursor,
  });

  Future<Either<Failure, ProgressNote>> createNote({
    required String memberId,
    required String noteText,
    required ProgressNoteType noteType,
  });
}
