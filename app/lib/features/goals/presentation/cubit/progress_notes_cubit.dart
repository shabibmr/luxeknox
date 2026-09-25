import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/progress_note.dart';
import '../../domain/entities/progress_note_type.dart';
import '../../domain/usecases/progress_notes_usecases.dart';

part 'progress_notes_cubit.freezed.dart';

@freezed
abstract class ProgressNotesState with _$ProgressNotesState {
  const factory ProgressNotesState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ProgressNote>[]) List<ProgressNote> notes,
    @Default(false) bool submitting,
    @Default(false) bool hasMore,
    String? nextCursor,
    Failure? failure,
  }) = _ProgressNotesState;
}

@injectable
class ProgressNotesCubit extends Cubit<ProgressNotesState> {
  ProgressNotesCubit(this._listNotes, this._createNote)
    : super(const ProgressNotesState());

  final ListProgressNotesUseCase _listNotes;
  final CreateProgressNoteUseCase _createNote;

  String? _memberId;
  bool _loaded = false;

  Future<void> load(String memberId) async {
    _memberId = memberId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        submitting: false,
      ),
    );
    final result = await _listNotes(
      ListProgressNotesParams(memberId: memberId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          submitting: false,
        ),
      ),
      (page) {
        _loaded = true;
        final sorted = [...page.items]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            submitting: false,
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
    if (memberId == null ||
        !_loaded ||
        current.status == LoadStatus.loading ||
        current.submitting) {
      return false;
    }
    emit(
      current.copyWith(
        submitting: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );
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
            status: LoadStatus.failure,
            failure: failure,
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
