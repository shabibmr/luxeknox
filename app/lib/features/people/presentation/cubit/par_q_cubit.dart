import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/par_q_inputs.dart';
import '../../domain/entities/par_q_screening.dart';
import '../../domain/usecases/submit_par_q_usecase.dart';

class ParQState extends Equatable {
  final LoadStatus status;
  final ParQScreening? screening;
  final Failure? failure;

  const ParQState({
    this.status = LoadStatus.initial,
    this.screening,
    this.failure,
  });

  bool get isSubmitting => status == LoadStatus.loading;
  bool get isSuccess => status == LoadStatus.success;

  ParQState copyWith({
    LoadStatus? status,
    ParQScreening? screening,
    Failure? failure,
  }) {
    return ParQState(
      status: status ?? this.status,
      screening: screening ?? this.screening,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, screening, failure];
}

@injectable
class ParQCubit extends Cubit<ParQState> {
  ParQCubit(this._submitParQ) : super(const ParQState());

  final SubmitParQUseCase _submitParQ;

  Future<void> submit(ParQSubmission submission) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _submitParQ(submission);
    result.fold(
      (failure) =>
          emit(ParQState(status: LoadStatus.failure, failure: failure)),
      (screening) =>
          emit(ParQState(status: LoadStatus.success, screening: screening)),
    );
  }

  void reset() {
    emit(const ParQState());
  }
}
