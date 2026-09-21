import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/medical_record.dart';
import '../../domain/usecases/create_medical_record_usecase.dart';
import '../../domain/usecases/delete_medical_record_usecase.dart';
import '../../domain/usecases/list_medical_records_usecase.dart';
import '../../domain/usecases/update_medical_record_usecase.dart';

sealed class MedicalHistoryState extends Equatable {
  const MedicalHistoryState();

  @override
  List<Object?> get props => [];
}

final class MedicalHistoryLoading extends MedicalHistoryState {
  const MedicalHistoryLoading();
}

final class MedicalHistoryLoaded extends MedicalHistoryState {
  const MedicalHistoryLoaded(this.records, {this.message});

  final List<MedicalRecord> records;
  final String? message;

  @override
  List<Object?> get props => [records, message];
}

final class MedicalHistoryFailure extends MedicalHistoryState {
  const MedicalHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  MedicalHistoryCubit(
    this._list,
    this._create,
    this._update,
    this._delete,
  ) : super(const MedicalHistoryLoading());

  final ListMedicalRecordsUseCase _list;
  final CreateMedicalRecordUseCase _create;
  final UpdateMedicalRecordUseCase _update;
  final DeleteMedicalRecordUseCase _delete;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(const MedicalHistoryLoading());
    final result = await _list(memberId);
    result.fold(
      (failure) => emit(MedicalHistoryFailure(_message(failure))),
      (records) => emit(MedicalHistoryLoaded(records)),
    );
  }

  Future<void> add(MedicalRecord record) async {
    final result = await _create(record);
    await result.fold(
      (failure) async => emit(MedicalHistoryFailure(_message(failure))),
      (_) async {
        final id = _memberId;
        if (id != null) await load(id);
      },
    );
  }

  Future<void> save(MedicalRecord record) async {
    final result = await _update(record);
    await result.fold(
      (failure) async => emit(MedicalHistoryFailure(_message(failure))),
      (_) async {
        final id = _memberId;
        if (id != null) await load(id);
      },
    );
  }

  Future<void> remove(int recordId) async {
    final memberId = _memberId;
    if (memberId == null) return;
    final result = await _delete(
      DeleteMedicalRecordParams(memberId: memberId, recordId: recordId),
    );
    await result.fold(
      (failure) async => emit(MedicalHistoryFailure(_message(failure))),
      (_) async => load(memberId),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
