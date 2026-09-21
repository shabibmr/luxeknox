import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/progress_note.dart';
import '../../domain/entities/progress_note_type.dart';
import '../../domain/repositories/progress_notes_repository.dart';
import '../datasources/goals_remote_datasource.dart';
import '../models/goals_mappers.dart';

@LazySingleton(as: ProgressNotesRepository)
class ProgressNotesRepositoryImpl implements ProgressNotesRepository {
  ProgressNotesRepositoryImpl(this._remote);

  final GoalsRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<ProgressNote>>> listNotes({
    required String memberId,
    String? cursor,
  }) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final page = await _remote.listProgressNotes(
        memberId: intId,
        cursor: cursor,
      );
      return Right(
        CursorPage(
          items: page.data.map((n) => n.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProgressNote>> createNote({
    required String memberId,
    required String noteText,
    required ProgressNoteType noteType,
  }) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final created = await _remote.createProgressNote(
        intId,
        toProgressNoteWrite(noteText: noteText, noteType: noteType),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
