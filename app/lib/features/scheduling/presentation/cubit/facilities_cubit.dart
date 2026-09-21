import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';

sealed class FacilitiesState extends Equatable {
  const FacilitiesState();

  @override
  List<Object?> get props => [];
}

final class FacilitiesLoading extends FacilitiesState {
  const FacilitiesLoading();
}

final class FacilitiesLoaded extends FacilitiesState {
  const FacilitiesLoaded(this.items, {this.creating = false, this.message});

  final List<FacilityInfo> items;
  final bool creating;
  final String? message;

  @override
  List<Object?> get props => [items, creating, message];
}

final class FacilitiesFailure extends FacilitiesState {
  const FacilitiesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class FacilitiesCubit extends Cubit<FacilitiesState> {
  FacilitiesCubit(this._list, this._create) : super(const FacilitiesLoading());

  final ListFacilitiesUseCase _list;
  final CreateFacilityUseCase _create;

  Future<void> load() async {
    emit(const FacilitiesLoading());
    final result = await _list(const NoParams());
    result.fold(
      (failure) => emit(FacilitiesFailure(failureMessage(failure))),
      (items) => emit(FacilitiesLoaded(items)),
    );
  }

  Future<void> create({
    required String name,
    int? capacity,
    String? locationDetails,
  }) async {
    final current = state;
    if (current is! FacilitiesLoaded || current.creating) return;
    emit(FacilitiesLoaded(current.items, creating: true));
    final result = await _create(
      CreateFacilityParams(
        name: name,
        capacity: capacity,
        locationDetails: locationDetails,
        isActive: true,
      ),
    );
    result.fold(
      (failure) => emit(
        FacilitiesLoaded(
          current.items,
          message: failureMessage(failure),
        ),
      ),
      (_) => load(),
    );
  }
}
