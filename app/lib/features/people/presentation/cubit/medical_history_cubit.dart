import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/medical_record.dart';
import '../../domain/usecases/create_medical_record_usecase.dart';
import '../../domain/usecases/delete_medical_record_usecase.dart';
import '../../domain/usecases/list_medical_records_usecase.dart';
import '../../domain/usecases/update_medical_record_usecase.dart';

part 'medical_history_cubit.freezed.dart';

@freezed
abstract class MedicalHistoryState with _$MedicalHistoryState {
  const factory MedicalHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MedicalRecord>[]) List<MedicalRecord> records,
    String? message,
    Failure? failure,
  }) = _MedicalHistoryState;
}

class MedicalHistoryCubit extends Cubit<MedicalHistoryState> {
  MedicalHistoryCubit(this._list, this._create, this._update, this._delete)
    : super(const MedicalHistoryState());

  final ListMedicalRecordsUseCase _list;
  final CreateMedicalRecordUseCase _create;
  final UpdateMedicalRecordUseCase _update;
  final DeleteMedicalRecordUseCase _delete;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _list(memberId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (records) => emit(
        state.copyWith(
          status: LoadStatus.success,
          records: records,
          failure: null,
          message: null,
        ),
      ),
    );
  }

  Future<void> add(MedicalRecord record) async {
    final result = await _create(record);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (_) async {
        final id = _memberId;
        if (id != null) await load(id);
      },
    );
  }

  Future<void> save(MedicalRecord record) async {
    final result = await _update(record);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
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
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (_) async => load(memberId),
    );
  }
}
