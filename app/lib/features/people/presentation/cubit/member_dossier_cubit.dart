import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../attendance/domain/usecases/attendance_usecases.dart';
import '../../../membership/domain/entities/membership.dart';
import '../../../membership/domain/usecases/get_memberships_usecase.dart';
import '../../../scheduling/domain/entities/schedule_enums.dart';
import '../../../scheduling/domain/entities/schedule_session.dart';
import '../../../scheduling/domain/usecases/schedule_usecases.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/usecases/assign_trainer_usecase.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/get_trainer_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';
import '../member_dossier_pt.dart';

part 'member_dossier_cubit.freezed.dart';

@freezed
abstract class MemberDossierState with _$MemberDossierState {
  const factory MemberDossierState({
    @Default(LoadStatus.initial) LoadStatus status,
    Person? person,
    Membership? membership,
    @Default(false) bool hasPtPackage,
    @Default(false) bool ptExpired,
    int? visitsThisMonth,
    @Default(false) bool membershipsUnavailable,
    TrainerProfile? assignedTrainer,
    ScheduleSession? nextSchedule,
    @Default(false) bool editingProfile,
    String? message,
    Failure? failure,
  }) = _MemberDossierState;
}

@injectable
class MemberDossierCubit extends Cubit<MemberDossierState> {
  MemberDossierCubit(
    this._getMember,
    this._updateMember,
    this._assignTrainer,
    this._getMemberships,
    this._getAttendanceSummary,
    this._getTrainer,
    this._listSchedules,
  ) : super(const MemberDossierState());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;
  final AssignTrainerUseCase _assignTrainer;
  final GetMembershipsUseCase _getMemberships;
  final GetAttendanceSummaryUseCase _getAttendanceSummary;
  final GetTrainerUseCase _getTrainer;
  final ListSchedulesUseCase _listSchedules;

  void setEditing(bool editing) {
    emit(state.copyWith(editingProfile: editing, message: null));
  }

  Future<void> load(int memberId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        message: null,
        editingProfile: false,
        membershipsUnavailable: false,
      ),
    );
    final result = await _getMember(memberId);
    if (isClosed) return;
    await result.fold(
      (failure) async {
        emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      },
      (person) async {
        await _loadExtras(person);
      },
    );
  }

  Future<void> _loadExtras(Person person) async {
    final memberIdStr = person.id.toString();
    final now = DateTime.now();

    final membershipsFuture = _getMemberships(
      GetMembershipsParams(memberId: memberIdStr, limit: 20),
    );
    final attendanceFuture = _getAttendanceSummary(
      GetAttendanceSummaryParams(memberId: memberIdStr),
    );
    final schedulesFuture = _listSchedules(
      ListSchedulesParams(
        memberId: memberIdStr,
        from: now,
        to: now.add(const Duration(days: 60)),
        limit: 50,
      ),
    );
    final trainerFuture = person.assignedTrainerId == null
        ? Future<TrainerProfile?>.value(null)
        : _getTrainer(person.assignedTrainerId!).then(
            (r) => r.fold((_) => null, (t) => t),
          );

    final membershipsResult = await membershipsFuture;
    final attendanceResult = await attendanceFuture;
    final schedulesResult = await schedulesFuture;
    final trainer = await trainerFuture;
    if (isClosed) return;

    Failure? membershipsFailure;
    Membership? membership;
    membershipsResult.fold(
      (failure) => membershipsFailure = failure,
      (page) => membership = preferActiveMembership(page.items),
    );

    final visits = attendanceResult.fold(
      (_) => null,
      (summary) => summary.visitsThisMonth,
    );

    final nextSchedule = schedulesResult.fold(
      (_) => null,
      (page) => _pickNextSchedule(page.items, now),
    );

    final hasPt = isPtPurchased(membership);
    final expired = isPtExpired(membership);

    emit(
      state.copyWith(
        status: membershipsFailure != null
            ? LoadStatus.failure
            : LoadStatus.success,
        person: person,
        membership: membership,
        hasPtPackage: hasPt,
        ptExpired: expired,
        visitsThisMonth: visits,
        membershipsUnavailable: membershipsFailure != null,
        assignedTrainer: trainer,
        nextSchedule: nextSchedule,
        failure: membershipsFailure,
        message: null,
      ),
    );
  }

  Future<void> save(Person person) async {
    final result = await _updateMember(person);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          person: updated,
          editingProfile: false,
          message: 'saved',
          failure: null,
        ),
      ),
    );
  }

  Future<void> assignTrainer({
    required int memberId,
    required int trainerId,
  }) async {
    final result = await _assignTrainer(
      AssignTrainerParams(memberId: memberId, trainerId: trainerId),
    );
    if (isClosed) return;
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            message: null,
          ),
        );
      },
      (updated) async {
        final trainerResult = await _getTrainer(trainerId);
        if (isClosed) return;
        final trainer = trainerResult.fold((_) => null, (t) => t);
        emit(
          state.copyWith(
            status: LoadStatus.success,
            person: updated,
            assignedTrainer: trainer,
            message: 'assigned',
            failure: null,
          ),
        );
      },
    );
  }
}

ScheduleSession? _pickNextSchedule(List<ScheduleSession> items, DateTime now) {
  final upcoming =
      items
          .where(
            (s) =>
                s.startTime.isAfter(now) &&
                (s.status == ScheduleSessionStatus.scheduled ||
                    s.status == ScheduleSessionStatus.ongoing),
          )
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
  if (upcoming.isEmpty) return null;
  return upcoming.first;
}
