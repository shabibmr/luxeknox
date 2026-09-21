import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/usecases/create_emergency_contact_usecase.dart';
import '../../domain/usecases/delete_emergency_contact_usecase.dart';
import '../../domain/usecases/list_emergency_contacts_usecase.dart';
import '../../domain/usecases/update_emergency_contact_usecase.dart';

sealed class EmergencyContactsState extends Equatable {
  const EmergencyContactsState();

  @override
  List<Object?> get props => [];
}

final class EmergencyContactsLoading extends EmergencyContactsState {
  const EmergencyContactsLoading();
}

final class EmergencyContactsLoaded extends EmergencyContactsState {
  const EmergencyContactsLoaded(this.contacts, {this.message});

  final List<EmergencyContact> contacts;
  final String? message;

  @override
  List<Object?> get props => [contacts, message];
}

final class EmergencyContactsFailure extends EmergencyContactsState {
  const EmergencyContactsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class EmergencyContactsCubit extends Cubit<EmergencyContactsState> {
  EmergencyContactsCubit(
    this._list,
    this._create,
    this._update,
    this._delete,
  ) : super(const EmergencyContactsLoading());

  final ListEmergencyContactsUseCase _list;
  final CreateEmergencyContactUseCase _create;
  final UpdateEmergencyContactUseCase _update;
  final DeleteEmergencyContactUseCase _delete;

  int? _userId;

  Future<void> load(int userId) async {
    _userId = userId;
    emit(const EmergencyContactsLoading());
    final result = await _list(userId);
    result.fold(
      (failure) => emit(EmergencyContactsFailure(_message(failure))),
      (contacts) => emit(EmergencyContactsLoaded(contacts)),
    );
  }

  Future<void> add(EmergencyContact contact) async {
    final result = await _create(contact);
    await result.fold(
      (failure) async => emit(EmergencyContactsFailure(_message(failure))),
      (_) async {
        final id = _userId;
        if (id != null) await load(id);
      },
    );
  }

  Future<void> save(EmergencyContact contact) async {
    final result = await _update(contact);
    await result.fold(
      (failure) async => emit(EmergencyContactsFailure(_message(failure))),
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
      (failure) async => emit(EmergencyContactsFailure(_message(failure))),
      (_) async => load(userId),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
