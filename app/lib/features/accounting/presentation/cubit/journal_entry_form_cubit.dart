import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/journal.dart';
import '../../domain/usecases/create_journal_usecase.dart';

const Object _sentinel = Object();

class JournalLineDraft extends Equatable {
  const JournalLineDraft({
    this.account,
    this.debit = '',
    this.credit = '',
    this.description = '',
  });

  final Account? account;
  final String debit;
  final String credit;
  final String description;

  JournalLineDraft copyWith({
    Object? account = _sentinel,
    String? debit,
    String? credit,
    String? description,
  }) {
    return JournalLineDraft(
      account: identical(account, _sentinel)
          ? this.account
          : (account as Account?),
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [account, debit, credit, description];
}

class JournalEntryFormState extends Equatable {
  JournalEntryFormState({
    this.status = LoadStatus.initial,
    DateTime? entryDate,
    this.sourceType = 'manual',
    this.memo,
    this.lines = const [
      JournalLineDraft(),
      JournalLineDraft(),
    ],
    this.isSubmitting = false,
    this.failure,
    this.createdJournal,
  }) : entryDate = entryDate ?? _defaultDate();

  static DateTime _defaultDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  final LoadStatus status;
  final DateTime entryDate;
  final String sourceType;
  final String? memo;
  final List<JournalLineDraft> lines;
  final bool isSubmitting;
  final Failure? failure;
  final Journal? createdJournal;

  JournalEntryFormState copyWith({
    LoadStatus? status,
    DateTime? entryDate,
    String? sourceType,
    Object? memo = _sentinel,
    List<JournalLineDraft>? lines,
    bool? isSubmitting,
    Object? failure = _sentinel,
    Object? createdJournal = _sentinel,
  }) {
    return JournalEntryFormState(
      status: status ?? this.status,
      entryDate: entryDate ?? this.entryDate,
      sourceType: sourceType ?? this.sourceType,
      memo: identical(memo, _sentinel) ? this.memo : (memo as String?),
      lines: lines ?? this.lines,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      createdJournal: identical(createdJournal, _sentinel)
          ? this.createdJournal
          : (createdJournal as Journal?),
    );
  }

  double get totalDebit => lines.fold<double>(
        0.0,
        (sum, line) => sum + (double.tryParse(line.debit) ?? 0.0),
      );

  double get totalCredit => lines.fold<double>(
        0.0,
        (sum, line) => sum + (double.tryParse(line.credit) ?? 0.0),
      );

  double get difference => (totalDebit - totalCredit).abs();

  bool get isBalanced =>
      totalDebit > 0 &&
      totalCredit > 0 &&
      (totalDebit - totalCredit).abs() < 0.001;

  bool get hasValidLines {
    if (lines.length < 2) return false;
    return lines.every((l) {
      if (l.account == null) return false;
      final d = double.tryParse(l.debit);
      final c = double.tryParse(l.credit);
      final hasDebit = d != null && d > 0 && (c == null || c == 0);
      final hasCredit = c != null && c > 0 && (d == null || d == 0);
      return hasDebit || hasCredit;
    });
  }

  bool get canSubmit => !isSubmitting && hasValidLines && isBalanced;

  @override
  List<Object?> get props => [
        status,
        entryDate,
        sourceType,
        memo,
        lines,
        isSubmitting,
        failure,
        createdJournal,
      ];
}

@injectable
class JournalEntryFormCubit extends Cubit<JournalEntryFormState> {
  JournalEntryFormCubit(this._createJournal)
      : super(JournalEntryFormState());

  final CreateJournalUseCase _createJournal;

  void setEntryDate(DateTime date) {
    emit(state.copyWith(entryDate: date));
  }

  void setSourceType(String sourceType) {
    emit(state.copyWith(sourceType: sourceType));
  }

  void setMemo(String? memo) {
    emit(state.copyWith(memo: memo));
  }

  void addLine() {
    emit(
      state.copyWith(
        lines: [...state.lines, const JournalLineDraft()],
      ),
    );
  }

  void removeLine(int index) {
    if (state.lines.length <= 2) return;
    if (index < 0 || index >= state.lines.length) return;
    final updatedLines = List<JournalLineDraft>.from(state.lines)
      ..removeAt(index);
    emit(state.copyWith(lines: updatedLines));
  }

  void updateLine(
    int index, {
    Object? account = _sentinel,
    String? debit,
    String? credit,
    String? description,
  }) {
    if (index < 0 || index >= state.lines.length) return;
    final current = state.lines[index];

    String newDebit = debit ?? current.debit;
    String newCredit = credit ?? current.credit;

    if (debit != null && credit == null) {
      final d = double.tryParse(debit);
      if (d != null && d > 0) {
        newCredit = '';
      }
    } else if (credit != null && debit == null) {
      final c = double.tryParse(credit);
      if (c != null && c > 0) {
        newDebit = '';
      }
    }

    final updatedLine = current.copyWith(
      account: identical(account, _sentinel)
          ? current.account
          : (account as Account?),
      debit: newDebit,
      credit: newCredit,
      description: description ?? current.description,
    );

    final updatedLines = List<JournalLineDraft>.from(state.lines);
    updatedLines[index] = updatedLine;
    emit(state.copyWith(lines: updatedLines));
  }

  Future<bool> submit() async {
    if (!state.canSubmit) {
      return false;
    }

    emit(state.copyWith(isSubmitting: true, failure: null));

    final mappedLines = state.lines.map((l) {
      return JournalLine(
        id: '',
        journalId: '',
        accountId: l.account!.id,
        accountName: l.account?.name,
        debit: l.debit.isEmpty ? '0' : l.debit,
        credit: l.credit.isEmpty ? '0' : l.credit,
        description: l.description,
      );
    }).toList();

    final result = await _createJournal(
      CreateJournalParams(
        entryDate: state.entryDate,
        sourceType: state.sourceType,
        memo: state.memo,
        lines: mappedLines,
      ),
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            isSubmitting: false,
          ),
        );
        return false;
      },
      (journal) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            createdJournal: journal,
            isSubmitting: false,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
