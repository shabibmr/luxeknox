import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:luxeknox/core/pagination/cursor_page.dart';
import 'package:luxeknox/core/presentation/load_status.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_history.dart';
import 'package:luxeknox/features/goals/domain/entities/goal_status.dart';
import 'package:luxeknox/features/goals/domain/entities/member_goal.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note.dart';
import 'package:luxeknox/features/goals/domain/entities/progress_note_type.dart';
import 'package:luxeknox/features/goals/domain/usecases/goals_usecases.dart';
import 'package:luxeknox/features/goals/domain/usecases/progress_notes_usecases.dart';
import 'package:luxeknox/features/goals/presentation/cubit/goal_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetGoal extends Mock implements GetGoalUseCase {}

class _MockCheckIn extends Mock implements CheckInGoalUseCase {}

class _MockListNotes extends Mock implements ListProgressNotesUseCase {}

void main() {
  late _MockGetGoal getGoal;
  late _MockCheckIn checkIn;
  late _MockListNotes listNotes;

  const goal = MemberGoal(
    id: '1',
    memberId: '9',
    metricId: '4',
    baselineValue: 80,
    targetValue: 70,
    currentValue: 76,
    status: GoalStatus.inProgress,
  );

  setUp(() {
    getGoal = _MockGetGoal();
    checkIn = _MockCheckIn();
    listNotes = _MockListNotes();
    registerFallbackValue(const ListProgressNotesParams(memberId: '0'));
    registerFallbackValue(
      const CheckInGoalParams(id: '0', recordedValue: 0),
    );
  });

  blocTest<GoalDetailCubit, GoalDetailState>(
    'load keeps only trainer_assessment notes as coach notes',
    build: () {
      when(() => getGoal(any())).thenAnswer((_) async => const Right(goal));
      when(() => listNotes(any())).thenAnswer(
        (_) async => Right(
          CursorPage(
            items: [
              ProgressNote(
                id: 'a',
                memberId: '9',
                authorUserId: '2',
                noteText: 'Coach: tighten form',
                noteType: ProgressNoteType.trainerAssessment,
                createdAt: DateTime(2026, 1, 5),
              ),
              ProgressNote(
                id: 'b',
                memberId: '9',
                authorUserId: '9',
                noteText: 'Feeling good',
                noteType: ProgressNoteType.memberNote,
                createdAt: DateTime(2026, 1, 4),
              ),
            ],
            nextCursor: null,
            hasMore: false,
          ),
        ),
      );
      return GoalDetailCubit(getGoal, checkIn, listNotes);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      isA<GoalDetailState>().having(
        (s) => s.status,
        'status',
        LoadStatus.loading,
      ),
      isA<GoalDetailState>()
          .having((s) => s.status, 'status', LoadStatus.success)
          .having((s) => s.goal?.id, 'goalId', '1'),
      isA<GoalDetailState>().having(
        (s) => s.notesStatus,
        'notesStatus',
        LoadStatus.loading,
      ),
      isA<GoalDetailState>()
          .having((s) => s.notesStatus, 'notesStatus', LoadStatus.success)
          .having((s) => s.coachNotes.length, 'coachCount', 1)
          .having(
            (s) => s.coachNotes.single.noteText,
            'coachText',
            'Coach: tighten form',
          ),
    ],
  );

  blocTest<GoalDetailCubit, GoalDetailState>(
    'check-in success updates current_value and history',
    build: () {
      var loads = 0;
      when(() => getGoal(any())).thenAnswer((_) async {
        loads++;
        if (loads == 1) {
          return const Right(goal);
        }
        return Right(
          MemberGoal(
            id: '1',
            memberId: '9',
            metricId: '4',
            baselineValue: 80,
            targetValue: 70,
            currentValue: 74,
            status: GoalStatus.inProgress,
            history: [
              GoalHistoryEntry(
                id: 'h1',
                goalId: '1',
                recordedValue: 74,
                recordedDate: DateTime(2026, 3, 1),
              ),
            ],
          ),
        );
      });
      when(() => checkIn(any())).thenAnswer(
        (_) async => Right(
          GoalHistoryEntry(
            id: 'h1',
            goalId: '1',
            recordedValue: 74,
            recordedDate: DateTime(2026, 3, 1),
          ),
        ),
      );
      when(() => listNotes(any())).thenAnswer(
        (_) async => const Right(
          CursorPage(items: [], nextCursor: null, hasMore: false),
        ),
      );
      return GoalDetailCubit(getGoal, checkIn, listNotes);
    },
    act: (cubit) async {
      await cubit.load('1');
      await cubit.submitCheckIn(recordedValue: 74);
    },
    verify: (cubit) {
      expect(cubit.state.goal?.currentValue, 74);
      expect(cubit.state.goal?.history.length, 1);
      expect(cubit.state.goal?.history.single.recordedValue, 74);
      expect(cubit.state.submitting, isFalse);
      expect(cubit.state.status, LoadStatus.success);
    },
  );
}
