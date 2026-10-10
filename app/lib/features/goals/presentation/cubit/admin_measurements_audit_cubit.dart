import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/usecases/measurements_usecases.dart';

part 'admin_measurements_audit_cubit.freezed.dart';

@freezed
abstract class AdminMeasurementsAuditState with _$AdminMeasurementsAuditState {
  const factory AdminMeasurementsAuditState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MeasurementSession>[]) List<MeasurementSession> items,
    Failure? failure,
  }) = _AdminMeasurementsAuditState;
}

@injectable
class AdminMeasurementsAuditCubit extends Cubit<AdminMeasurementsAuditState> {
  AdminMeasurementsAuditCubit(this._listAll)
    : super(const AdminMeasurementsAuditState());

  final ListAllMeasurementsUseCase _listAll;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _listAll(const ListAllMeasurementsParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          items: page.items,
        ),
      ),
    );
  }
}
