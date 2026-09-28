import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/usecases/create_emergency_contact_usecase.dart';
import '../../domain/usecases/delete_emergency_contact_usecase.dart';
import '../../domain/usecases/list_emergency_contacts_usecase.dart';
import '../../domain/usecases/update_emergency_contact_usecase.dart';

part 'emergency_contacts_cubit.freezed.dart';

@freezed
abstract class EmergencyContactsState with _$EmergencyContactsState {
  const factory EmergencyContactsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<EmergencyContact>[]) List<EmergencyContact> contacts,
    String? message,
    Failure? failure,
  }) = _EmergencyContactsState;
}

class EmergencyContactsCubit extends Cubit<EmergencyContactsState> {
  EmergencyContactsCubit(this._list, this._create, this._update, this._delete)
    : super(const EmergencyContactsState());

  final ListEmergencyContactsUseCase _list;
  final CreateEmergencyContactUseCase _create;
  final UpdateEmergencyContactUseCase _update;
  final DeleteEmergencyContactUseCase _delete;

  int? _userId;

  Future<void> load(int userId) async {
    _userId = userId;
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _list(userId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (contacts) => emit(
        state.copyWith(
          status: LoadStatus.success,
          contacts: contacts,
          failure: null,
          message: null,
        ),
      ),
    );
  }

  Future<void> add(EmergencyContact contact) async {
    final result = await _create(contact);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (_) async {
        final id = _userId;
        if (id != null) await load(id);
      },
    );
  }

  Future<void> save(EmergencyContact contact) async {
    final result = await _update(contact);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (_) async {
        final id = _userId;
        if (id != null) await load(id);
      },
    );
  }

  Future<void> remove(int contactId) async {
    final userId = _userId;
    if (userId == null) return;
    final result = await _delete(
      DeleteEmergencyContactParams(userId: userId, contactId: contactId),
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (_) async => load(userId),
    );
  }
}
