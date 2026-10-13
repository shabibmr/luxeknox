import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/journal.dart';
import '../../domain/usecases/get_journal_usecase.dart';
import '../../domain/usecases/reverse_journal_usecase.dart';

const Object _sentinel = Object();

class JournalDetailState extends Equatable {
  const JournalDetailState({
    this.status = LoadStatus.initial,
    this.journal,
    this.isReversing = false,
    this.failure,
    this.reversalSuccess,
  });

  final LoadStatus status;
  final Journal? journal;
  final bool isReversing;
  final Failure? failure;
  final Journal? reversalSuccess;

  JournalDetailState copyWith({
    LoadStatus? status,
    Object? journal = _sentinel,
    bool? isReversing,
    Object? failure = _sentinel,
    Object? reversalSuccess = _sentinel,
  }) {
    return JournalDetailState(
      status: status ?? this.status,
      journal: identical(journal, _sentinel)
          ? this.journal
          : (journal as Journal?),
      isReversing: isReversing ?? this.isReversing,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      reversalSuccess: identical(reversalSuccess, _sentinel)
          ? this.reversalSuccess
          : (reversalSuccess as Journal?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        journal,
        isReversing,
        failure,
        reversalSuccess,
      ];
}

@injectable
class JournalDetailCubit extends Cubit<JournalDetailState> {
  JournalDetailCubit(
    this._getJournal,
    this._reverseJournal,
  ) : super(const JournalDetailState());

  final GetJournalUseCase _getJournal;
  final ReverseJournalUseCase _reverseJournal;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getJournal(GetJournalParams(id: id));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (journal) => emit(
        state.copyWith(
          status: LoadStatus.success,
          journal: journal,
          failure: null,
        ),
      ),
    );
  }

  void setJournal(Journal journal) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        journal: journal,
        failure: null,
      ),
    );
  }

  Future<bool> reverse({DateTime? entryDate, String? memo}) async {
    final currentJournal = state.journal;
    if (currentJournal == null) return false;

    emit(state.copyWith(isReversing: true, failure: null, reversalSuccess: null));

    final result = await _reverseJournal(
      ReverseJournalParams(
        id: currentJournal.id,
        entryDate: entryDate,
        memo: memo,
      ),
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isReversing: false,
            failure: failure,
          ),
        );
        return false;
      },
      (reversedJournal) {
        emit(
          state.copyWith(
            isReversing: false,
            journal: reversedJournal,
            reversalSuccess: reversedJournal,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
