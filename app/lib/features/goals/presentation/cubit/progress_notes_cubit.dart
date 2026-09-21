import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/progress_note.dart';
import '../../domain/entities/progress_note_type.dart';
import '../../domain/usecases/progress_notes_usecases.dart';

sealed class ProgressNotesState extends Equatable {
  const ProgressNotesState();

  @override
  List<Object?> get props => [];
}

final class ProgressNotesLoading extends ProgressNotesState {
  const ProgressNotesLoading();
}

final class ProgressNotesLoaded extends ProgressNotesState {
  const ProgressNotesLoaded({
    required this.notes,
    this.submitting = false,
    this.error,
    this.hasMore = false,
    this.nextCursor,
  });

  final List<ProgressNote> notes;
  final bool submitting;
  final String? error;
  final bool hasMore;
  final String? nextCursor;

  ProgressNotesLoaded copyWith({
    List<ProgressNote>? notes,
    bool? submitting,
    String? error,
    bool? hasMore,
    String? nextCursor,
  }) {
    return ProgressNotesLoaded(
      notes: notes ?? this.notes,
      submitting: submitting ?? this.submitting,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  @override
  List<Object?> get props => [notes, submitting, error, hasMore, nextCursor];
}

final class ProgressNotesFailure extends ProgressNotesState {
  const ProgressNotesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class ProgressNotesCubit extends Cubit<ProgressNotesState> {
  ProgressNotesCubit(this._listNotes, this._createNote)
    : super(const ProgressNotesLoading());

  final ListProgressNotesUseCase _listNotes;
  final CreateProgressNoteUseCase _createNote;

  String? _memberId;

  Future<void> load(String memberId) async {
    _memberId = memberId;
    emit(const ProgressNotesLoading());
    final result = await _listNotes(
      ListProgressNotesParams(memberId: memberId),
    );
    result.fold(
      (failure) => emit(ProgressNotesFailure(failureMessage(failure))),
      (page) {
        final sorted = [...page.items]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(
          ProgressNotesLoaded(
            notes: sorted,
            hasMore: page.hasMore,
            nextCursor: page.nextCursor,
          ),
        );
      },
    );
  }

  Future<bool> addNote({
    required String noteText,
    required ProgressNoteType noteType,
  }) async {
    final memberId = _memberId;
    final current = state;
    if (memberId == null || current is! ProgressNotesLoaded) return false;
    emit(current.copyWith(submitting: true, error: null));
    final result = await _createNote(
      CreateProgressNoteParams(
        memberId: memberId,
        noteText: noteText,
        noteType: noteType,
      ),
    );
    return result.fold(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            error: failureMessage(failure),
          ),
        );
        return false;
      },
      (_) async {
        await load(memberId);
        return true;
      },
    );
  }
}
